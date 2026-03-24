import 'package:agro_traceability/features/auth/domain/entities/user.dart';

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final bool isInitialized;
  final User? user;
  final String? errorMessage;

  const AuthState({
    required this.isLoading,
    required this.isAuthenticated,
    required this.isInitialized,
    required this.user,
    required this.errorMessage,
  });

  factory AuthState.initial() {
    return const AuthState(
      isLoading: false,
      isAuthenticated: false,
      isInitialized: false,
      user: null,
      errorMessage: null,
    );
  }

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    bool? isInitialized,
    User? user,
    String? errorMessage,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isInitialized: isInitialized ?? this.isInitialized,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: clearError ? null : errorMessage,
    );
  }
}
