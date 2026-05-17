import 'package:flutter/material.dart';

import '../../core/theme/ordo_colors.dart';
import '../../core/theme/ordo_radius.dart';
import '../../core/theme/ordo_shadows.dart';
import '../../core/theme/ordo_typography.dart';
import '../../features/service_order/domain/entities/service_order.dart';
import '../utils/formatters.dart';
import 'ordo_icon.dart';
import 'status_chip.dart';

/// Card de OS — bloco compositivo principal das listas.
///
/// Mantém grid de 3 colunas: ícone da categoria · conteúdo · status+valor.
class OSCard extends StatelessWidget {
  final ServiceOrder order;
  final VoidCallback? onTap;

  const OSCard({super.key, required this.order, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: OrdoColors.paper,
          borderRadius: BorderRadius.circular(OrdoRadius.md),
          border: Border.all(color: OrdoColors.border),
          boxShadow: OrdoShadows.sm,
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: OrdoColors.slate100,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: OrdoIcon(
                OrdoIcon.forShop(order.category),
                size: 22,
                color: OrdoColors.ink,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'OS #${order.id}',
                    style: OrdoTypography.mono(
                      size: 10,
                      weight: FontWeight.w600,
                      color: OrdoColors.fg3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    order.title,
                    style: OrdoTypography.display(
                      size: 15,
                      weight: FontWeight.w600,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          order.client.name,
                          style: OrdoTypography.body(
                            size: 12,
                            color: OrdoColors.fg2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: const BoxDecoration(
                          color: OrdoColors.borderStrong,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        OrdoFormatters.relativeDay(order.updatedAt),
                        style: OrdoTypography.body(
                          size: 12,
                          color: OrdoColors.fg2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                StatusChip(status: order.status, dense: true),
                const SizedBox(height: 6),
                Text(
                  OrdoFormatters.brl(order.valueCents),
                  style: OrdoTypography.mono(
                    size: 13,
                    weight: FontWeight.w600,
                    color: OrdoColors.ink,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
