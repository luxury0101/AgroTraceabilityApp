import 'package:agro_traceability/core/routing/redirect_guard.dart';
import 'package:agro_traceability/core/routing/route_names.dart';
import 'package:agro_traceability/core/routing/route_paths.dart';
import 'package:agro_traceability/features/auth/presentation/providers/auth_provider.dart';
import 'package:agro_traceability/features/auth/presentation/screens/login_screen.dart';
import 'package:agro_traceability/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:agro_traceability/features/eventos/presentation/screens/create_evento_screen.dart';
import 'package:agro_traceability/features/eventos/presentation/screens/eventos_list_screen.dart';
import 'package:agro_traceability/features/lotes/presentation/screens/lote_detail_screen.dart';
import 'package:agro_traceability/features/lotes/presentation/screens/lotes_list_screen.dart';
import 'package:agro_traceability/features/trazabilidad/presentation/screens/trazabilidad_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: RoutePaths.login,
    redirect: (context, state) {
      return authRedirectGuard(
        authState: authState,
        currentLocation: state.matchedLocation,
      );
    },
    routes: [
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.dashboard,
        name: RouteNames.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: RoutePaths.lotes,
        name: RouteNames.lotes,
        builder: (context, state) => const LotesListScreen(),
        routes: [
          GoRoute(
            path: ':id',
            name: RouteNames.loteDetail,
            builder: (context, state) {
              final loteId = state.pathParameters['id'] ?? '';
              return LoteDetailScreen(loteId: loteId);
            },
            routes: [
              GoRoute(
                path: 'eventos',
                name: RouteNames.loteEventos,
                builder: (context, state) {
                  final loteId = state.pathParameters['id'] ?? '';
                  return EventosListScreen(loteId: loteId);
                },
              ),
              GoRoute(
                path: 'eventos/nuevo',
                name: RouteNames.createEvento,
                builder: (context, state) {
                  final loteId = state.pathParameters['id'] ?? '';
                  return CreateEventoScreen(loteId: loteId);
                },
              ),
              GoRoute(
                path: 'trazabilidad',
                name: RouteNames.loteTrazabilidad,
                builder: (context, state) {
                  final loteId = state.pathParameters['id'] ?? '';
                  return TrazabilidadScreen(loteId: loteId);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
