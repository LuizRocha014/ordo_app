import 'package:componentes_lr/componentes_lr.dart' show initStorage;
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'core/di/injection.dart';

/// Bootstrap do Ordo.
///
/// 1. Inicializa formatadores PT-BR.
/// 2. Inicializa storage do `componentes_lr` (SharedPreferences + Secure
///    Storage) — usado pelo LoginController para persistir a flag de auth.
/// 3. Configura o container DI e roda o app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('pt_BR', null);
  await initStorage();

  await configureDependencies();

  runApp(const OrdoApp());
}
