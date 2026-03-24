import 'package:agro_traceability/core/storage/secure_storage_service.dart';
import 'package:agro_traceability/features/auth/domain/entities/user.dart';

class RestoreSessionUseCase {
  final SecureStorageService secureStorageService;

  RestoreSessionUseCase(this.secureStorageService);

  Future<(String token, User user)?> call() async {
    final token = await secureStorageService.getToken();
    final userJson = await secureStorageService.getUser();

    if (token == null || token.isEmpty || userJson == null) {
      return null;
    }

    final user = User(
      id: userJson['id']?.toString() ?? '',
      fullName: userJson['fullName']?.toString() ?? '',
      email: userJson['email']?.toString() ?? '',
      role: userJson['role']?.toString() ?? '',
    );

    return (token, user);
  }
}
