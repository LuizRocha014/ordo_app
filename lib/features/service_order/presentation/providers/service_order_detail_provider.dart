import 'package:flutter/foundation.dart';

import '../../domain/entities/os_status.dart';
import '../../domain/entities/service_order.dart';
import '../../domain/usecases/get_service_order.dart';
import '../../domain/usecases/toggle_checklist_item.dart';
import '../../domain/usecases/update_os_status.dart';

class ServiceOrderDetailProvider extends ChangeNotifier {
  final GetServiceOrder _get;
  final UpdateOsStatus _update;
  final ToggleChecklistItem _toggle;

  ServiceOrderDetailProvider(this._get, this._update, this._toggle);

  ServiceOrder? _order;
  bool _loading = false;
  String? _error;

  ServiceOrder? get order => _order;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> load(String id) async {
    _loading = true;
    _error = null;
    notifyListeners();

    final result = await _get(id);
    result.fold(
      onSuccess: (o) => _order = o,
      onFailure: (f) => _error = f.message,
    );

    _loading = false;
    notifyListeners();
  }

  Future<bool> changeStatus(OsStatus status) async {
    if (_order == null) return false;
    final result = await _update(
      UpdateOsStatusParams(orderId: _order!.id, status: status),
    );
    return result.fold(
      onSuccess: (o) {
        _order = o;
        notifyListeners();
        return true;
      },
      onFailure: (f) {
        _error = f.message;
        notifyListeners();
        return false;
      },
    );
  }

  Future<bool> toggleChecklist(String itemId) async {
    if (_order == null) return false;
    final result = await _toggle(
      ToggleChecklistItemParams(orderId: _order!.id, itemId: itemId),
    );
    return result.fold(
      onSuccess: (o) {
        _order = o;
        notifyListeners();
        return true;
      },
      onFailure: (f) {
        _error = f.message;
        notifyListeners();
        return false;
      },
    );
  }
}
