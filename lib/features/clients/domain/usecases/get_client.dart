import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../service_order/domain/entities/client.dart';
import '../repositories/client_repository.dart';

class GetClient implements UseCase<Client, String> {
  final ClientRepository _repo;

  GetClient(this._repo);

  @override
  Future<Result<Client>> call(String id) => _repo.getById(id);
}
