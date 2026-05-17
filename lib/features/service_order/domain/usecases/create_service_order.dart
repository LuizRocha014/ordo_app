import '../../../../core/errors/failures.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/service_order.dart';
import '../repositories/service_order_repository.dart';

class CreateServiceOrderParams {
  final ServiceOrder draft;
  const CreateServiceOrderParams(this.draft);
}

class CreateServiceOrder extends UseCase<ServiceOrder, CreateServiceOrderParams> {
  final ServiceOrderRepository _repo;
  const CreateServiceOrder(this._repo);

  @override
  Future<Result<ServiceOrder>> call(CreateServiceOrderParams params) async {
    final draft = params.draft;

    if (draft.client.name.trim().isEmpty) {
      return const FailureResult(ValidationFailure('Informe o nome do cliente.'));
    }
    if (draft.client.phone.trim().isEmpty) {
      return const FailureResult(ValidationFailure('Informe o telefone do cliente.'));
    }
    if (draft.problem.trim().isEmpty) {
      return const FailureResult(
        ValidationFailure('Descreva o problema relatado pelo cliente.'),
      );
    }

    return _repo.create(draft);
  }
}
