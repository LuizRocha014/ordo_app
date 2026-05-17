import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/service_order.dart';
import '../repositories/service_order_repository.dart';

class ToggleChecklistItemParams {
  final String orderId;
  final String itemId;
  const ToggleChecklistItemParams({required this.orderId, required this.itemId});
}

class ToggleChecklistItem
    extends UseCase<ServiceOrder, ToggleChecklistItemParams> {
  final ServiceOrderRepository _repo;
  const ToggleChecklistItem(this._repo);

  @override
  Future<Result<ServiceOrder>> call(ToggleChecklistItemParams params) =>
      _repo.toggleChecklistItem(params.orderId, params.itemId);
}
