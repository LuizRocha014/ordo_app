import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../service_order/domain/entities/address.dart';
import '../../../service_order/domain/entities/client.dart';
import '../repositories/client_repository.dart';

class CreateClientParams {
  final String name;
  final String phone;
  final String? email;
  final String? cpf;
  final Address? address;
  final String? notes;

  const CreateClientParams({
    required this.name,
    required this.phone,
    this.email,
    this.cpf,
    this.address,
    this.notes,
  });
}

class CreateClient implements UseCase<Client, CreateClientParams> {
  final ClientRepository _repo;

  CreateClient(this._repo);

  @override
  Future<Result<Client>> call(CreateClientParams params) => _repo.create(
        name: params.name,
        phone: params.phone,
        email: params.email,
        cpf: params.cpf,
        address: params.address,
        notes: params.notes,
      );
}
