import 'package:flutter/foundation.dart';

import '../../domain/entities/os_status.dart';
import '../../domain/entities/service_order.dart';
import '../../domain/repositories/service_order_repository.dart';
import '../../domain/usecases/list_service_orders.dart';
import '../../domain/usecases/update_os_status.dart';

/// Estado da lista de OS (home + lista filtrada).
///
/// Tem um filtro por status interno; chamando `setFilter()` o provider
/// recarrega a lista. KPIs derivam da última lista carregada sem
/// filtro.
class ServiceOrdersProvider extends ChangeNotifier {
  final ListServiceOrders _list;
  final UpdateOsStatus _updateStatus;

  ServiceOrdersProvider(this._list, this._updateStatus);

  bool _loading = false;
  String? _error;
  List<ServiceOrder> _all = const [];
  List<ServiceOrder> _filtered = const [];
  OsStatus? _statusFilter;
  String _query = '';

  bool get loading => _loading;
  String? get error => _error;
  List<ServiceOrder> get items => _filtered;
  OsStatus? get statusFilter => _statusFilter;
  String get query => _query;

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
    _loading = true;
    _error = null;
    notifyListeners();

    final allResult = await _list(const ServiceOrderFilter());
    allResult.fold(
      onSuccess: (data) {
        _all = data;
      },
      onFailure: (f) {
        _error = f.message;
      },
    );

    await _applyFilter();
    _loading = false;
    notifyListeners();
  }

  Future<void> setStatusFilter(OsStatus? status) async {
    _statusFilter = status;
    await _applyFilter();
    notifyListeners();
  }

  Future<void> setQuery(String q) async {
    _query = q;
    await _applyFilter();
    notifyListeners();
  }

  Future<void> _applyFilter() async {
    final result = await _list(
      ServiceOrderFilter(status: _statusFilter, query: _query),
    );
    result.fold(
      onSuccess: (data) {
        _filtered = data;
      },
      onFailure: (f) {
        _error = f.message;
      },
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
        _error = f.message;
        notifyListeners();
        return false;
      },
    );
  }
}
