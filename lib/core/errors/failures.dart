/// Erros tratáveis na camada de domínio.
///
/// Camadas de apresentação e domínio nunca recebem `Exception` cru —
/// somente `Failure`. Cada feature pode estender essa classe se precisar
/// de um tipo mais específico (ex.: `NotFoundFailure`).
sealed class Failure {
  final String message;
  final Object? cause;

  const Failure(this.message, {this.cause});

  @override
  String toString() => '$runtimeType: $message';
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message, {super.cause});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message, {super.cause});
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.cause});
}

class StorageFailure extends Failure {
  const StorageFailure(super.message, {super.cause});
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.cause});
}
