import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/ordo_theme.dart';
import 'features/service_order/presentation/pages/checklist_page.dart';
import 'features/service_order/presentation/pages/home_page.dart';
import 'features/service_order/presentation/pages/nova_os_page.dart';
import 'features/service_order/presentation/pages/os_detail_page.dart';
import 'features/service_order/presentation/pages/os_list_page.dart';
import 'features/setup/presentation/pages/setup_page.dart';
import 'features/setup/presentation/pages/splash_page.dart';

class OrdoApp extends StatelessWidget {
  const OrdoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Ordo',
      debugShowCheckedModeBanner: false,
      theme: OrdoTheme.light(),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case AppRoutes.setup:
        return MaterialPageRoute(builder: (_) => const SetupPage());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case AppRoutes.osList:
        return MaterialPageRoute(builder: (_) => const OsListPage());
      case AppRoutes.novaOs:
        return MaterialPageRoute(builder: (_) => const NovaOsPage());
      case AppRoutes.checklist:
        final id = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ChecklistPage(orderId: id),
        );
      case AppRoutes.osDetail:
        final id = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => OsDetailPage(orderId: id),
        );
      default:
        return null;
    }
  }
}
