abstract interface class ILogger {
  void debug(dynamic message,[dynamic error, StackTrace? stacktrace]);
  void error(dynamic message,[dynamic error, StackTrace? stacktrace]);
  void warning(dynamic message,[dynamic error, StackTrace? stacktrace]);
  void innfo(dynamic message,[dynamic error, StackTrace? stacktrace]);

}