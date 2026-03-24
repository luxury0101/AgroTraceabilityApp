import 'package:agro_traceability/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:agro_traceability/features/auth/data/dtos/login_request_dto.dart';
import 'package:agro_traceability/features/auth/domain/entities/user.dart';
import 'package:agro_traceability/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<(String token, User user)> login({
    required String email,
    required String password,
  }) async {
    final response = await remoteDataSource.login(
      LoginRequestDto(email: email, password: password),
    );

    return (response.token, response.user.toEntity());
  }
}
