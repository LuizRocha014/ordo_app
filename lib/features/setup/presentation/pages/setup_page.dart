import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/ordo_colors.dart';
import '../../../../core/theme/ordo_radius.dart';
import '../../../../core/theme/ordo_shadows.dart';
import '../../../../core/theme/ordo_spacing.dart';
import '../../../../core/theme/ordo_typography.dart';
import '../../../../shared/widgets/ordo_icon.dart';
import '../../domain/entities/shop_type.dart';
import '../providers/setup_provider.dart';

class SetupPage extends StatelessWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SetupProvider>();

    return Scaffold(
      backgroundColor: OrdoColors.bone,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'assets/svg/logo-mark.svg',
                width: 56,
                height: 56,
              ),
              const SizedBox(height: 18),
              Text(
                'Configure sua\noficina.',
                style: OrdoTypography.display(
                  size: 28,
                  weight: FontWeight.w700,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  style: OrdoTypography.body(size: 14, color: OrdoColors.fg2),
                  children: [
                    const TextSpan(text: 'Ordo é focado em '),
                    TextSpan(
                      text: 'um tipo',
                      style: OrdoTypography.body(
                        size: 14,
                        weight: FontWeight.w600,
                        color: OrdoColors.ink,
                      ),
                    ),
                    const TextSpan(
                      text:
                          ' de serviço por oficina. Isso deixa as ordens mais '
                          'rápidas de abrir e o checklist certo aparece em cada serviço.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'O QUE VOCÊ CONSERTA?',
                style: OrdoTypography.body(
                  size: 10,
                  weight: FontWeight.w600,
                  color: OrdoColors.fg3,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10),
              for (final type in ShopType.values) ...[
                _ShopTypeTile(
                  type: type,
                  loading: provider.loading,
                  onTap: () async {
                    final ok = await context.read<SetupProvider>().pick(type);
                    if (!context.mounted) return;
                    if (ok) {
                      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(provider.error ?? 'Erro')),
                      );
                    }
                  },
                ),
                const SizedBox(height: 10),
              ],
              const SizedBox(height: OrdoSpacing.s6),
              Center(
                child: Text(
                  'Você pode trocar depois em Ajustes.',
                  style: OrdoTypography.body(
                    size: 11,
                    color: OrdoColors.fg3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShopTypeTile extends StatelessWidget {
  final ShopType type;
  final VoidCallback onTap;
  final bool loading;

  const _ShopTypeTile({
    required this.type,
    required this.onTap,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: loading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: OrdoColors.paper,
          border: Border.all(color: OrdoColors.border),
          borderRadius: BorderRadius.circular(14),
          boxShadow: OrdoShadows.sm,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: OrdoColors.slate100,
                borderRadius: BorderRadius.circular(OrdoRadius.md),
              ),
              alignment: Alignment.center,
              child: OrdoIcon(
                OrdoIcon.forShop(type.id),
                size: 22,
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
                    type.label,
                    style: OrdoTypography.display(
                      size: 16,
                      weight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Checklist específico para ${type.productNounPlural}',
                    style: OrdoTypography.body(size: 12, color: OrdoColors.fg2),
                  ),
                ],
              ),
            ),
            const OrdoIcon(
              OrdoIconName.chevronRight,
              size: 20,
              color: OrdoColors.fg3,
            ),
          ],
        ),
      ),
    );
  }
}
