import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/ordo_colors.dart';
import '../../../../core/theme/ordo_radius.dart';
import '../../../../core/theme/ordo_spacing.dart';
import '../../../../core/theme/ordo_typography.dart';
import '../../../../shared/widgets/bottom_nav.dart';
import '../../../../shared/widgets/ordo_button.dart';
import '../../../../shared/widgets/ordo_icon.dart';
import '../../../../shared/widgets/top_bar.dart';
import '../../../auth/presentation/controllers/login_controller.dart';
import '../../../setup/presentation/controllers/setup_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const String _appVersion = '0.1.0';
  static const String _mockUserName = 'Bruno Antunes';
  static const String _mockUserEmail = 'bruno@ordo.app';

  void _onTab(OrdoTab tab) {
    switch (tab) {
      case OrdoTab.home:
        Get.offNamed(AppRoutes.home);
        break;
      case OrdoTab.list:
        Get.offNamed(AppRoutes.osList);
        break;
      case OrdoTab.clients:
        Get.offNamed(AppRoutes.clients);
        break;
      case OrdoTab.settings:
        break;
    }
  }

  Future<void> _confirmLogout() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: OrdoColors.paper,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(OrdoRadius.lg),
        ),
        title: Text(
          'Sair da conta?',
          style: OrdoTypography.display(size: 18, weight: FontWeight.w600),
        ),
        content: Text(
          'Você precisará entrar novamente com email e senha.',
          style: OrdoTypography.body(size: 13, color: OrdoColors.fg2),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              'Cancelar',
              style: OrdoTypography.body(
                size: 13,
                weight: FontWeight.w600,
                color: OrdoColors.fg2,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              'Sair',
              style: OrdoTypography.body(
                size: 13,
                weight: FontWeight.w600,
                color: OrdoColors.red,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await Get.find<LoginController>().logout();
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final setup = Get.find<SetupController>();

    return Scaffold(
      backgroundColor: OrdoColors.bg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(76),
        child: Obx(() {
          final shop = setup.current.value;
          return OrdoTopBar(
            title: 'Ajustes',
            subtitle: shop?.shopName ?? 'Ordo',
            leading: OrdoIconButton(
              ghost: true,
              onTap: Get.back,
              child: const OrdoIcon(OrdoIconName.chevronLeft, size: 22),
            ),
          );
        }),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(
              OrdoSpacing.screenPadding,
              8,
              OrdoSpacing.screenPadding,
              140,
            ),
            children: [
              const _ProfileCard(name: _mockUserName, email: _mockUserEmail),
              const SizedBox(height: OrdoSpacing.s5),
              const _SectionLabel(text: 'PREFERÊNCIAS'),
              const SizedBox(height: OrdoSpacing.s2),
              _SettingTile(
                icon: OrdoIconName.bell,
                label: 'Notificações',
                trailing: Text(
                  'Ativadas',
                  style: OrdoTypography.body(
                    size: 12,
                    weight: FontWeight.w500,
                    color: OrdoColors.fg2,
                  ),
                ),
                onTap: () => _snackTodo('Notificações'),
              ),
              const SizedBox(height: 8),
              Obx(() {
                final shop = setup.current.value;
                return _SettingTile(
                  icon: OrdoIconName.wrench,
                  label: 'Tipo de oficina',
                  trailing: Text(
                    shop?.label ?? '—',
                    style: OrdoTypography.body(
                      size: 12,
                      weight: FontWeight.w500,
                      color: OrdoColors.fg2,
                    ),
                  ),
                  onTap: () => _snackTodo('Tipo de oficina'),
                );
              }),
              const SizedBox(height: OrdoSpacing.s5),
              const _SectionLabel(text: 'CONTA'),
              const SizedBox(height: OrdoSpacing.s2),
              _SettingTile(
                icon: OrdoIconName.users,
                label: 'Equipe',
                trailing: const OrdoIcon(
                  OrdoIconName.chevronRight,
                  size: 18,
                  color: OrdoColors.fg3,
                ),
                onTap: () => _snackTodo('Equipe'),
              ),
              const SizedBox(height: 8),
              _SettingTile(
                icon: OrdoIconName.fileText,
                label: 'Termos e privacidade',
                trailing: const OrdoIcon(
                  OrdoIconName.chevronRight,
                  size: 18,
                  color: OrdoColors.fg3,
                ),
                onTap: () => _snackTodo('Termos e privacidade'),
              ),
              const SizedBox(height: OrdoSpacing.s6),
              OrdoButton(
                label: 'Sair da conta',
                variant: OrdoButtonVariant.danger,
                size: OrdoButtonSize.lg,
                full: true,
                onPressed: _confirmLogout,
              ),
              const SizedBox(height: OrdoSpacing.s5),
              Center(
                child: Text(
                  'Ordo · v$_appVersion',
                  style: OrdoTypography.mono(
                    size: 11,
                    color: OrdoColors.fg3,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: OrdoBottomNav(
              active: OrdoTab.settings,
              onSelect: _onTab,
              onNew: () => Get.toNamed(AppRoutes.novaOs),
            ),
          ),
        ],
      ),
    );
  }

  void _snackTodo(String what) {
    Get.snackbar(
      what,
      'Disponível em breve.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String name;
  final String email;

  const _ProfileCard({required this.name, required this.email});

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: OrdoColors.ink,
        borderRadius: BorderRadius.circular(OrdoRadius.md),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: OrdoColors.lime,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              _initials,
              style: OrdoTypography.display(
                size: 18,
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
                    size: 16,
                    weight: FontWeight.w600,
                    color: OrdoColors.bone,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: OrdoTypography.body(
                    size: 12,
                    color: OrdoColors.slate400,
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

class _SettingTile extends StatelessWidget {
  final OrdoIconName icon;
  final String label;
  final Widget? trailing;
  final VoidCallback onTap;

  const _SettingTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
  });

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
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: OrdoColors.slate100,
                borderRadius: BorderRadius.circular(9),
              ),
              alignment: Alignment.center,
              child: OrdoIcon(icon, size: 18, color: OrdoColors.ink),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: OrdoTypography.body(
                  size: 14,
                  weight: FontWeight.w500,
                  color: OrdoColors.ink,
                ),
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: OrdoTypography.body(
        size: 10,
        weight: FontWeight.w600,
        color: OrdoColors.fg3,
        letterSpacing: 0.8,
      ),
    );
  }
}
