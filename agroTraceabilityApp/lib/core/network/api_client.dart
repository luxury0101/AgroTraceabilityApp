import 'package:agro_traceability/core/config/app_config.dart';
import 'package:agro_traceability/core/network/interceptors/auth_error_interceptor.dart';
import 'package:agro_traceability/core/network/interceptors/auth_interceptor.dart';
import 'package:dio/dio.dart';

class ApiClient {
  late final Dio dio;

  ApiClient({
    required AuthInterceptor authInterceptor,
    required AuthErrorInterceptor authErrorInterceptor,
  }) {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(authInterceptor);
    dio.interceptors.add(authErrorInterceptor);
  }
}
