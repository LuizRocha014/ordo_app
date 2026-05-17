import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/service_order.dart';
import '../repositories/service_order_repository.dart';

class ListServiceOrders extends UseCase<List<ServiceOrder>, ServiceOrderFilter> {
  final ServiceOrderRepository _repo;
  const ListServiceOrders(this._repo);

  @override
  Future<Result<List<ServiceOrder>>> call(ServiceOrderFilter params) =>
      _repo.list(params);
}
