import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/ordo_colors.dart';
import '../../../../core/theme/ordo_spacing.dart';
import '../../../../core/theme/ordo_typography.dart';
import '../../../../shared/widgets/bottom_nav.dart';
import '../../../../shared/widgets/ordo_icon.dart';
import '../../../../shared/widgets/os_card.dart';
import '../../../../shared/widgets/top_bar.dart';
import '../../../setup/presentation/controllers/setup_controller.dart';
import '../../domain/entities/os_status.dart';
import '../controllers/service_orders_controller.dart';

class OsListPage extends StatefulWidget {
  const OsListPage({super.key});

  @override
  State<OsListPage> createState() => _OsListPageState();
}

class _OsListPageState extends State<OsListPage> {
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
        Get.offNamed(AppRoutes.home);
        break;
      case OrdoTab.list:
      case OrdoTab.clients:
      case OrdoTab.settings:
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
          final productPlural = shop?.productNounPlural ?? 'serviços';
          return OrdoTopBar(
            title: 'OS de $productPlural',
            subtitle: '${_orders.items.length} resultados',
            leading: OrdoIconButton(
              ghost: true,
              onTap: Get.back,
              child: const OrdoIcon(OrdoIconName.chevronLeft, size: 22),
            ),
            trailing: [
              OrdoIconButton(
                onTap: () {},
                child: const OrdoIcon(OrdoIconName.search, size: 20),
              ),
            ],
          );
        }),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 6),
              Obx(() => _FilterBar(
                    active: _orders.statusFilter.value,
                    onChange: _orders.setStatusFilter,
                  )),
              Expanded(
                child: Obx(() {
                  final loading = _orders.loading.value;
                  final items = _orders.items;
                  if (loading && items.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(color: OrdoColors.ink),
                    );
                  }
                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        'Nenhuma OS para este filtro.',
                        style: OrdoTypography.body(
                          size: 13,
                          color: OrdoColors.fg2,
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      OrdoSpacing.screenPadding,
                      0,
                      OrdoSpacing.screenPadding,
                      140,
                    ),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      final os = items[i];
                      return OSCard(
                        order: os,
                        onTap: () => Get.toNamed(
                          AppRoutes.osDetail,
                          arguments: os.id,
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: OrdoBottomNav(
              active: OrdoTab.list,
              onSelect: _onTab,
              onNew: () => Get.toNamed(AppRoutes.novaOs),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final OsStatus? active;
  final ValueChanged<OsStatus?> onChange;

  const _FilterBar({required this.active, required this.onChange});

  static const _filters = [
    (null, 'Todas'),
    (OsStatus.andamento, 'Em andamento'),
    (OsStatus.aguardando, 'Aguard. peça'),
    (OsStatus.pronta, 'Prontas'),
    (OsStatus.entregue, 'Entregues'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: OrdoSpacing.screenPadding,
          vertical: 6,
        ),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final f = _filters[i];
          final selected = f.$1 == active;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onChange(f.$1),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? OrdoColors.ink : OrdoColors.paper,
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(
                  color: selected ? OrdoColors.ink : OrdoColors.border,
                ),
              ),
              child: Text(
                f.$2,
                style: OrdoTypography.body(
                  size: 13,
                  weight: FontWeight.w500,
                  color: selected ? OrdoColors.bone : OrdoColors.ink,
                  height: 1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
