import 'package:agro_traceability/core/constants/app_strings.dart';
import 'package:agro_traceability/core/utils/validators.dart';
import 'package:agro_traceability/core/widgets/app_button.dart';
import 'package:agro_traceability/core/widgets/app_text_field.dart';
import 'package:agro_traceability/features/auth/presentation/providers/auth_provider.dart';
import 'package:agro_traceability/features/auth/presentation/providers/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit(AuthState authState) async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(authProvider.notifier)
        .login(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppTextField(
            controller: _emailController,
            label: AppStrings.emailLabel,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _passwordController,
            label: AppStrings.passwordLabel,
            obscureText: true,
            validator: Validators.validatePassword,
          ),
          const SizedBox(height: 20),
          if (authState.errorMessage != null) ...[
            Text(
              authState.errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 12),
          ],
          AppButton(
            text: AppStrings.loginButton,
            isLoading: authState.isLoading,
            onPressed: () => _submit(authState),
          ),
        ],
      ),
    );
  }
}
