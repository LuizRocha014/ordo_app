import '../result/result.dart';

/// Contrato base para use cases.
///
/// Use cases recebem `Params` e retornam `Future<Result<T>>`. Quando não
/// houver parâmetros, use `NoParams`.
abstract class UseCase<T, Params> {
  const UseCase();
  Future<Result<T>> call(Params params);
}

class NoParams {
  const NoParams();
}

/// Marker para use cases síncronos puros (raros — preferir `UseCase`).
abstract class SyncUseCase<T, Params> {
  const SyncUseCase();
  Result<T> call(Params params);
}
