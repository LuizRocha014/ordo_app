import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/ordo_colors.dart';
import '../../../../core/theme/ordo_radius.dart';
import '../../../../core/theme/ordo_spacing.dart';
import '../../../../core/theme/ordo_typography.dart';
import '../../../../shared/widgets/bottom_nav.dart';
import '../../../../shared/widgets/ordo_field.dart';
import '../../../../shared/widgets/ordo_icon.dart';
import '../../../../shared/widgets/top_bar.dart';
import '../../../service_order/domain/entities/client.dart';
import '../controllers/clients_controller.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  final _controller = Get.find<ClientsController>();
  final _searchCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.load());
  }

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  void _onTab(OrdoTab tab) {
    switch (tab) {
      case OrdoTab.home:
        Get.offNamed(AppRoutes.home);
        break;
      case OrdoTab.list:
        Get.offNamed(AppRoutes.osList);
        break;
      case OrdoTab.settings:
        Get.offNamed(AppRoutes.settings);
        break;
      case OrdoTab.clients:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OrdoColors.bg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(76),
        child: Obx(() => OrdoTopBar(
              title: 'Clientes',
              subtitle: '${_controller.items.length} cadastrados',
              leading: OrdoIconButton(
                ghost: true,
                onTap: Get.back,
                child: const OrdoIcon(OrdoIconName.chevronLeft, size: 22),
              ),
            )),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  OrdoSpacing.screenPadding,
                  6,
                  OrdoSpacing.screenPadding,
                  10,
                ),
                child: OrdoField(
                  controller: _searchCtl,
                  placeholder: 'Buscar por nome ou telefone',
                  onChanged: _controller.setQuery,
                ),
              ),
              Expanded(
                child: Obx(() {
                  final loading = _controller.loading.value;
                  final items = _controller.items;
                  if (loading && items.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(color: OrdoColors.ink),
                    );
                  }
                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        _controller.query.value.isEmpty
                            ? 'Nenhum cliente cadastrado ainda.'
                            : 'Nada encontrado para "${_controller.query.value}".',
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
                    itemBuilder: (_, i) => _ClientCard(
                      client: items[i],
                      onTap: () => Get.toNamed(
                        AppRoutes.clienteDetail,
                        arguments: items[i].id,
                      ),
                    ),
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
              active: OrdoTab.clients,
              onSelect: _onTab,
              onNew: () => Get.toNamed(AppRoutes.cadastroCliente),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClientCard extends StatelessWidget {
  final Client client;
  final VoidCallback onTap;

  const _ClientCard({required this.client, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: OrdoColors.paper,
          border: Border.all(color: OrdoColors.border),
          borderRadius: BorderRadius.circular(OrdoRadius.md),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: OrdoColors.slate100,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                client.initials,
                style: OrdoTypography.display(
                  size: 15,
                  weight: FontWeight.w600,
                  color: OrdoColors.ink,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    client.name,
                    style: OrdoTypography.display(
                      size: 15,
                      weight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    client.phone,
                    style: OrdoTypography.mono(
                      size: 12,
                      color: OrdoColors.fg2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const OrdoIcon(
              OrdoIconName.chevronRight,
              size: 18,
              color: OrdoColors.fg3,
            ),
          ],
        ),
      ),
    );
  }
}
