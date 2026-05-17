import 'package:get_it/get_it.dart';

import '../../features/service_order/data/datasources/mock_seed.dart';
import '../../features/service_order/data/datasources/service_order_local_datasource.dart';
import '../../features/service_order/data/repositories/service_order_repository_impl.dart';
import '../../features/service_order/domain/repositories/service_order_repository.dart';
import '../../features/service_order/domain/usecases/create_service_order.dart';
import '../../features/service_order/domain/usecases/get_checklist_template.dart';
import '../../features/service_order/domain/usecases/get_service_order.dart';
import '../../features/service_order/domain/usecases/list_service_orders.dart';
import '../../features/service_order/domain/usecases/toggle_checklist_item.dart';
import '../../features/service_order/domain/usecases/update_os_status.dart';
import '../../features/setup/data/datasources/shop_local_datasource.dart';
import '../../features/setup/data/repositories/shop_repository_impl.dart';
import '../../features/setup/domain/repositories/shop_repository.dart';
import '../../features/setup/domain/usecases/get_shop_type.dart';
import '../../features/setup/domain/usecases/save_shop_type.dart';

/// Container DI do app.
///
/// Configurado em `main()` após `initStorage()`. Usar somente nos
/// pontos de composição (ChangeNotifierProvider) e no
/// `_AppShell._loadProviders`. **Nunca** importar `sl` nas camadas
/// domain/data.
final GetIt sl = GetIt.instance;

Future<void> configureDependencies({required String initialShopId}) async {
  // ────────── Setup feature ──────────
  sl.registerLazySingleton<ShopLocalDataSource>(() => ShopLocalDataSourceImpl());
  sl.registerLazySingleton<ShopRepository>(
    () => ShopRepositoryImpl(sl()),
  );
  sl.registerFactory(() => GetShopType(sl()));
  sl.registerFactory(() => SaveShopType(sl()));

  // ────────── Service Order feature ──────────
  // Seed in-memory com OS de exemplo do shop atual (se houver). Quando o
  // shop ainda não está configurado (primeiro launch), começa vazio.
  sl.registerLazySingleton<ServiceOrderLocalDataSource>(
    () => InMemoryServiceOrderDataSource(
      seed: buildMockSeed(initialShopId),
    ),
  );
  sl.registerLazySingleton<ServiceOrderRepository>(
    () => ServiceOrderRepositoryImpl(sl()),
  );
  sl.registerFactory(() => ListServiceOrders(sl()));
  sl.registerFactory(() => GetServiceOrder(sl()));
  sl.registerFactory(() => CreateServiceOrder(sl()));
  sl.registerFactory(() => UpdateOsStatus(sl()));
  sl.registerFactory(() => ToggleChecklistItem(sl()));
  sl.registerFactory(() => GetChecklistTemplate(sl()));
}
