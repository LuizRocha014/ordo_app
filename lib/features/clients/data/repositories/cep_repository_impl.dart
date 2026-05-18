import '../../../../core/errors/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/cep_lookup_result.dart';
import '../../domain/repositories/cep_repository.dart';
import '../datasources/cep_remote_datasource.dart';

class CepRepositoryImpl implements CepRepository {
  final CepRemoteDataSource _ds;

  CepRepositoryImpl(this._ds);

  @override
  Future<Result<CepLookupResult>> lookup(String cep) async {
    try {
      final result = await _ds.lookup(cep);
      return Success(result);
    } on CepInvalidException catch (e) {
      return FailureResult(ValidationFailure(e.message));
    } on CepNotFoundException {
      return const FailureResult(NotFoundFailure('CEP não encontrado.'));
    } catch (e) {
      return FailureResult(
        NetworkFailure('Não consegui consultar o CEP.', cause: e),
      );
    }
  }
}
