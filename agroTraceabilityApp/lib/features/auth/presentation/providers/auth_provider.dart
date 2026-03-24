import 'package:agro_traceability/core/error/app_exception.dart';
import 'package:agro_traceability/core/network/api_client.dart';
import 'package:agro_traceability/core/network/interceptors/auth_error_interceptor.dart';
import 'package:agro_traceability/core/network/interceptors/auth_interceptor.dart';
import 'package:agro_traceability/core/storage/secure_storage_service.dart';
import 'package:agro_traceability/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:agro_traceability/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:agro_traceability/features/auth/domain/usecases/login_usecase.dart';
import 'package:agro_traceability/features/auth/domain/usecases/logout_usecase.dart';
import 'package:agro_traceability/features/auth/domain/usecases/restore_session_usecase.dart';
import 'package:agro_traceability/features/auth/presentation/providers/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final secureStorageProvider = Provider<SecureStorageService>(
  (ref) => SecureStorageService(),
);

final authInterceptorProvider = Provider<AuthInterceptor>(
  (ref) => AuthInterceptor(ref.read(secureStorageProvider)),
);

final authErrorInterceptorProvider = Provider<AuthErrorInterceptor>(
  (ref) => AuthErrorInterceptor(ref),
);

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(
    authInterceptor: ref.read(authInterceptorProvider),
    authErrorInterceptor: ref.read(authErrorInterceptorProvider),
  ),
);

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSource(ref.read(apiClientProvider)),
);

final authRepositoryProvider = Provider<AuthRepositoryImpl>(
  (ref) => AuthRepositoryImpl(ref.read(authRemoteDataSourceProvider)),
);

final loginUseCaseProvider = Provider<LoginUseCase>(
  (ref) => LoginUseCase(ref.read(authRepositoryProvider)),
);

final logoutUseCaseProvider = Provider<LogoutUseCase>(
  (ref) => LogoutUseCase(ref.read(secureStorageProvider)),
);

final restoreSessionUseCaseProvider = Provider<RestoreSessionUseCase>(
  (ref) => RestoreSessionUseCase(ref.read(secureStorageProvider)),
);

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    loginUseCase: ref.read(loginUseCaseProvider),
    logoutUseCase: ref.read(logoutUseCaseProvider),
    restoreSessionUseCase: ref.read(restoreSessionUseCaseProvider),
    secureStorageService: ref.read(secureStorageProvider),
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final RestoreSessionUseCase restoreSessionUseCase;
  final SecureStorageService secureStorageService;

  AuthNotifier({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.restoreSessionUseCase,
    required this.secureStorageService,
  }) : super(AuthState.initial());

  Future<void> initializeAuth() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final session = await restoreSessionUseCase();

      if (session != null) {
        state = state.copyWith(
          isLoading: false,
          isInitialized: true,
          isAuthenticated: true,
          user: session.$2,
          clearError: true,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          isInitialized: true,
          isAuthenticated: false,
          clearUser: true,
          clearError: true,
        );
      }
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        isInitialized: true,
        isAuthenticated: false,
        clearUser: true,
        errorMessage: 'No se pudo restaurar la sesión',
      );
    }
  }

  Future<bool> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final result = await loginUseCase(email: email, password: password);

      await secureStorageService.saveToken(result.$1);
      await secureStorageService.saveUser({
        'id': result.$2.id,
        'fullName': result.$2.fullName,
        'email': result.$2.email,
        'role': result.$2.role,
      });

      state = state.copyWith(
        isLoading: false,
        isInitialized: true,
        isAuthenticated: true,
        user: result.$2,
        clearError: true,
      );

      return true;
    } on AppException catch (e) {
      state = state.copyWith(
        isLoading: false,
        isInitialized: true,
        isAuthenticated: false,
        errorMessage: e.message,
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        isInitialized: true,
        isAuthenticated: false,
        errorMessage: 'Ocurrió un error inesperado',
      );
      return false;
    }
  }

  Future<void> logout() async {
    await logoutUseCase();

    state = AuthState.initial().copyWith(isInitialized: true);
  }

  Future<void> forceLogout() async {
    await logoutUseCase();

    state = AuthState.initial().copyWith(
      isInitialized: true,
      errorMessage: 'Tu sesión expiró. Inicia sesión nuevamente.',
    );
  }
}
