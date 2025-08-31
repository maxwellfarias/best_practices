/// Result pattern para tratamento de erros
/// 
/// Implementação do Result pattern conforme documentação oficial do Dart
/// para tratamento de erros sem exceptions.
sealed class Result<T> {
  const Result();

  /// Cria um resultado de sucesso
  factory Result.success(T data) = Success<T>;

  /// Cria um resultado de erro
  factory Result.failure(String error) = Failure<T>;

  /// Verifica se o resultado é um sucesso
  bool get isSuccess => this is Success<T>;

  /// Verifica se o resultado é um erro
  bool get isFailure => this is Failure<T>;

  /// Executa diferentes ações baseadas no tipo do resultado
  R when<R>({
    required R Function(T data) success,
    required R Function(String error) failure,
  }) {
    return switch (this) {
      Success<T>(data: final data) => success(data),
      Failure<T>(error: final error) => failure(error),
    };
  }

  /// Executa diferentes ações baseadas no tipo do resultado (opcional)
  R? whenOrNull<R>({
    R Function(T data)? success,
    R Function(String error)? failure,
  }) {
    return switch (this) {
      Success<T>(data: final data) => success?.call(data),
      Failure<T>(error: final error) => failure?.call(error),
    };
  }

  /// Mapeia o valor de sucesso para outro tipo
  Result<R> map<R>(R Function(T) mapper) {
    return when(
      success: (data) => Result.success(mapper(data)),
      failure: (error) => Result.failure(error),
    );
  }

  /// Mapeia erros para outros erros
  Result<T> mapError(String Function(String) mapper) {
    return when(
      success: (data) => Result.success(data),
      failure: (error) => Result.failure(mapper(error)),
    );
  }
}

/// Implementação para resultado de sucesso
final class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Success<T> && other.data == data);
  }

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'Success(data: $data)';
}

/// Implementação para resultado de erro
final class Failure<T> extends Result<T> {
  final String error;

  const Failure(this.error);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Failure<T> && other.error == error);
  }

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'Failure(error: $error)';
}
