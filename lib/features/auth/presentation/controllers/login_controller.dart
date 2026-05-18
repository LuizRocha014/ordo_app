import 'package:componentes_lr/componentes_lr.dart' show sharedPreferences;
import 'package:get/get.dart';

/// Estado da autenticação (mock).
///
/// Não há backend nem use case real ainda — qualquer email/senha
/// passa. A flag de "logado" fica em SharedPreferences sob a chave
/// [_authKey], pra evitar pedir login a cada launch.
class LoginController extends GetxController {
  static const String _authKey = 'ordo.auth.logged_in';

  final RxBool loading = false.obs;
  final RxnString error = RxnString();

  bool get isLoggedIn => sharedPreferences.getBool(_authKey) ?? false;

  Future<bool> login({required String email, required String password}) async {
    error.value = null;

    if (email.trim().isEmpty || password.isEmpty) {
      error.value = 'Informe email e senha.';
      return false;
    }

    loading.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 600));
    await sharedPreferences.setBool(_authKey, true);
    loading.value = false;
    return true;
  }

  Future<void> logout() async {
    await sharedPreferences.setBool(_authKey, false);
  }
}
