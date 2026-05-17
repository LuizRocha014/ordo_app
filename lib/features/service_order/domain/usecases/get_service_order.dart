import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/service_order.dart';
import '../repositories/service_order_repository.dart';

class GetServiceOrder extends UseCase<ServiceOrder, String> {
  final ServiceOrderRepository _repo;
  const GetServiceOrder(this._repo);

  @override
  Future<Result<ServiceOrder>> call(String params) => _repo.getById(params);
}
