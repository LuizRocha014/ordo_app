import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/ordo_motion.dart';
import 'core/theme/ordo_theme.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/signup_page.dart';
import 'features/clients/presentation/pages/cadastro_cliente_page.dart';
import 'features/clients/presentation/pages/cliente_detail_page.dart';
import 'features/clients/presentation/pages/clients_page.dart';
import 'features/service_order/presentation/pages/checklist_page.dart';
import 'features/service_order/presentation/pages/home_page.dart';
import 'features/service_order/presentation/pages/nova_os_page.dart';
import 'features/service_order/presentation/pages/os_detail_page.dart';
import 'features/service_order/presentation/pages/os_list_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'features/setup/presentation/pages/splash_page.dart';

/// Rotas que correspondem às tabs do bottom nav.
///
/// Quando o usuário troca de tab, queremos uma transição suave (fade)
/// em vez do slide nativo de push — essas rotas usam `GetPageRoute`
/// com `Transition.fadeIn`. As demais (subpáginas: detalhe, formulário,
/// etc.) seguem o `MaterialPageRoute` padrão.
const _tabRoutes = {
  AppRoutes.home,
  AppRoutes.osList,
  AppRoutes.clients,
  AppRoutes.settings,
};

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
    final body = _pageFor(settings);
    if (body == null) return null;

    if (_tabRoutes.contains(settings.name)) {
      return GetPageRoute(
        settings: settings,
        page: () => body,
        transition: Transition.fadeIn,
        curve: OrdoMotion.easeStandard,
        transitionDuration: const Duration(milliseconds: 220),
      );
    }

    return MaterialPageRoute(settings: settings, builder: (_) => body);
  }

  Widget? _pageFor(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return const SplashPage();
      case AppRoutes.login:
        return const LoginPage();
      case AppRoutes.signup:
        return const SignupPage();
      case AppRoutes.home:
        return const HomePage();
      case AppRoutes.osList:
        return const OsListPage();
      case AppRoutes.clients:
        return const ClientsPage();
      case AppRoutes.settings:
        return const SettingsPage();
      case AppRoutes.novaOs:
        return const NovaOsPage();
      case AppRoutes.checklist:
        return ChecklistPage(orderId: settings.arguments as String);
      case AppRoutes.osDetail:
        return OsDetailPage(orderId: settings.arguments as String);
      case AppRoutes.cadastroCliente:
        return const CadastroClientePage();
      case AppRoutes.clienteDetail:
        return ClienteDetailPage(clientId: settings.arguments as String);
      default:
        return null;
    }
  }
}
