import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../config/theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _apellidoCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _documentoCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _municipioCtrl = TextEditingController(text: 'Barbosa');
  bool _obscure = true;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    final error = await context.read<AuthProvider>().register(
      nombre: _nombreCtrl.text.trim(),
      apellido: _apellidoCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      username: _usernameCtrl.text.trim(),
      password: _passwordCtrl.text,
      documento: _documentoCtrl.text.trim(),
      telefono: _telefonoCtrl.text.trim(),
      municipio: _municipioCtrl.text.trim(),
    );
    if (mounted) {
      if (error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro exitoso. Ahora inicia sesión.'), backgroundColor: AppTheme.primaryGreen),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: AppTheme.danger),
        );
      }
    }
  }

  Widget _field(TextEditingController ctrl, String label, IconData icon, {TextInputType? type, bool required = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: ctrl,
        keyboardType: type,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
        validator: required ? (v) => v == null || v.isEmpty ? 'Campo obligatorio' : null : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Productor')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Text('Datos personales', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              _field(_nombreCtrl, 'Nombre', Icons.person_outline),
              _field(_apellidoCtrl, 'Apellido', Icons.person_outline),
              _field(_documentoCtrl, 'Documento de identidad', Icons.badge_outlined, type: TextInputType.number),
              _field(_telefonoCtrl, 'Teléfono', Icons.phone_outlined, type: TextInputType.phone, required: false),
              _field(_municipioCtrl, 'Municipio', Icons.location_on_outlined, required: false),
              const SizedBox(height: 8),
              Text('Datos de acceso', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              _field(_emailCtrl, 'Email', Icons.email_outlined, type: TextInputType.emailAddress),
              _field(_usernameCtrl, 'Usuario', Icons.alternate_email),
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: TextFormField(
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
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Campo obligatorio';
                    if (v.length < 6) return 'Mínimo 6 caracteres';
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: auth.isLoading ? null : _register,
                  child: auth.isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Registrarme'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nombreCtrl.dispose(); _apellidoCtrl.dispose(); _emailCtrl.dispose();
    _usernameCtrl.dispose(); _passwordCtrl.dispose(); _documentoCtrl.dispose();
    _telefonoCtrl.dispose(); _municipioCtrl.dispose();
    super.dispose();
  }
}