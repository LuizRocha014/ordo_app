import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/ordo_colors.dart';
import '../../../../core/theme/ordo_radius.dart';
import '../../../../core/theme/ordo_spacing.dart';
import '../../../../core/theme/ordo_typography.dart';
import '../../../../shared/utils/formatters.dart';
import '../../../../shared/widgets/ordo_button.dart';
import '../../../../shared/widgets/ordo_icon.dart';
import '../../../../shared/widgets/top_bar.dart';
import '../../domain/entities/os_status.dart';
import '../../domain/entities/service_order.dart';
import '../../domain/entities/timeline_event.dart';
import '../controllers/service_order_detail_controller.dart';

class OsDetailPage extends StatefulWidget {
  final String orderId;
  const OsDetailPage({super.key, required this.orderId});

  @override
  State<OsDetailPage> createState() => _OsDetailPageState();
}

class _OsDetailPageState extends State<OsDetailPage> {
  final _detail = Get.find<ServiceOrderDetailController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _detail.load(widget.orderId);
    });
  }

  Future<void> _changeStatus() async {
    final order = _detail.order.value;
    if (order == null) return;
    final next = await Get.bottomSheet<OsStatus>(
      _StatusPicker(current: order.status),
      backgroundColor: OrdoColors.paper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
    if (next != null) {
      await _detail.changeStatus(next);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OrdoColors.bg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(76),
        child: Obx(() {
          final order = _detail.order.value;
          return OrdoTopBar(
            title: 'OS ${order == null ? '' : '#${order.id}'}',
            subtitle: order?.title,
            leading: OrdoIconButton(
              ghost: true,
              onTap: Get.back,
              child: const OrdoIcon(OrdoIconName.chevronLeft, size: 22),
            ),
            trailing: [
              OrdoIconButton(
                onTap: () {},
                child: const OrdoIcon(OrdoIconName.more, size: 20),
              ),
            ],
          );
        }),
      ),
      body: Obx(() {
        final loading = _detail.loading.value;
        final order = _detail.order.value;
        if (loading || order == null) {
          return const Center(
            child: CircularProgressIndicator(color: OrdoColors.ink),
          );
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(
            OrdoSpacing.screenPadding,
            0,
            OrdoSpacing.screenPadding,
            OrdoSpacing.s6,
          ),
          children: [
            _StatusHero(order: order, onChange: _changeStatus),
            const SizedBox(height: OrdoSpacing.s4),
            _SummaryCard(order: order),
            const SizedBox(height: OrdoSpacing.s5),
            _PhotosSection(photoCount: order.photoIds.length),
            const SizedBox(height: OrdoSpacing.s5),
            _TimelineSection(events: order.timeline),
            const SizedBox(height: OrdoSpacing.s5),
            OrdoButton(
              label: order.status == OsStatus.entregue
                  ? 'OS entregue'
                  : 'Marcar como entregue',
              variant: OrdoButtonVariant.accent,
              size: OrdoButtonSize.lg,
              full: true,
              onPressed: order.status == OsStatus.entregue
                  ? null
                  : () => _detail.changeStatus(OsStatus.entregue),
            ),
          ],
        );
      }),
    );
  }
}

class _StatusHero extends StatelessWidget {
  final ServiceOrder order;
  final VoidCallback onChange;
  const _StatusHero({required this.order, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: OrdoColors.ink,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: OrdoColors.lime,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: const OrdoIcon(
              OrdoIconName.checkCircle,
              size: 26,
              color: OrdoColors.ink,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'STATUS',
                  style: OrdoTypography.body(
                    size: 11,
                    color: OrdoColors.slate400,
                    letterSpacing: 0.66,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  order.status.label,
                  style: OrdoTypography.display(
                    size: 20,
                    weight: FontWeight.w700,
                    color: OrdoColors.bone,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onChange,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: OrdoColors.lime),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Alterar',
                    style: OrdoTypography.body(
                      size: 12,
                      weight: FontWeight.w600,
                      color: OrdoColors.lime,
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const OrdoIcon(
                    OrdoIconName.chevronRight,
                    size: 14,
                    color: OrdoColors.lime,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final ServiceOrder order;
  const _SummaryCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: OrdoColors.paper,
        borderRadius: BorderRadius.circular(OrdoRadius.md),
        border: Border.all(color: OrdoColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _SummaryCell(
                  label: 'CLIENTE',
                  value: order.client.name,
                  mono: order.client.phone,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _SummaryCell(
                  label: 'VALOR',
                  value: OrdoFormatters.brl(order.valueCents),
                  mono: 'peça + mão de obra',
                  emphasizeValue: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OrdoButton(
                  label: 'Ligar',
                  variant: OrdoButtonVariant.secondary,
                  size: OrdoButtonSize.sm,
                  icon: Icons.phone_outlined,
                  full: true,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OrdoButton(
                  label: 'WhatsApp',
                  variant: OrdoButtonVariant.secondary,
                  size: OrdoButtonSize.sm,
                  icon: Icons.chat_outlined,
                  full: true,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryCell extends StatelessWidget {
  final String label;
  final String value;
  final String mono;
  final bool emphasizeValue;

  const _SummaryCell({
    required this.label,
    required this.value,
    required this.mono,
    this.emphasizeValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: OrdoTypography.body(
            size: 11,
            color: OrdoColors.fg3,
            letterSpacing: 0.44,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: emphasizeValue
              ? OrdoTypography.mono(
                  size: 16,
                  weight: FontWeight.w600,
                  color: OrdoColors.ink,
                )
              : OrdoTypography.body(
                  size: 14,
                  weight: FontWeight.w600,
                  color: OrdoColors.ink,
                ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          mono,
          style: OrdoTypography.body(size: 11, color: OrdoColors.fg2),
        ),
      ],
    );
  }
}

class _PhotosSection extends StatelessWidget {
  final int photoCount;
  const _PhotosSection({required this.photoCount});

  static const _gradients = [
    [Color(0xFF3A3F4B), Color(0xFF1C1F26)],
    [Color(0xFF2A2F3D), Color(0xFF0F1115)],
    [Color(0xFF4A5163), Color(0xFF2A2F3D)],
    [Color(0xFF1C1F26), Color(0xFF0F1115)],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Fotos da OS',
              style: OrdoTypography.display(size: 16, weight: FontWeight.w600),
            ),
            Text(
              '$photoCount fotos',
              style: OrdoTypography.body(
                size: 12,
                weight: FontWeight.w500,
                color: OrdoColors.fg2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
          ),
          itemCount: photoCount > 0 ? photoCount : 4,
          itemBuilder: (_, i) {
            final gradient = _gradients[i % _gradients.length];
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradient,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xB30F1115),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'FOTO ${i + 1}',
                        style: OrdoTypography.mono(
                          size: 9,
                          weight: FontWeight.w500,
                          color: OrdoColors.bone,
                        ).copyWith(letterSpacing: 0.45),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _TimelineSection extends StatelessWidget {
  final List<TimelineEvent> events;
  const _TimelineSection({required this.events});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Histórico',
          style: OrdoTypography.display(size: 16, weight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        for (var i = 0; i < events.length; i++)
          _TimelineRow(
            event: events[i],
            isLast: i == events.length - 1,
          ),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final TimelineEvent event;
  final bool isLast;
  const _TimelineRow({required this.event, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(top: 6),
                decoration: BoxDecoration(
                  color: event.accent ? OrdoColors.lime : OrdoColors.paper,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: event.accent ? OrdoColors.lime : OrdoColors.ink,
                    width: 2,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: OrdoColors.border),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    OrdoFormatters.dateTimeShort(event.when).toUpperCase(),
                    style: OrdoTypography.mono(
                      size: 10,
                      color: OrdoColors.fg3,
                    ).copyWith(letterSpacing: 0.4),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    event.description,
                    style: OrdoTypography.body(
                      size: 13,
                      color: OrdoColors.ink,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    event.author,
                    style: OrdoTypography.body(
                      size: 11,
                      color: OrdoColors.fg2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPicker extends StatelessWidget {
  final OsStatus current;
  const _StatusPicker({required this.current});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          OrdoSpacing.screenPadding,
          OrdoSpacing.s5,
          OrdoSpacing.screenPadding,
          OrdoSpacing.s5,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Alterar status',
              style: OrdoTypography.display(size: 18, weight: FontWeight.w600),
            ),
            const SizedBox(height: OrdoSpacing.s4),
            for (final s in OsStatus.values)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  s.label,
                  style: OrdoTypography.body(
                    size: 14,
                    weight: s == current ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                trailing: s == current
                    ? const Icon(Icons.check, color: OrdoColors.ink, size: 18)
                    : null,
                onTap: () => Get.back(result: s),
              ),
          ],
        ),
      ),
    );
  }
}
