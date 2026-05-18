import '../../../../core/errors/failures.dart';
import '../../../../core/result/result.dart';
import '../../../service_order/domain/entities/client.dart';
import '../../domain/repositories/client_repository.dart';
import '../datasources/client_local_datasource.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientLocalDataSource _ds;

  ClientRepositoryImpl(this._ds);

  @override
  Future<Result<List<Client>>> list() async {
    try {
      final clients = await _ds.list();
      return Success(clients);
    } catch (e) {
      return FailureResult(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<Client>> getById(String id) async {
    try {
      final c = await _ds.getById(id);
      if (c == null) {
        return const FailureResult(NotFoundFailure('Cliente não encontrado.'));
      }
      return Success(c);
    } catch (e) {
      return FailureResult(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Result<Client>> create({
    required String name,
    required String phone,
    String? notes,
  }) async {
    final trimmedName = name.trim();
    final trimmedPhone = phone.trim();
    if (trimmedName.isEmpty) {
      return const FailureResult(
        ValidationFailure('Informe o nome do cliente.'),
      );
    }
    if (trimmedPhone.isEmpty) {
      return const FailureResult(
        ValidationFailure('Informe o telefone do cliente.'),
      );
    }
    try {
      final c = await _ds.create(
        name: trimmedName,
        phone: trimmedPhone,
        notes: notes,
      );
      return Success(c);
    } catch (e) {
      return FailureResult(UnexpectedFailure(e.toString()));
    }
  }
}
