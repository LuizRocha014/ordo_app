import '../../../../core/result/result.dart';
import '../entities/cep_lookup_result.dart';

abstract class CepRepository {
  /// Consulta CEP via ViaCEP. Falha em `ValidationFailure` se o CEP
  /// é inválido (≠ 8 dígitos), `NotFoundFailure` se ViaCEP retorna
  /// `erro: true`, ou `NetworkFailure` em qualquer erro de rede.
  Future<Result<CepLookupResult>> lookup(String cep);
}
