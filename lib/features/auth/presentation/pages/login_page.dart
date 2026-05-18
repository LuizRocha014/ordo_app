import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/ordo_colors.dart';
import '../../../../core/theme/ordo_spacing.dart';
import '../../../../core/theme/ordo_typography.dart';
import '../../../../shared/widgets/ordo_button.dart';
import '../../../../shared/widgets/ordo_field.dart';
import '../controllers/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _controller = Get.find<LoginController>();
  final _emailCtl = TextEditingController();
  final _passwordCtl = TextEditingController();

  @override
  void dispose() {
    _emailCtl.dispose();
    _passwordCtl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = await _controller.login(
      email: _emailCtl.text,
      password: _passwordCtl.text,
    );
    if (ok) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.snackbar(
        'Não consegui entrar',
        _controller.error.value ?? 'Tente novamente.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                'Entre na sua\noficina.',
                style: OrdoTypography.display(
                  size: 28,
                  weight: FontWeight.w700,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Acesse o Ordo com o email da sua conta para abrir, '
                'acompanhar e fechar OS no celular.',
                style: OrdoTypography.body(size: 14, color: OrdoColors.fg2),
              ),
              const SizedBox(height: OrdoSpacing.s8),
              Text(
                'EMAIL',
                style: OrdoTypography.body(
                  size: 10,
                  weight: FontWeight.w600,
                  color: OrdoColors.fg3,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: OrdoSpacing.s2),
              OrdoField(
                controller: _emailCtl,
                placeholder: 'voce@oficina.com',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: OrdoSpacing.s4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'SENHA',
                    style: OrdoTypography.body(
                      size: 10,
                      weight: FontWeight.w600,
                      color: OrdoColors.fg3,
                      letterSpacing: 0.8,
                    ),
                  ),
                  _LinkText(
                    label: 'Esqueci minha senha',
                    onTap: () => Get.snackbar(
                      'Recuperação de senha',
                      'Ainda não disponível nesta versão.',
                      snackPosition: SnackPosition.BOTTOM,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: OrdoSpacing.s2),
              OrdoField(
                controller: _passwordCtl,
                placeholder: '••••••••',
                obscureText: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: OrdoSpacing.s6),
              Obx(() => OrdoButton(
                    label: 'Entrar',
                    variant: OrdoButtonVariant.accent,
                    size: OrdoButtonSize.lg,
                    full: true,
                    loading: _controller.loading.value,
                    onPressed:
                        _controller.loading.value ? null : _submit,
                  )),
              const SizedBox(height: OrdoSpacing.s6),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Ainda não tem conta?',
                      style: OrdoTypography.body(
                        size: 13,
                        color: OrdoColors.fg2,
                      ),
                    ),
                    const SizedBox(width: 6),
                    _LinkText(
                      label: 'Criar conta',
                      onTap: () => Get.toNamed(AppRoutes.signup),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinkText extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _LinkText({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Text(
        label,
        style: OrdoTypography.body(
          size: 13,
          weight: FontWeight.w600,
          color: OrdoColors.ink,
        ),
      ),
    );
  }
}
