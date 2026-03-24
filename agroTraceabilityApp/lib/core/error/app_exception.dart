class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, {this.statusCode});

  @override
  String toString() =>
      'AppException(message: $message, statusCode: $statusCode)';
}

class NetworkException extends AppException {
  const NetworkException(super.message, {super.statusCode});
}

class UnauthorizedException extends AppException {
  const UnauthorizedException(super.message, {super.statusCode});
}

class NotFoundException extends AppException {
  const NotFoundException(super.message, {super.statusCode});
}

class ServerException extends AppException {
  const ServerException(super.message, {super.statusCode});
}

class TimeoutExceptionApp extends AppException {
  const TimeoutExceptionApp(super.message, {super.statusCode});
}

class UnknownException extends AppException {
  const UnknownException(super.message, {super.statusCode});
}
