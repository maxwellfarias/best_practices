// =============================================================================
// RESULT PATTERN - IMPLEMENTAÇÃO COMPLETA
// =============================================================================

import 'package:mastering_tests/exceptions/app_exception.dart';

/// Classe base que representa um resultado que pode ser sucesso ou erro
sealed class Result<T> {
  const Result();

  /// Cria um resultado de sucesso contendo o [value].
  const factory Result.ok(T value) = Ok._;

  /// Cria um resultado de erro contendo uma [AppException].
  const factory Result.error(AppException error) = Error._;

  // ---------------------------------------------------------------------------
  // Métodos utilitários para manipulação de resultados
  // ---------------------------------------------------------------------------

  /// Aplica uma transformação sobre o valor de sucesso (caso seja `Ok`).
  ///
  /// Se for `Error`, o erro é propagado sem alterações.
  Result<R> map<R>(R Function(T value) transform) => switch (this) {
        Ok(:final value) => Result.ok(transform(value)),
        Error(:final error) => Result.error(error),
      };

  /// Aplica uma transformação que retorna outro `Result`.
  ///
  /// Útil para **encadear operações que também retornam Result**.
  /// Evita `Result<Result<T>>` aninhados.
  Result<R> flatMap<R>(Result<R> Function(T value) transform) => switch (this) {
        Ok(:final value) => transform(value),
        Error(:final error) => Result.error(error),
      };

  /// Aplica uma transformação apenas no erro (caso seja `Error`).
  Result<T> mapError(AppException Function(AppException error) transform) =>
      switch (this) {
        Ok(:final value) => Result.ok(value),
        Error(:final error) => Result.error(transform(error)),
      };

  // ---------------------------------------------------------------------------
  // Getters úteis
  // ---------------------------------------------------------------------------

  /// Retorna `true` se o resultado for um sucesso (`Ok`).
  bool get isOk => this is Ok<T>;

  /// Retorna `true` se o resultado for um erro (`Error`).
  bool get isError => this is Error<T>;
}

/// Representa um resultado de **sucesso** contendo um valor de tipo `T`.
final class Ok<T> extends Result<T> {
  const Ok._(this.value);

  /// Valor retornado em caso de sucesso.
  final T value;

  @override
  String toString() => 'Result<$T>.ok($value)';
}

/// Representa um resultado de **erro** contendo uma exceção.
final class Error<T> extends Result<T> {
  const Error._(this.error);

  /// Erro retornado em caso de falha.
  final AppException error;

  @override
  String toString() => 'Result<$T>.error($error)';
}

// -----------------------------------------------------------------------------
// Extensões para facilitar o uso síncrono e assíncrono
// -----------------------------------------------------------------------------

/// Extensão para executar ações baseadas no resultado
extension ResultWhenExt<T> on Result<T> {
  /// Executa funções diferentes dependendo se é `Ok` ou `Error`.
  ///
  /// Útil para evitar escrever `switch` manualmente.
  void when({
    required void Function(T value) onOk,
    required void Function(Exception error) onError,
  }) {
    switch (this) {
      case Ok(:final value):
       onOk(value);
      case Error(:final error):
        onError(error);
    }
  }


  T? get valueOrNull => this is Ok<T> ? (this as Ok<T>).value : null;
}

/// Extensão para operações assíncronas
extension ResultAsyncExt<T> on Result<T> {
  /// Aplica uma transformação assíncrona sobre o valor de sucesso (`Ok`).
  ///
  /// Retorna um novo `Result` encapsulando o valor transformado.
  Future<Result<R>> mapAsync<R>(
      Future<R> Function(T value) transform) async =>
      switch (this) {
        Ok(:final value) => Result.ok(await transform(value)),
        Error(:final error) => Result.error(error),
      };

  /// Aplica uma transformação assíncrona que retorna outro `Result`.
  ///
  /// Ideal para encadear chamadas async que podem falhar.
  Future<Result<R>> flatMapAsync<R>(
      Future<Result<R>> Function(T value) transform) async =>
      switch (this) {
        Ok(:final value) => await transform(value),
        Error(:final error) => Result.error(error),
      };
}

extension FutureResultExt<T> on Future<Result<T>> {
  /// Aplica uma transformação sobre o valor de sucesso de um Future<Result<T>>.
  ///
  /// Permite encadear operações sem usar .then()
  /// 
  /// Exemplo:
  /// ```dart
  /// final result = await apiCall()
  ///   .mapAsync((data) => processData(data))
  ///   .mapAsync((processed) => saveData(processed));
  /// ```
  Future<Result<R>> mapAsync<R>(
    Future<R> Function(T value) transform,
  ) async {
    final result = await this;
    return switch (result) {
      Ok(:final value) => Result.ok(await transform(value)),
      Error(:final error) => Result.error(error),
    };
  }

  /// Aplica uma transformação síncrona sobre o valor de sucesso.
  ///
  /// Exemplo:
  /// ```dart
  /// final result = await apiCall()
  ///   .map((data) => data.length);
  /// ```
  Future<Result<R>> map<R>(
    R Function(T value) transform,
  ) async {
    final result = await this;
    return switch (result) {
      Ok(:final value) => Result.ok(transform(value)),
      Error(:final error) => Result.error(error),
    };
  }

  /// Aplica uma transformação que retorna outro Future<Result<R>>.
  ///
  /// Evita Future<Result<Result<T>>> aninhados.
  /// 
  /// Exemplo:
  /// ```dart
  /// final result = await getUserId()
  ///   .flatMapAsync((id) => getUserProfile(id))
  ///   .flatMapAsync((profile) => getUserPreferences(profile.id));
  /// ```
  Future<Result<R>> flatMapAsync<R>(
    Future<Result<R>> Function(T value) transform,
  ) async {
    final result = await this;
    return switch (result) {
      Ok(:final value) => await transform(value),
      Error(:final error) => Result.error(error),
    };
  }

  /// Aplica uma transformação que retorna outro Result<R>.
  ///
  /// Exemplo:
  /// ```dart
  /// final result = await apiCall()
  ///   .flatMap((data) => validateData(data));
  /// ```
  Future<Result<R>> flatMap<R>(
    Result<R> Function(T value) transform,
  ) async {
    final result = await this;
    return switch (result) {
      Ok(:final value) => transform(value),
      Error(:final error) => Result.error(error),
    };
  }

  /// Executa uma ação apenas se o resultado for sucesso.
  ///
  /// Exemplo:
  /// ```dart
  /// await apiCall()
  ///   .onSuccess((data) async => await logSuccess(data))
  ///   .onError((error) async => await logError(error));
  /// ```
  Future<Result<T>> onSuccess(
    Future<void> Function(T value) action,
  ) async {
    final result = await this;
    if (result case Ok(:final value)) {
      await action(value);
    }
    return result;
  }

  /// Executa uma ação apenas se o resultado for erro.
  Future<Result<T>> onError(
    Future<void> Function(AppException error) action,
  ) async {
    final result = await this;
    if (result case Error(:final error)) {
      await action(error);
    }
    return result;
  }

  /// Transforma erro em um valor padrão.
  ///
  /// Exemplo:
  /// ```dart
  /// final data = await apiCall()
  ///   .recover((error) => defaultData);
  /// ```
  Future<Result<T>> recover(
    T Function(AppException error) recovery,
  ) async {
    final result = await this;
    return switch (result) {
      Ok() => result,
      Error(:final error) => Result.ok(recovery(error)),
    };
  }

  /// Transforma erro usando uma função assíncrona.
  Future<Result<T>> recoverAsync(
    Future<T> Function(AppException error) recovery,
  ) async {
    final result = await this;
    return switch (result) {
      Ok() => result,
      Error(:final error) => Result.ok(await recovery(error)),
    };
  }
}