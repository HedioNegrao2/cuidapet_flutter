import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:logger/logger.dart' as log;

class Logger implements ILogger{

  final _logger = log.Logger();

  @override
  void debug(message, [error, StackTrace? stacktrace]) => _logger.d(message, error, stacktrace); 

  @override
  void error(message, [error, StackTrace? stacktrace]) => _logger.e(message, error, stacktrace); 

  @override
  void innfo(message, [error, StackTrace? stacktrace]) => _logger.i(message, error, stacktrace); 

  @override
  void warning(message, [error, StackTrace? stacktrace]) => _logger.w(message, error, stacktrace); 
  
}