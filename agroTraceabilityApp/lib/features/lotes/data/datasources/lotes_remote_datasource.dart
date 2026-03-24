/*import 'package:agro_traceability/core/error/app_exception.dart';
import 'package:agro_traceability/core/error/error_mapper.dart';
import 'package:agro_traceability/core/network/api_client.dart';
import 'package:agro_traceability/core/network/api_endpoints.dart';
import 'package:agro_traceability/features/lotes/data/dtos/lote_detail_dto.dart';
import 'package:agro_traceability/features/lotes/data/dtos/lote_dto.dart';
import 'package:dio/dio.dart';

class LotesRemoteDataSource {
  final ApiClient apiClient;

  LotesRemoteDataSource(this.apiClient);

  Future<List<LoteDto>> getLotes() async {
    try {
      final response = await apiClient.dio.get(ApiEndpoints.lotes);
      final data = response.data;

      if (data is! List) {
        throw const AppException('La respuesta de lotes no es válida.');
      }

      return data
          .map((item) => LoteDto.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ErrorMapper.mapDioError(e);
    } on AppException {
      rethrow;
    } catch (_) {
      throw const UnknownException('Ocurrió un error al consultar los lotes.');
    }
  }

  Future<LoteDetailDto> getLoteDetail(String loteId) async {
    try {
      final response = await apiClient.dio.get('${ApiEndpoints.lotes}/$loteId');
      final data = response.data;

      if (data is! Map<String, dynamic>) {
        throw const AppException(
          'La respuesta del detalle del lote no es válida.',
        );
      }

      return LoteDetailDto.fromJson(data);
    } on DioException catch (e) {
      throw ErrorMapper.mapDioError(e);
    } on AppException {
      rethrow;
    } catch (_) {
      throw const UnknownException(
        'Ocurrió un error al consultar el detalle del lote.',
      );
    }
  }
}*/

import 'package:agro_traceability/features/lotes/data/dtos/lote_detail_dto.dart';
import 'package:agro_traceability/features/lotes/data/dtos/lote_dto.dart';

class LotesRemoteDataSource {
  LotesRemoteDataSource(dynamic _);

  Future<List<LoteDto>> getLotes() async {
    await Future.delayed(const Duration(milliseconds: 700));

    return const [
      LoteDto(
        id: 'lote-1',
        code: 'LOT-001',
        name: 'Lote El Mirador',
        cropType: 'Café',
        producerName: 'Juan Pérez',
        status: 'EN_PRODUCCION',
        areaHectares: 2.5,
        municipality: 'Barbosa',
      ),
      LoteDto(
        id: 'lote-2',
        code: 'LOT-002',
        name: 'Lote La Esperanza',
        cropType: 'Tomate',
        producerName: 'Ana Gómez',
        status: 'SEMBRADO',
        areaHectares: 1.8,
        municipality: 'Barbosa',
      ),
      LoteDto(
        id: 'lote-3',
        code: 'LOT-003',
        name: 'Lote Santa Rosa',
        cropType: 'Maíz',
        producerName: 'Carlos Rueda',
        status: 'PLANIFICADO',
        areaHectares: 3.2,
        municipality: 'Barbosa',
      ),
    ];
  }

  Future<LoteDetailDto> getLoteDetail(String loteId) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final mockMap = <String, LoteDetailDto>{
      'lote-1': const LoteDetailDto(
        id: 'lote-1',
        code: 'LOT-001',
        name: 'Lote El Mirador',
        cropType: 'Café',
        cropVariety: 'Castillo',
        producerName: 'Juan Pérez',
        status: 'EN_PRODUCCION',
        areaHectares: 2.5,
        municipality: 'Barbosa',
        locationDescription: 'Vereda Centro, sector norte',
        expectedSowingDate: '2026-03-01',
        expectedHarvestDate: '2026-08-15',
        observations: 'Lote con buen drenaje y sombra parcial.',
      ),
      'lote-2': const LoteDetailDto(
        id: 'lote-2',
        code: 'LOT-002',
        name: 'Lote La Esperanza',
        cropType: 'Tomate',
        cropVariety: 'Chonto',
        producerName: 'Ana Gómez',
        status: 'SEMBRADO',
        areaHectares: 1.8,
        municipality: 'Barbosa',
        locationDescription: 'Zona oriental de la finca',
        expectedSowingDate: '2026-03-10',
        expectedHarvestDate: '2026-06-30',
        observations: 'Lote en etapa inicial, riego manual.',
      ),
      'lote-3': const LoteDetailDto(
        id: 'lote-3',
        code: 'LOT-003',
        name: 'Lote Santa Rosa',
        cropType: 'Maíz',
        cropVariety: 'Amarillo tradicional',
        producerName: 'Carlos Rueda',
        status: 'PLANIFICADO',
        areaHectares: 3.2,
        municipality: 'Barbosa',
        locationDescription: 'Sector alto de la vereda',
        expectedSowingDate: '2026-04-05',
        expectedHarvestDate: '2026-09-20',
        observations: 'Pendiente preparación del terreno.',
      ),
    };

    return mockMap[loteId] ??
        const LoteDetailDto(
          id: 'unknown',
          code: 'LOT-000',
          name: 'Lote no encontrado',
          cropType: 'N/A',
          cropVariety: null,
          producerName: 'N/A',
          status: 'SUSPENDIDO',
          areaHectares: 0,
          municipality: 'Barbosa',
          locationDescription: null,
          expectedSowingDate: null,
          expectedHarvestDate: null,
          observations: 'No existe información.',
        );
  }
}
