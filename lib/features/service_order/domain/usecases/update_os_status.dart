import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/os_status.dart';
import '../entities/service_order.dart';
import '../repositories/service_order_repository.dart';

class UpdateOsStatusParams {
  final String orderId;
  final OsStatus status;
  const UpdateOsStatusParams({required this.orderId, required this.status});
}

class UpdateOsStatus extends UseCase<ServiceOrder, UpdateOsStatusParams> {
  final ServiceOrderRepository _repo;
  const UpdateOsStatus(this._repo);

  @override
  Future<Result<ServiceOrder>> call(UpdateOsStatusParams params) =>
      _repo.updateStatus(params.orderId, params.status);
}
