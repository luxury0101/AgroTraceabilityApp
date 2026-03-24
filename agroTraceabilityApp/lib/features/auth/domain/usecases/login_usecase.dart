import 'package:agro_traceability/features/auth/domain/entities/user.dart';
import 'package:agro_traceability/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<(String token, User user)> call({
    required String email,
    required String password,
  }) {
    return repository.login(email: email, password: password);
  }
}
