// test/unit/api_service_test.dart
// Pruebas unitarias del ApiService
// Estas pruebas NO hacen requests reales — usan mocks

import 'package:flutter_test/flutter_test.dart';

// ⚠️ Ajusta el import según tu paquete real
import 'package:agrotraceability/services/api_service.dart';

void main() {

  // ─────────────────────────────────────────────
  // SUITE: ApiException
  // ─────────────────────────────────────────────
  group('ApiException', () {

    test('✅ Crea excepción con statusCode y message', () {
      final ex = ApiException(statusCode: 404, message: 'No encontrado');

      expect(ex.statusCode, 404);
      expect(ex.message, 'No encontrado');
    });

    test('✅ toString() retorna el mensaje', () {
      final ex = ApiException(statusCode: 401, message: 'No autorizado');

      expect(ex.toString(), 'No autorizado');
    });

    test('✅ Diferentes códigos HTTP son distintos', () {
      final ex401 = ApiException(statusCode: 401, message: 'Unauthorized');
      final ex404 = ApiException(statusCode: 404, message: 'Not Found');
      final ex500 = ApiException(statusCode: 500, message: 'Server Error');

      expect(ex401.statusCode, isNot(ex404.statusCode));
      expect(ex404.statusCode, isNot(ex500.statusCode));
    });

  });

  // ─────────────────────────────────────────────
  // SUITE: baseUrl validación
  // ─────────────────────────────────────────────
  group('ApiService - configuración', () {

    test('✅ baseUrl no está vacío', () {
      expect(ApiService.baseUrl, isNotEmpty);
    });

    test('✅ baseUrl empieza con http', () {
      expect(ApiService.baseUrl, startsWith('http'));
    });

    test('✅ baseUrl termina con /api', () {
      expect(ApiService.baseUrl, endsWith('/api'));
    });

  });

}