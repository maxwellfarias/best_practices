
abstract interface class CustomLogger {
  void info(String message, {String? tag});

   void warning(String message, {String? tag, Object? error});

   void error(String message, {String? tag, Object? error, StackTrace? stackTrace});

   void debug(String message, {String? tag});
}