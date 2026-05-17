import 'package:flutter/material.dart';

import '../../core/theme/ordo_colors.dart';
import '../../core/theme/ordo_motion.dart';
import '../../core/theme/ordo_radius.dart';
import '../../core/theme/ordo_typography.dart';

/// Variantes de botão do Ordo.
///
/// Importante: `accent` (lime) só pode aparecer **uma vez por tela** —
/// reservado para a ação primária mais importante (Abrir OS, Concluir).
enum OrdoButtonVariant { primary, accent, secondary, ghost, danger }

enum OrdoButtonSize { sm, md, lg }

class OrdoButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final OrdoButtonVariant variant;
  final OrdoButtonSize size;
  final IconData? icon;
  final bool full;
  final bool loading;

  const OrdoButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = OrdoButtonVariant.primary,
    this.size = OrdoButtonSize.md,
    this.icon,
    this.full = false,
    this.loading = false,
  });

  @override
  State<OrdoButton> createState() => _OrdoButtonState();
}

class _OrdoButtonState extends State<OrdoButton> {
  bool _pressed = false;

  ({Color bg, Color fg, Color? border}) get _colors {
    switch (widget.variant) {
      case OrdoButtonVariant.primary:
        return (bg: OrdoColors.ink, fg: OrdoColors.bone, border: null);
      case OrdoButtonVariant.accent:
        return (bg: OrdoColors.lime, fg: OrdoColors.ink, border: null);
      case OrdoButtonVariant.secondary:
        return (
          bg: OrdoColors.paper,
          fg: OrdoColors.ink,
          border: OrdoColors.borderStrong,
        );
      case OrdoButtonVariant.ghost:
        return (bg: Colors.transparent, fg: OrdoColors.ink, border: null);
      case OrdoButtonVariant.danger:
        return (bg: Colors.transparent, fg: OrdoColors.red, border: null);
    }
  }

  ({double padV, double padH, double radius, double fontSize}) get _sizing {
    switch (widget.size) {
      case OrdoButtonSize.sm:
        return (padV: 8, padH: 12, radius: OrdoRadius.sm, fontSize: 13);
      case OrdoButtonSize.md:
        return (padV: 13, padH: 18, radius: OrdoRadius.md, fontSize: 14);
      case OrdoButtonSize.lg:
        return (padV: 15, padH: 22, radius: 14, fontSize: 15);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _colors;
    final s = _sizing;
    final enabled = widget.onPressed != null && !widget.loading;
    final scale = _pressed ? 0.97 : 1.0;

    final content = widget.loading
        ? SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(c.fg),
            ),
          )
        : Row(
            mainAxisSize: widget.full ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 16, color: c.fg),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  widget.label,
                  style: OrdoTypography.body(
                    size: s.fontSize,
                    weight: FontWeight.w600,
                    color: c.fg,
                    height: 1,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );

    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
        onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
        onTap: enabled ? widget.onPressed : null,
        child: AnimatedScale(
          scale: scale,
          duration: OrdoMotion.micro,
          curve: OrdoMotion.easeStandard,
          child: Container(
            width: widget.full ? double.infinity : null,
            padding: EdgeInsets.symmetric(horizontal: s.padH, vertical: s.padV),
            decoration: BoxDecoration(
              color: c.bg,
              borderRadius: BorderRadius.circular(s.radius),
              border: c.border != null
                  ? Border.all(color: c.border!, width: 1)
                  : null,
            ),
            alignment: Alignment.center,
            child: content,
          ),
        ),
      ),
    );
  }
}
