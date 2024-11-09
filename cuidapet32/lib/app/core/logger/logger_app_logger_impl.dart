
import 'package:cuidapet32/app/core/logger/app_logger.dart';
import 'package:logger/logger.dart';

class LoggerAppLoggerImpl implements AppLogger {
  final logger = Logger();

  var messages =<String>[];

  
  
 
  @override
  void dabug(message, [error, StackTrace? stackTrace]) =>
    logger.d(message, error:error, stackTrace:stackTrace);
  

  @override
  void error(message, [error, StackTrace? stackTrace]) =>
    logger.e(message, error:error, stackTrace:stackTrace);

  @override
  void info(message, [rror, StackTrace? stackTrace])=>
    logger.i(message, error:error, stackTrace:stackTrace);

  @override
  void warning(message,[ error, StackTrace? stackTrace])=>
    logger.w(message, error:error, stackTrace:stackTrace);

   @override
  void append(message) {
    messages.add(message);
  }

  @override
  void closeAppende() {
    info(messages.join('\n'));
    messages = [];
  }
 
}