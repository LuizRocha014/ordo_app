import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/ordo_colors.dart';
import '../../../../core/theme/ordo_spacing.dart';
import '../../../../core/theme/ordo_typography.dart';
import '../../../../shared/widgets/bottom_nav.dart';
import '../../../../shared/widgets/ordo_icon.dart';
import '../../../../shared/widgets/os_card.dart';
import '../../../../shared/widgets/top_bar.dart';
import '../../../setup/presentation/providers/setup_provider.dart';
import '../../domain/entities/os_status.dart';
import '../providers/service_orders_provider.dart';

class OsListPage extends StatefulWidget {
  const OsListPage({super.key});

  @override
  State<OsListPage> createState() => _OsListPageState();
}

class _OsListPageState extends State<OsListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceOrdersProvider>().load();
    });
  }

  void _onTab(OrdoTab tab) {
    switch (tab) {
      case OrdoTab.home:
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        break;
      case OrdoTab.list:
        break;
      case OrdoTab.clients:
      case OrdoTab.settings:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<SetupProvider>().current;
    final provider = context.watch<ServiceOrdersProvider>();

    final productPlural = shop?.productNounPlural ?? 'serviços';

    return Scaffold(
      backgroundColor: OrdoColors.bg,
      appBar: OrdoTopBar(
        title: 'OS de $productPlural',
        subtitle: '${provider.items.length} resultados',
        leading: OrdoIconButton(
          ghost: true,
          onTap: () => Navigator.of(context).maybePop(),
          child: const OrdoIcon(OrdoIconName.chevronLeft, size: 22),
        ),
        trailing: [
          OrdoIconButton(
            onTap: () {},
            child: const OrdoIcon(OrdoIconName.search, size: 20),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 6),
              _FilterBar(
                active: provider.statusFilter,
                onChange: (status) =>
                    context.read<ServiceOrdersProvider>().setStatusFilter(status),
              ),
              Expanded(
                child: provider.loading && provider.items.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(color: OrdoColors.ink),
                      )
                    : provider.items.isEmpty
                        ? Center(
                            child: Text(
                              'Nenhuma OS para este filtro.',
                              style: OrdoTypography.body(
                                size: 13,
                                color: OrdoColors.fg2,
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(
                              OrdoSpacing.screenPadding,
                              0,
                              OrdoSpacing.screenPadding,
                              140,
                            ),
                            itemCount: provider.items.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 8),
                            itemBuilder: (_, i) {
                              final os = provider.items[i];
                              return OSCard(
                                order: os,
                                onTap: () =>
                                    Navigator.of(context).pushNamed(
                                  AppRoutes.osDetail,
                                  arguments: os.id,
                                ),
                              );
                            },
                          ),
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
              onNew: () => Navigator.of(context).pushNamed(AppRoutes.novaOs),
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
