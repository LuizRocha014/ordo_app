import 'package:get/get.dart';

import '../../domain/entities/os_status.dart';
import '../../domain/entities/service_order.dart';
import '../../domain/usecases/get_service_order.dart';
import '../../domain/usecases/toggle_checklist_item.dart';
import '../../domain/usecases/update_os_status.dart';

class ServiceOrderDetailController extends GetxController {
  final GetServiceOrder _get;
  final UpdateOsStatus _update;
  final ToggleChecklistItem _toggle;

  ServiceOrderDetailController(this._get, this._update, this._toggle);

  final Rxn<ServiceOrder> order = Rxn<ServiceOrder>();
  final RxBool loading = false.obs;
  final RxnString error = RxnString();

  Future<void> load(String id) async {
    loading.value = true;
    error.value = null;

    final result = await _get(id);
    result.fold(
      onSuccess: (o) => order.value = o,
      onFailure: (f) => error.value = f.message,
    );

    loading.value = false;
  }

  Future<bool> changeStatus(OsStatus status) async {
    final current = order.value;
    if (current == null) return false;

    final result = await _update(
      UpdateOsStatusParams(orderId: current.id, status: status),
    );
    return result.fold(
      onSuccess: (o) {
        order.value = o;
        return true;
      },
      onFailure: (f) {
        error.value = f.message;
        return false;
      },
    );
  }

  Future<bool> toggleChecklist(String itemId) async {
    final current = order.value;
    if (current == null) return false;

    final result = await _toggle(
      ToggleChecklistItemParams(orderId: current.id, itemId: itemId),
    );
    return result.fold(
      onSuccess: (o) {
        order.value = o;
        return true;
      },
      onFailure: (f) {
        error.value = f.message;
        return false;
      },
    );
  }
}
