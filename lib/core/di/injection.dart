import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../features/auth/presentation/controllers/login_controller.dart';
import '../../features/clients/data/datasources/cep_remote_datasource.dart';
import '../../features/clients/data/datasources/client_local_datasource.dart';
import '../../features/clients/data/repositories/cep_repository_impl.dart';
import '../../features/clients/data/repositories/client_repository_impl.dart';
import '../../features/clients/domain/repositories/cep_repository.dart';
import '../../features/clients/domain/repositories/client_repository.dart';
import '../../features/clients/domain/usecases/create_client.dart';
import '../../features/clients/domain/usecases/get_client.dart';
import '../../features/clients/domain/usecases/list_clients.dart';
import '../../features/clients/domain/usecases/lookup_cep.dart';
import '../../features/clients/presentation/controllers/client_detail_controller.dart';
import '../../features/clients/presentation/controllers/clients_controller.dart';
import '../../features/service_order/data/datasources/mock_seed.dart';
import '../../features/service_order/data/datasources/service_order_local_datasource.dart';
import '../../features/service_order/data/repositories/service_order_repository_impl.dart';
import '../../features/service_order/domain/entities/client.dart';
import '../../features/service_order/domain/repositories/service_order_repository.dart';
import '../../features/service_order/domain/usecases/create_service_order.dart';
import '../../features/service_order/domain/usecases/get_checklist_template.dart';
import '../../features/service_order/domain/usecases/get_service_order.dart';
import '../../features/service_order/domain/usecases/list_service_orders.dart';
import '../../features/service_order/domain/usecases/toggle_checklist_item.dart';
import '../../features/service_order/domain/usecases/update_os_status.dart';
import '../../features/service_order/presentation/controllers/nova_os_controller.dart';
import '../../features/service_order/presentation/controllers/service_order_detail_controller.dart';
import '../../features/service_order/presentation/controllers/service_orders_controller.dart';
import '../../features/setup/presentation/controllers/setup_controller.dart';

/// Container DI do app.
///
/// **Padrão híbrido por camada:**
/// - `get_it` (`sl`) registra **datasources, repositórios e use cases**
///   — peças de domain/data que não conhecem GetX.
/// - **`Get`** (GetX) registra **controllers** — são a camada de
///   apresentação reativa e ficam disponíveis via `Get.find<T>()`.
///
/// Configurado em `main()` após `initStorage()`. **Nunca** importar
/// `sl` nas camadas domain/data.
final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  _registerCore();
  _registerControllers();
}

void _registerCore() {
  // ────────── Service Order feature ──────────
  // Seed in-memory com OS de exemplo do shop ativo (celular).
  final orderSeed = buildMockSeed('celular');
  sl.registerLazySingleton<ServiceOrderLocalDataSource>(
    () => InMemoryServiceOrderDataSource(seed: orderSeed),
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

  // ────────── Clients feature ──────────
  // Dedup dos clientes embarcados nas OS de seed — para que a lista de
  // clientes já abra preenchida coerente com o histórico de OS.
  final clientSeed = <String, Client>{};
  for (final o in orderSeed) {
    clientSeed.putIfAbsent(o.client.id, () => o.client);
  }
  sl.registerLazySingleton<ClientLocalDataSource>(
    () => InMemoryClientDataSource(seed: clientSeed.values.toList()),
  );
  sl.registerLazySingleton<ClientRepository>(
    () => ClientRepositoryImpl(sl()),
  );
  sl.registerFactory(() => ListClients(sl()));
  sl.registerFactory(() => GetClient(sl()));
  sl.registerFactory(() => CreateClient(sl()));

  // ────────── CEP / ViaCEP ──────────
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<CepRemoteDataSource>(
    () => ViaCepDataSource(client: sl()),
  );
  sl.registerLazySingleton<CepRepository>(() => CepRepositoryImpl(sl()));
  sl.registerFactory(() => LookupCep(sl()));
}

void _registerControllers() {
  // SetupController é permanent — usado em toda a app desde o splash.
  Get.put<SetupController>(SetupController(), permanent: true);

  // LoginController permanent — controla a flag de auth lida pelo splash.
  Get.put<LoginController>(LoginController(), permanent: true);

  // Demais controllers ficam lazy — só sobem quando alguém Get.find.
  Get.lazyPut<ServiceOrdersController>(
    () => ServiceOrdersController(sl(), sl()),
    fenix: true,
  );
  Get.lazyPut<ServiceOrderDetailController>(
    () => ServiceOrderDetailController(sl(), sl(), sl()),
    fenix: true,
  );
  Get.lazyPut<NovaOsController>(
    () => NovaOsController(sl(), sl(), sl()),
    fenix: true,
  );
  Get.lazyPut<ClientsController>(
    () => ClientsController(sl(), sl(), sl()),
    fenix: true,
  );
  Get.lazyPut<ClientDetailController>(
    () => ClientDetailController(sl(), sl()),
    fenix: true,
  );
}
