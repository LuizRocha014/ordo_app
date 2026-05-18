import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../service_order/domain/entities/client.dart';
import '../repositories/client_repository.dart';

class ListClients implements UseCase<List<Client>, NoParams> {
  final ClientRepository _repo;

  ListClients(this._repo);

  @override
  Future<Result<List<Client>>> call(NoParams params) => _repo.list();
}
