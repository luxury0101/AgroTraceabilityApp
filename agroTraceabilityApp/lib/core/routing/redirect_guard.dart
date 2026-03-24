import 'package:agro_traceability/core/routing/route_paths.dart';
import 'package:agro_traceability/features/auth/presentation/providers/auth_state.dart';

String? authRedirectGuard({
  required AuthState authState,
  required String currentLocation,
}) {
  final isGoingToLogin = currentLocation == RoutePaths.login;
  final isAuthenticated = authState.isAuthenticated;
  final isInitialized = authState.isInitialized;

  if (!isInitialized) {
    return null;
  }

  if (!isAuthenticated && !isGoingToLogin) {
    return RoutePaths.login;
  }

  if (isAuthenticated && isGoingToLogin) {
    return RoutePaths.dashboard;
  }

  return null;
}
