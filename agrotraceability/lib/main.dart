import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const AgroTraceabilityApp(),
    ),
  );
}

class AgroTraceabilityApp extends StatelessWidget {
  const AgroTraceabilityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgroTraceability',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await context.read<AuthProvider>().checkAuth();
    setState(() => _checking = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.eco, size: 64, color: AppTheme.primaryGreen),
              SizedBox(height: 16),
              CircularProgressIndicator(color: AppTheme.primaryGreen),
            ],
          ),
        ),
      );
    }

    final auth = context.watch<AuthProvider>();
    return auth.isAuthenticated ? const HomeScreen() : const LoginScreen();
  }
}