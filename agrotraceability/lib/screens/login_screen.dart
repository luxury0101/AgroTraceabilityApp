import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../config/theme.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final error = await context.read<AuthProvider>().login(
      _emailCtrl.text.trim(),
      _passwordCtrl.text,
    );
    if (error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppTheme.danger),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 48),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.eco, size: 56, color: AppTheme.primaryGreen),
                ),
                const SizedBox(height: 20),
                Text('AgroTraceability', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 4),
                Text(
                  'Gestión y trazabilidad agrícola',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email o usuario',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Campo obligatorio' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Campo obligatorio' : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: auth.isLoading ? null : _login,
                    child: auth.isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Iniciar Sesión'),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: const [
                        TextSpan(text: '¿No tienes cuenta? '),
                        TextSpan(text: 'Regístrate', style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }
}