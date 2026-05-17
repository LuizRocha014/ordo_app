import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/ordo_colors.dart';
import '../../../../core/theme/ordo_radius.dart';
import '../../../../core/theme/ordo_spacing.dart';
import '../../../../core/theme/ordo_typography.dart';
import '../../../../shared/widgets/ordo_button.dart';
import '../../../../shared/widgets/ordo_icon.dart';
import '../../../../shared/widgets/top_bar.dart';
import '../../domain/entities/checklist_item.dart';
import '../providers/service_order_detail_provider.dart';

class ChecklistPage extends StatefulWidget {
  final String orderId;
  const ChecklistPage({super.key, required this.orderId});

  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceOrderDetailProvider>().load(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ServiceOrderDetailProvider>();
    final order = provider.order;

    if (provider.loading || order == null) {
      return const Scaffold(
        backgroundColor: OrdoColors.bg,
        body: Center(child: CircularProgressIndicator(color: OrdoColors.ink)),
      );
    }

    final items = order.checklist;
    final doneCount = order.checklistDoneCount;
    final total = items.length;
    final progress = total == 0 ? 0.0 : doneCount / total;

    return Scaffold(
      backgroundColor: OrdoColors.bg,
      appBar: OrdoTopBar(
        title: 'Checklist de entrada',
        subtitle: 'OS #${order.id} · ${order.title}',
        leading: OrdoIconButton(
          ghost: true,
          onTap: () => Navigator.of(context).maybePop(),
          child: const OrdoIcon(OrdoIconName.chevronLeft, size: 22),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          OrdoSpacing.screenPadding,
          0,
          OrdoSpacing.screenPadding,
          OrdoSpacing.s6,
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progresso',
                style: OrdoTypography.body(
                  size: 13,
                  weight: FontWeight.w500,
                  color: OrdoColors.fg2,
                ),
              ),
              Text(
                '$doneCount/$total',
                style: OrdoTypography.mono(size: 13, weight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: OrdoColors.border,
              valueColor: const AlwaysStoppedAnimation(OrdoColors.ink),
            ),
          ),
          const SizedBox(height: OrdoSpacing.s4),
          for (final item in items) ...[
            _ChecklistRow(
              item: item,
              onToggle: () => context
                  .read<ServiceOrderDetailProvider>()
                  .toggleChecklist(item.id),
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: OrdoSpacing.s4),
          Row(
            children: [
              Expanded(
                child: OrdoButton(
                  label: 'Voltar',
                  variant: OrdoButtonVariant.secondary,
                  full: true,
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OrdoButton(
                  label: 'Concluir entrada',
                  variant: OrdoButtonVariant.accent,
                  full: true,
                  onPressed: () => Navigator.of(context).pushReplacementNamed(
                    AppRoutes.osDetail,
                    arguments: order.id,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  final ChecklistItem item;
  final VoidCallback onToggle;

  const _ChecklistRow({required this.item, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onToggle,
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
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: item.done ? OrdoColors.lime : OrdoColors.paper,
                border: Border.all(
                  color: item.done ? OrdoColors.ink : OrdoColors.borderStrong,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: item.done
                  ? const Icon(Icons.check, size: 14, color: OrdoColors.ink)
                  : null,
            ),
            const SizedBox(width: 12),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: item.photoCount > 0
                    ? OrdoColors.slate800
                    : OrdoColors.slate100,
                border: item.photoCount > 0
                    ? null
                    : Border.all(
                        color: OrdoColors.borderStrong,
                        style: BorderStyle.solid,
                      ),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: OrdoIcon(
                item.photoCount > 0 ? OrdoIconName.camera : OrdoIconName.plus,
                size: 16,
                color: item.photoCount > 0 ? OrdoColors.lime : OrdoColors.fg3,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.label,
                style: OrdoTypography.body(
                  size: 13.5,
                  color: OrdoColors.ink,
                  height: 1.35,
                ).copyWith(
                  decoration: item.done
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  decorationColor: OrdoColors.borderStrong,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              item.photoCount > 0 ? '${item.photoCount} FOTOS' : 'ADD FOTO',
              style: OrdoTypography.mono(
                size: 10,
                weight: FontWeight.w500,
                color: OrdoColors.fg3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
