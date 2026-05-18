import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/theme/ordo_colors.dart';
import '../../../../core/theme/ordo_spacing.dart';
import '../../../../core/theme/ordo_typography.dart';
import '../../../../shared/widgets/ordo_button.dart';
import '../../../../shared/widgets/ordo_icon.dart';
import '../../../../shared/widgets/top_bar.dart';

/// Placeholder de cadastro — apenas visual.
class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OrdoColors.bone,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(76),
        child: OrdoTopBar(
          title: 'Criar conta',
          subtitle: 'em breve',
          leading: OrdoIconButton(
            ghost: true,
            onTap: Get.back,
            child: const OrdoIcon(OrdoIconName.chevronLeft, size: 22),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
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
                'Em breve.',
                style: OrdoTypography.display(
                  size: 28,
                  weight: FontWeight.w700,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'O fluxo de cadastro de novas oficinas ainda está em '
                'construção. Por ora, use o email da sua conta para '
                'entrar na demo.',
                style: OrdoTypography.body(size: 14, color: OrdoColors.fg2),
              ),
              const SizedBox(height: OrdoSpacing.s8),
              OrdoButton(
                label: 'Voltar para o login',
                variant: OrdoButtonVariant.secondary,
                size: OrdoButtonSize.lg,
                full: true,
                onPressed: Get.back,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
