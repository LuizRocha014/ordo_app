import 'package:get/get.dart';

import '../../domain/entities/os_status.dart';
import '../../domain/entities/service_order.dart';
import '../../domain/repositories/service_order_repository.dart';
import '../../domain/usecases/list_service_orders.dart';
import '../../domain/usecases/update_os_status.dart';

/// Estado da lista de OS (home + lista filtrada).
///
/// Tem um filtro por status interno; chamando `setStatusFilter()` o
/// controller recarrega a lista. KPIs derivam da última lista sem
/// filtro (mantida em `_all`).
class ServiceOrdersController extends GetxController {
  final ListServiceOrders _list;
  final UpdateOsStatus _updateStatus;

  ServiceOrdersController(this._list, this._updateStatus);

  final RxBool loading = false.obs;
  final RxnString error = RxnString();
  final RxList<ServiceOrder> _all = <ServiceOrder>[].obs;
  final RxList<ServiceOrder> items = <ServiceOrder>[].obs;
  final Rxn<OsStatus> statusFilter = Rxn<OsStatus>();
  final RxString query = ''.obs;

  // ────────── KPIs ──────────
  int get countAndamento =>
      _all.where((o) => o.status == OsStatus.andamento).length;
  int get countAguardando =>
      _all.where((o) => o.status == OsStatus.aguardando).length;
  int get countProntas =>
      _all.where((o) => o.status == OsStatus.pronta).length;
  int get countAbertas =>
      _all.where((o) => o.status == OsStatus.aberta).length;
  int get countStale {
    final now = DateTime.now();
    return _all
        .where((o) =>
            o.status != OsStatus.entregue &&
            o.status != OsStatus.cancelada &&
            now.difference(o.updatedAt).inHours > 48)
        .length;
  }

  Future<void> load() async {
    loading.value = true;
    error.value = null;

    final allResult = await _list(const ServiceOrderFilter());
    allResult.fold(
      onSuccess: (data) {
        _all.assignAll(data);
      },
      onFailure: (f) {
        error.value = f.message;
      },
    );

    await _applyFilter();
    loading.value = false;
  }

  Future<void> setStatusFilter(OsStatus? status) async {
    statusFilter.value = status;
    await _applyFilter();
  }

  Future<void> setQuery(String q) async {
    query.value = q;
    await _applyFilter();
  }

  Future<void> _applyFilter() async {
    final result = await _list(
      ServiceOrderFilter(status: statusFilter.value, query: query.value),
    );
    result.fold(
      onSuccess: items.assignAll,
      onFailure: (f) => error.value = f.message,
    );
  }

  Future<bool> updateStatus(String orderId, OsStatus status) async {
    final result = await _updateStatus(
      UpdateOsStatusParams(orderId: orderId, status: status),
    );
    return result.fold(
      onSuccess: (_) async {
        await load();
        return true;
      },
      onFailure: (f) {
        error.value = f.message;
        return false;
      },
    );
  }
}
