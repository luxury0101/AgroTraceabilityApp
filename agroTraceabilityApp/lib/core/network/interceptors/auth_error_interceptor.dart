import 'package:agro_traceability/core/session/auth_session_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthErrorInterceptor extends Interceptor {
  final Ref ref;

  AuthErrorInterceptor(this.ref);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;

    if (statusCode == 401) {
      ref.read(authSessionControllerProvider.notifier).notifySessionExpired();
    }

    handler.next(err);
  }
}
