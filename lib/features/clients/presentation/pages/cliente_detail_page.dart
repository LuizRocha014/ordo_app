import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/ordo_colors.dart';
import '../../../../core/theme/ordo_radius.dart';
import '../../../../core/theme/ordo_spacing.dart';
import '../../../../core/theme/ordo_typography.dart';
import '../../../../shared/utils/formatters.dart';
import '../../../../shared/widgets/ordo_icon.dart';
import '../../../../shared/widgets/os_card.dart';
import '../../../../shared/widgets/top_bar.dart';
import '../../../service_order/domain/entities/os_status.dart';
import '../controllers/client_detail_controller.dart';

class ClienteDetailPage extends StatefulWidget {
  final String clientId;

  const ClienteDetailPage({super.key, required this.clientId});

  @override
  State<ClienteDetailPage> createState() => _ClienteDetailPageState();
}

class _ClienteDetailPageState extends State<ClienteDetailPage> {
  final _controller = Get.find<ClientDetailController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.load(widget.clientId);
    });
  }

  void _snackTodo(String label) {
    Get.snackbar(
      label,
      'Disponível em breve.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OrdoColors.bg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(76),
        child: Obx(() {
          final c = _controller.client.value;
          return OrdoTopBar(
            title: 'Cliente',
            subtitle: c?.name ?? '',
            leading: OrdoIconButton(
              ghost: true,
              onTap: Get.back,
              child: const OrdoIcon(OrdoIconName.chevronLeft, size: 22),
            ),
          );
        }),
      ),
      body: Obx(() {
        final loading = _controller.loading.value;
        final client = _controller.client.value;
        if (loading && client == null) {
          return const Center(
            child: CircularProgressIndicator(color: OrdoColors.ink),
          );
        }
        if (client == null) {
          return Center(
            child: Text(
              _controller.error.value ?? 'Cliente não encontrado.',
              style: OrdoTypography.body(size: 13, color: OrdoColors.fg2),
            ),
          );
        }

        final orders = _controller.orders;
        final totalCents = orders.fold<int>(0, (s, o) => s + o.valueCents);
        final emAndamento =
            orders.where((o) => o.status == OsStatus.andamento).length;
        final entregues =
            orders.where((o) => o.status == OsStatus.entregue).length;

        return ListView(
          padding: const EdgeInsets.fromLTRB(
            OrdoSpacing.screenPadding,
            0,
            OrdoSpacing.screenPadding,
            OrdoSpacing.s8,
          ),
          children: [
            _ProfileHero(
              initials: client.initials,
              name: client.name,
              phone: client.phone,
              onCall: () => _snackTodo('Ligar'),
              onWhats: () => _snackTodo('WhatsApp'),
            ),
            const SizedBox(height: OrdoSpacing.s4),
            _StatStrip(
              totalOs: orders.length,
              andamento: emAndamento,
              entregues: entregues,
              valorTotal: totalCents,
            ),
            const SizedBox(height: OrdoSpacing.s5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Histórico de OS',
                  style: OrdoTypography.display(
                    size: 16,
                    weight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${orders.length} no total',
                  style: OrdoTypography.body(
                    size: 12,
                    color: OrdoColors.fg2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (orders.isEmpty)
              _EmptyHistory(onNew: () => Get.toNamed(AppRoutes.novaOs))
            else
              for (final os in orders) ...[
                OSCard(
                  order: os,
                  onTap: () => Get.toNamed(
                    AppRoutes.osDetail,
                    arguments: os.id,
                  ),
                ),
                const SizedBox(height: 8),
              ],
          ],
        );
      }),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  final String initials;
  final String name;
  final String phone;
  final VoidCallback onCall;
  final VoidCallback onWhats;

  const _ProfileHero({
    required this.initials,
    required this.name,
    required this.phone,
    required this.onCall,
    required this.onWhats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: OrdoColors.ink,
        borderRadius: BorderRadius.circular(OrdoRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: OrdoColors.lime,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  initials,
                  style: OrdoTypography.display(
                    size: 20,
                    weight: FontWeight.w700,
                    color: OrdoColors.ink,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: OrdoTypography.display(
                        size: 18,
                        weight: FontWeight.w600,
                        color: OrdoColors.bone,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      phone,
                      style: OrdoTypography.mono(
                        size: 13,
                        color: OrdoColors.slate400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _HeroAction(
                  icon: OrdoIconName.phone,
                  label: 'Ligar',
                  onTap: onCall,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _HeroAction(
                  icon: OrdoIconName.messageCircle,
                  label: 'WhatsApp',
                  onTap: onWhats,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroAction extends StatelessWidget {
  final OrdoIconName icon;
  final String label;
  final VoidCallback onTap;

  const _HeroAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: OrdoColors.slate800,
          borderRadius: BorderRadius.circular(OrdoRadius.sm),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            OrdoIcon(icon, size: 16, color: OrdoColors.bone),
            const SizedBox(width: 8),
            Text(
              label,
              style: OrdoTypography.body(
                size: 13,
                weight: FontWeight.w600,
                color: OrdoColors.bone,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatStrip extends StatelessWidget {
  final int totalOs;
  final int andamento;
  final int entregues;
  final int valorTotal;

  const _StatStrip({
    required this.totalOs,
    required this.andamento,
    required this.entregues,
    required this.valorTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: OrdoColors.paper,
        borderRadius: BorderRadius.circular(OrdoRadius.md),
        border: Border.all(color: OrdoColors.border),
      ),
      child: Row(
        children: [
          _StatCell(label: 'Total OS', value: '$totalOs'),
          _Divider(),
          _StatCell(label: 'Em andamento', value: '$andamento'),
          _Divider(),
          _StatCell(label: 'Entregues', value: '$entregues'),
          _Divider(),
          _StatCell(
            label: 'Valor total',
            value: OrdoFormatters.brl(valorTotal),
            mono: true,
            flex: 2,
          ),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final bool mono;
  final int flex;

  const _StatCell({
    required this.label,
    required this.value,
    this.mono = false,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: mono
                ? OrdoTypography.mono(size: 14, weight: FontWeight.w600)
                : OrdoTypography.display(size: 18, weight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: OrdoTypography.body(
              size: 10,
              weight: FontWeight.w500,
              color: OrdoColors.fg3,
              letterSpacing: 0.6,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: OrdoColors.border,
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  final VoidCallback onNew;

  const _EmptyHistory({required this.onNew});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: OrdoColors.paper,
        borderRadius: BorderRadius.circular(OrdoRadius.md),
        border: Border.all(color: OrdoColors.border),
      ),
      child: Column(
        children: [
          Text(
            'Esse cliente ainda não tem OS.',
            style: OrdoTypography.body(size: 13, color: OrdoColors.fg2),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onNew,
            child: Text(
              'Abrir uma agora',
              style: OrdoTypography.body(
                size: 13,
                weight: FontWeight.w600,
                color: OrdoColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
