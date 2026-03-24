import 'package:agro_traceability/core/error/app_exception.dart';
import 'package:agro_traceability/core/error/error_messages.dart';
import 'package:dio/dio.dart';

class ErrorMapper {
  static AppException mapDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutExceptionApp(ErrorMessages.timeout);

      case DioExceptionType.connectionError:
        return const NetworkException(ErrorMessages.network);

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = _extractMessage(error.response?.data);

        switch (statusCode) {
          case 400:
            return AppException(
              message ?? ErrorMessages.unknown,
              statusCode: statusCode,
            );
          case 401:
            return UnauthorizedException(
              message ?? ErrorMessages.unauthorized,
              statusCode: statusCode,
            );
          case 403:
            return AppException(
              message ?? ErrorMessages.forbidden,
              statusCode: statusCode,
            );
          case 404:
            return NotFoundException(
              message ?? ErrorMessages.notFound,
              statusCode: statusCode,
            );
          case 500:
          case 502:
          case 503:
            return ServerException(
              message ?? ErrorMessages.server,
              statusCode: statusCode,
            );
          default:
            return UnknownException(
              message ?? ErrorMessages.unknown,
              statusCode: statusCode,
            );
        }

      case DioExceptionType.cancel:
        return const AppException('La solicitud fue cancelada.');

      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return const UnknownException(ErrorMessages.unknown);
    }
  }

  static String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data['message'] != null) {
        return data['message'].toString();
      }
      if (data['error'] != null) {
        return data['error'].toString();
      }
    }

    return null;
  }
}
