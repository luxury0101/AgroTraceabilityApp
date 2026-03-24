import 'package:agro_traceability/core/storage/secure_storage_service.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageService secureStorageService;

  AuthInterceptor(this.secureStorageService);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await secureStorageService.getToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}
