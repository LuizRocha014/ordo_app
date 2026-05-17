import '../../../../core/result/result.dart';
import '../entities/checklist_item.dart';
import '../entities/os_status.dart';
import '../entities/service_order.dart';

/// Filtro opcional sobre a lista de OS.
class ServiceOrderFilter {
  final OsStatus? status;
  final String? query;

  const ServiceOrderFilter({this.status, this.query});

  bool get isEmpty => status == null && (query == null || query!.isEmpty);
}

abstract class ServiceOrderRepository {
  Future<Result<List<ServiceOrder>>> list(ServiceOrderFilter filter);

  Future<Result<ServiceOrder>> getById(String id);

  Future<Result<ServiceOrder>> create(ServiceOrder order);

  Future<Result<ServiceOrder>> updateStatus(String id, OsStatus status);

  Future<Result<ServiceOrder>> toggleChecklistItem(
    String orderId,
    String itemId,
  );

  Future<Result<List<ChecklistItem>>> templateFor(String shopTypeId);
}
