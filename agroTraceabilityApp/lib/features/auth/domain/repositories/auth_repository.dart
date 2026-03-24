import 'package:agro_traceability/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<(String token, User user)> login({
    required String email,
    required String password,
  });
}
