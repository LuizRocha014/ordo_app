import 'package:componentes_lr/componentes_lr.dart' show initStorage, sharedPreferences;
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'features/setup/domain/entities/shop_type.dart';

/// Bootstrap do Ordo.
///
/// 1. Inicializa formatadores PT-BR.
/// 2. Inicializa storage do `componentes_lr` (SharedPreferences + Secure
///    Storage). `sharedPreferences` fica disponível para o resto do app.
/// 3. Lê o `shop_type` já configurado (se houver) — necessário antes do
///    `configureDependencies()` porque o datasource in-memory pré-carrega
///    mocks da categoria correta para a demo.
/// 4. Configura o container DI e roda o app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('pt_BR', null);
  await initStorage();

  final storedId = sharedPreferences.getString('ordo.shop_type.id');
  final initialShop = ShopType.fromId(storedId);

  await configureDependencies(initialShopId: initialShop?.id ?? 'celular');

  runApp(const OrdoApp());
}
