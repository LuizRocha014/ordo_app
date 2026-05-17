import 'package:flutter/material.dart';

import '../../core/theme/ordo_colors.dart';
import '../../core/theme/ordo_shadows.dart';
import '../../core/theme/ordo_typography.dart';
import 'ordo_icon.dart';

enum OrdoTab { home, list, clients, settings }

class OrdoBottomNav extends StatelessWidget {
  final OrdoTab active;
  final ValueChanged<OrdoTab> onSelect;
  final VoidCallback? onNew;

  const OrdoBottomNav({
    super.key,
    required this.active,
    required this.onSelect,
    this.onNew,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 22),
          child: Container(
            decoration: BoxDecoration(
              color: OrdoColors.paper,
              border: Border.all(color: OrdoColors.border),
              borderRadius: BorderRadius.circular(22),
              boxShadow: OrdoShadows.lg,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    icon: OrdoIconName.home,
                    label: 'Início',
                    isActive: active == OrdoTab.home,
                    onTap: () => onSelect(OrdoTab.home),
                  ),
                  _NavItem(
                    icon: OrdoIconName.fileText,
                    label: 'OS',
                    isActive: active == OrdoTab.list,
                    onTap: () => onSelect(OrdoTab.list),
                  ),
                  _NavItem(
                    icon: OrdoIconName.users,
                    label: 'Clientes',
                    isActive: active == OrdoTab.clients,
                    onTap: () => onSelect(OrdoTab.clients),
                  ),
                  _NavItem(
                    icon: OrdoIconName.settings,
                    label: 'Ajustes',
                    isActive: active == OrdoTab.settings,
                    onTap: () => onSelect(OrdoTab.settings),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (onNew != null)
          Positioned(
            right: 20,
            bottom: 88,
            child: _OrdoFab(onPressed: onNew!),
          ),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  final OrdoIconName icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? OrdoColors.ink : OrdoColors.fg3;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 18,
              height: 2,
              decoration: BoxDecoration(
                color: isActive ? OrdoColors.ink : Colors.transparent,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            const SizedBox(height: 3),
            OrdoIcon(icon, size: 22, color: color),
            const SizedBox(height: 2),
            Text(
              label,
              style: OrdoTypography.body(
                size: 10,
                weight: FontWeight.w500,
                color: color,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrdoFab extends StatelessWidget {
  final VoidCallback onPressed;
  const _OrdoFab({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: OrdoColors.lime,
          shape: BoxShape.circle,
          boxShadow: OrdoShadows.fab,
        ),
        alignment: Alignment.center,
        child: const OrdoIcon(
          OrdoIconName.plus,
          size: 28,
          color: OrdoColors.ink,
        ),
      ),
    );
  }
}
