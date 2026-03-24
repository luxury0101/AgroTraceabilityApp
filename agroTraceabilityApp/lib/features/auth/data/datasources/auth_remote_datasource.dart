import 'package:agro_traceability/core/error/app_exception.dart';
import 'package:agro_traceability/features/auth/data/dtos/login_request_dto.dart';
import 'package:agro_traceability/features/auth/data/dtos/login_response_dto.dart';
import 'package:agro_traceability/features/auth/data/dtos/user_dto.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(dynamic _);

  Future<LoginResponseDto> login(LoginRequestDto request) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final email = request.email.trim().toLowerCase();
    final password = request.password.trim();

    if (email == 'admin@agro.com' && password == '123456') {
      return LoginResponseDto(
        token: 'mock-jwt-admin-token',
        user: const UserDto(
          id: '1',
          fullName: 'Stiven Admin',
          email: 'admin@agro.com',
          role: 'ADMIN',
        ),
      );
    }

    if (email == 'operario@agro.com' && password == '123456') {
      return LoginResponseDto(
        token: 'mock-jwt-operario-token',
        user: const UserDto(
          id: '2',
          fullName: 'Operario Campo',
          email: 'operario@agro.com',
          role: 'OPERARIO',
        ),
      );
    }

    throw const UnauthorizedException('Credenciales inválidas');
  }
}
