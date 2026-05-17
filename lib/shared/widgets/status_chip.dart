import 'package:flutter/material.dart';

import '../../core/theme/ordo_colors.dart';
import '../../core/theme/ordo_typography.dart';
import '../../features/service_order/domain/entities/os_status.dart';

/// Pill com fundo "soft" + texto saturado, representando o estado da OS.
///
/// Cores funcionais por status — vivem nesta camada de presentation
/// (não no domínio), conforme o design system Ordo.
class StatusChip extends StatelessWidget {
  final OsStatus status;
  final bool dense;

  const StatusChip({super.key, required this.status, this.dense = false});

  ({Color bg, Color fg}) get _colors {
    switch (status) {
      case OsStatus.aberta:
        return (bg: OrdoColors.blueSoft, fg: OrdoColors.blue);
      case OsStatus.andamento:
        return (bg: OrdoColors.amberSoft, fg: OrdoColors.amber);
      case OsStatus.aguardando:
        return (bg: OrdoColors.violetSoft, fg: OrdoColors.violet);
      case OsStatus.pronta:
        return (bg: OrdoColors.greenSoft, fg: OrdoColors.green);
      case OsStatus.entregue:
        return (bg: OrdoColors.slate100, fg: OrdoColors.ink);
      case OsStatus.cancelada:
        return (bg: OrdoColors.redSoft, fg: OrdoColors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _colors;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 7 : 10,
        vertical: dense ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: c.bg,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: c.fg, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            status.label.toUpperCase(),
            style: OrdoTypography.body(
              size: dense ? 9 : 10,
              weight: FontWeight.w600,
              color: c.fg,
              letterSpacing: dense ? 0.36 : 0.4,
            ),
          ),
        ],
      ),
    );
  }
}
