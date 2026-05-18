import 'package:get/get.dart';

import '../../../service_order/domain/entities/client.dart';
import '../../../service_order/domain/entities/service_order.dart';
import '../../../service_order/domain/repositories/service_order_repository.dart';
import '../../../service_order/domain/usecases/list_service_orders.dart';
import '../../domain/usecases/get_client.dart';

/// Estado da página de detalhe de cliente — carrega o cliente + as
/// OS dele a partir da lista geral filtrada por `client.id`.
class ClientDetailController extends GetxController {
  final GetClient _getClient;
  final ListServiceOrders _listOrders;

  ClientDetailController(this._getClient, this._listOrders);

  final RxBool loading = false.obs;
  final RxnString error = RxnString();
  final Rxn<Client> client = Rxn<Client>();
  final RxList<ServiceOrder> orders = <ServiceOrder>[].obs;

  Future<void> load(String clientId) async {
    loading.value = true;
    error.value = null;

    final clientResult = await _getClient(clientId);
    clientResult.fold(
      onSuccess: (c) => client.value = c,
      onFailure: (f) => error.value = f.message,
    );

    final ordersResult = await _listOrders(const ServiceOrderFilter());
    ordersResult.fold(
      onSuccess: (list) {
        orders.assignAll(list.where((o) => o.client.id == clientId));
      },
      onFailure: (f) => error.value = f.message,
    );

    loading.value = false;
  }
}
