
class DatabaseException {
  String? message;
  Exception? exception;
  DatabaseException({
    this.message,
    this.exception,
  });

  @override
  String toString() => 'DatabaseExceptions(message: $message, exception: $exception)';
}
