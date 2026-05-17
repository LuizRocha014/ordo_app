import 'package:flutter/material.dart';

import '../../core/theme/ordo_colors.dart';
import '../../core/theme/ordo_radius.dart';
import '../../core/theme/ordo_typography.dart';

/// KPI block usado na home — eyebrow + número grande + trend opcional.
///
/// `highlight=true` inverte a cor (fundo Ink, texto Bone) — usado para
/// destacar a métrica mais relevante no momento (ex.: "Prontas").
class KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final String? trend;
  final bool highlight;
  final bool mono;

  const KpiCard({
    super.key,
    required this.label,
    required this.value,
    this.trend,
    this.highlight = false,
    this.mono = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = highlight ? OrdoColors.ink : OrdoColors.paper;
    final labelColor = highlight ? OrdoColors.slate400 : OrdoColors.fg3;
    final valueColor = highlight ? OrdoColors.bone : OrdoColors.ink;
    final trendColor = highlight ? OrdoColors.lime : OrdoColors.green;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(OrdoRadius.md),
        border: highlight ? null : Border.all(color: OrdoColors.border),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            style: OrdoTypography.body(
              size: 11,
              weight: FontWeight.w500,
              color: labelColor,
              letterSpacing: 0.44,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: mono
                      ? OrdoTypography.mono(
                          size: 20,
                          weight: FontWeight.w700,
                          color: valueColor,
                        )
                      : OrdoTypography.display(
                          size: 28,
                          weight: FontWeight.w700,
                          color: valueColor,
                          height: 1,
                        ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (trend != null) ...[
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    trend!,
                    style: OrdoTypography.body(
                      size: 11,
                      weight: FontWeight.w600,
                      color: trendColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
