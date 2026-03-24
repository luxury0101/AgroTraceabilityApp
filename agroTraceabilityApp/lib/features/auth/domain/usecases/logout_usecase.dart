import 'package:agro_traceability/core/storage/secure_storage_service.dart';

class LogoutUseCase {
  final SecureStorageService secureStorageService;

  LogoutUseCase(this.secureStorageService);

  Future<void> call() async {
    await secureStorageService.clearSession();
  }
}
