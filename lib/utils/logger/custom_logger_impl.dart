
import 'package:logger/web.dart';
import 'package:best_practices/utils/logger/custom_logger.dart';

/// Esta classe é responsável por registrar logs da aplicação.
/// Ela fornece métodos para registrar mensagens de informação, aviso, erro e depuração.
/// `info`, `warning`, `error` e `debug` são os métodos principais para registrar mensagens com diferentes níveis de severidade.
/// `name:` Geralmente é utilizado o nome do componente/classe que está registrando o log.
final class CustomLoggerImpl implements CustomLogger {
CustomLoggerImpl({required Logger logger}) : _logger = logger;
final Logger _logger;

  @override
  void info(String message, {String? tag}) {
    _logger.i(message, time: DateTime.now());
  }

  @override
   void warning(String message, {String? tag, Object? error}) {
    _logger.w(message, error: error, time: DateTime.now());
  }

  @override
   void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _logger.e(
      message,
      error: error,
      stackTrace: stackTrace,
      time: DateTime.now(),
    );
  }

  @override
   void debug(String message, {String? tag}) {
    _logger.d(message, time: DateTime.now());
  }
}