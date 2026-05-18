import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cep_lookup_result.dart';
import '../repositories/cep_repository.dart';

class LookupCep implements UseCase<CepLookupResult, String> {
  final CepRepository _repo;

  LookupCep(this._repo);

  @override
  Future<Result<CepLookupResult>> call(String cep) => _repo.lookup(cep);
}
