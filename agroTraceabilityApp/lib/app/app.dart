import 'package:agro_traceability/core/routing/app_router.dart';
import 'package:agro_traceability/core/session/auth_session_controller.dart';
import 'package:agro_traceability/core/theme/app_theme.dart';
import 'package:agro_traceability/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AgroTraceabilityApp extends ConsumerStatefulWidget {
  const AgroTraceabilityApp({super.key});

  @override
  ConsumerState<AgroTraceabilityApp> createState() =>
      _AgroTraceabilityAppState();
}

class _AgroTraceabilityAppState extends ConsumerState<AgroTraceabilityApp> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(authProvider.notifier).initializeAuth();
    });

    ref.listenManual<int>(authSessionControllerProvider, (
      previous,
      next,
    ) async {
      if (previous != null && next > previous) {
        await ref.read(authProvider.notifier).forceLogout();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    if (!authState.isInitialized && authState.isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'AgroTraceability',
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
