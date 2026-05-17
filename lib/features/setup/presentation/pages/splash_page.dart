import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/ordo_colors.dart';
import '../../../../core/theme/ordo_typography.dart';
import '../controllers/setup_controller.dart';

/// Splash que dispara `bootstrap()` e decide entre Setup e Home.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _decide());
  }

  Future<void> _decide() async {
    final setup = Get.find<SetupController>();
    await setup.bootstrap();
    if (!mounted) return;
    Get.offNamed(setup.isConfigured ? AppRoutes.home : AppRoutes.setup);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OrdoColors.bone,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/svg/logo-mark.svg',
              width: 64,
              height: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Ordo',
              style: OrdoTypography.display(size: 28, weight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'Sua oficina, sob controle.',
              style: OrdoTypography.body(size: 13, color: OrdoColors.fg2),
            ),
          ],
        ),
      ),
    );
  }
}
