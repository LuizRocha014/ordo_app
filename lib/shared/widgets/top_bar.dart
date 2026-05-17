import 'package:flutter/material.dart';

import '../../core/theme/ordo_colors.dart';
import '../../core/theme/ordo_spacing.dart';
import '../../core/theme/ordo_typography.dart';

/// Top bar fixo (56px) com título display + subtítulo opcional.
///
/// Composição via `leading` / `trailing`. O conteúdo abaixo é montado
/// pelo `ScreenShell`.
class OrdoTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> trailing;

  const OrdoTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing = const [],
  });

  @override
  Size get preferredSize => const Size.fromHeight(76);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: OrdoColors.bone,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            OrdoSpacing.screenPadding,
            OrdoSpacing.s2,
            OrdoSpacing.screenPadding,
            OrdoSpacing.s3,
          ),
          child: Row(
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: OrdoSpacing.s3),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: OrdoTypography.display(
                        size: 22,
                        weight: FontWeight.w700,
                        height: 1.1,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: OrdoTypography.body(
                          size: 12,
                          color: OrdoColors.fg2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing.isNotEmpty) ...[
                const SizedBox(width: OrdoSpacing.s2),
                ...trailing.expand(
                  (w) => [w, const SizedBox(width: OrdoSpacing.s2)],
                ).take(trailing.length * 2 - 1),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Botão circular usado como leading (voltar) ou trailing (sino, busca).
class OrdoIconButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? badgeColor;
  final bool ghost;

  const OrdoIconButton({
    super.key,
    required this.child,
    required this.onTap,
    this.badgeColor,
    this.ghost = false,
  });

  @override
  Widget build(BuildContext context) {
    final base = Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: ghost ? Colors.transparent : OrdoColors.paper,
        borderRadius: BorderRadius.circular(12),
        border: ghost ? null : Border.all(color: OrdoColors.border),
      ),
      alignment: Alignment.center,
      child: child,
    );

    final withBadge = badgeColor == null
        ? base
        : Stack(
            children: [
              base,
              Positioned(
                top: 8,
                right: 9,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: badgeColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: OrdoColors.paper, width: 2),
                  ),
                ),
              ),
            ],
          );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: withBadge,
    );
  }
}
