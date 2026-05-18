import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/ordo_colors.dart';
import '../../../../core/theme/ordo_radius.dart';
import '../../../../core/theme/ordo_spacing.dart';
import '../../../../core/theme/ordo_typography.dart';
import '../../../../shared/utils/formatters.dart';
import '../../../../shared/widgets/bottom_nav.dart';
import '../../../../shared/widgets/kpi_card.dart';
import '../../../../shared/widgets/ordo_icon.dart';
import '../../../../shared/widgets/os_card.dart';
import '../../../../shared/widgets/top_bar.dart';
import '../../../setup/presentation/controllers/setup_controller.dart';
import '../../domain/entities/os_status.dart';
import '../controllers/service_orders_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _setup = Get.find<SetupController>();
  final _orders = Get.find<ServiceOrdersController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _orders.load());
  }

  void _onTab(OrdoTab tab) {
    switch (tab) {
      case OrdoTab.home:
        break;
      case OrdoTab.list:
        Get.offNamed(AppRoutes.osList);
        break;
      case OrdoTab.clients:
        Get.offNamed(AppRoutes.clients);
        break;
      case OrdoTab.settings:
        Get.offNamed(AppRoutes.settings);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OrdoColors.bg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(76),
        child: Obx(() {
          final shop = _setup.current.value;
          final shopName = shop?.shopName ?? 'Ordo';
          final shopSubtitle = shop?.shopSubtitle ?? 'sua oficina, sob controle';
          return OrdoTopBar(
            title: 'Boa tarde, Bruno',
            subtitle: '$shopName · $shopSubtitle',
            leading: SvgPicture.asset(
              'assets/svg/logo-mark.svg',
              width: 36,
              height: 36,
            ),
            trailing: [
              OrdoIconButton(
                badgeColor: OrdoColors.lime,
                onTap: () {},
                child: const OrdoIcon(
                  OrdoIconName.bell,
                  size: 20,
                  color: OrdoColors.ink,
                ),
              ),
            ],
          );
        }),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            color: OrdoColors.ink,
            backgroundColor: OrdoColors.paper,
            onRefresh: _orders.load,
            child: Obx(() {
              final loading = _orders.loading.value;
              final items = _orders.items;
              final recent = items.take(4).toList();

              final faturadoHoje = items
                  .where((o) =>
                      o.status == OsStatus.entregue &&
                      o.updatedAt.day == DateTime.now().day &&
                      o.updatedAt.month == DateTime.now().month)
                  .fold<int>(0, (sum, o) => sum + o.valueCents);

              return ListView(
                padding: const EdgeInsets.fromLTRB(
                  OrdoSpacing.screenPadding,
                  8,
                  OrdoSpacing.screenPadding,
                  140,
                ),
                children: [
                  _KpiGrid(
                    andamento: _orders.countAndamento,
                    aguardando: _orders.countAguardando,
                    prontas: _orders.countProntas,
                    faturado: faturadoHoje,
                  ),
                  if (_orders.countStale > 0) ...[
                    const SizedBox(height: OrdoSpacing.s4),
                    _StaleBanner(count: _orders.countStale),
                  ],
                  const SizedBox(height: OrdoSpacing.s4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'OS recentes',
                        style: OrdoTypography.display(
                          size: 16,
                          weight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => Get.toNamed(AppRoutes.osList),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Ver todas',
                              style: OrdoTypography.body(
                                size: 12,
                                weight: FontWeight.w500,
                                color: OrdoColors.fg2,
                              ),
                            ),
                            const SizedBox(width: 2),
                            const OrdoIcon(
                              OrdoIconName.chevronRight,
                              size: 14,
                              color: OrdoColors.fg2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (loading && recent.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: CircularProgressIndicator(color: OrdoColors.ink),
                      ),
                    )
                  else if (recent.isEmpty)
                    const _EmptyState(
                      text:
                          'Nenhuma OS aberta esta semana.\nToque em + para abrir a primeira.',
                    )
                  else
                    for (final os in recent) ...[
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
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: OrdoBottomNav(
              active: OrdoTab.home,
              onSelect: _onTab,
              onNew: () => Get.toNamed(AppRoutes.novaOs),
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiGrid extends StatelessWidget {
  final int andamento;
  final int aguardando;
  final int prontas;
  final int faturado;

  const _KpiGrid({
    required this.andamento,
    required this.aguardando,
    required this.prontas,
    required this.faturado,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: KpiCard(
                label: 'Em andamento',
                value: '$andamento',
                trend: andamento > 0 ? '+$andamento' : null,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: KpiCard(
                label: 'Aguard. peça',
                value: '$aguardando',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: KpiCard(
                label: 'Prontas',
                value: '$prontas',
                highlight: true,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: KpiCard(
                label: 'Faturado hoje',
                value: OrdoFormatters.brl(faturado),
                mono: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StaleBanner extends StatelessWidget {
  final int count;
  const _StaleBanner({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: OrdoColors.amberSoft,
        borderRadius: BorderRadius.circular(OrdoRadius.md),
        border: const Border(
          left: BorderSide(color: OrdoColors.amber, width: 3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const OrdoIcon(
            OrdoIconName.alertTriangle,
            size: 18,
            color: Color(0xFF9A6206),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$count OS sem atualização há mais de 48h',
                  style: OrdoTypography.body(
                    size: 13,
                    weight: FontWeight.w600,
                    color: const Color(0xFF9A6206),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  'Revise para manter o cliente informado.',
                  style: OrdoTypography.body(
                    size: 11,
                    color: const Color(0xFF9A6206),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String text;
  const _EmptyState({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: OrdoColors.paper,
        borderRadius: BorderRadius.circular(OrdoRadius.md),
        border: Border.all(color: OrdoColors.border),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: OrdoTypography.body(size: 13, color: OrdoColors.fg2),
      ),
    );
  }
}
