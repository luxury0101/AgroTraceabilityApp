/*import 'package:agro_traceability/core/error/app_exception.dart';
import 'package:agro_traceability/core/error/error_mapper.dart';
import 'package:agro_traceability/core/network/api_client.dart';
import 'package:agro_traceability/core/network/api_endpoints.dart';
import 'package:agro_traceability/features/trazabilidad/data/dtos/trazabilidad_item_dto.dart';
import 'package:dio/dio.dart';

class TrazabilidadRemoteDataSource {
  final ApiClient apiClient;

  TrazabilidadRemoteDataSource(this.apiClient);

  Future<List<TrazabilidadItemDto>> getByLote(String loteId) async {
    try {
      final response = await apiClient.dio.get(
        ApiEndpoints.trazabilidadByLote(loteId),
      );

      final data = response.data;

      if (data is! List) {
        throw const AppException('La respuesta de trazabilidad no es válida.');
      }

      return data
          .map((e) => TrazabilidadItemDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ErrorMapper.mapDioError(e);
    } on AppException {
      rethrow;
    } catch (_) {
      throw const UnknownException(
        'Ocurrió un error al consultar la trazabilidad.',
      );
    }
  }
}*/

import 'package:agro_traceability/features/eventos/data/dtos/evento_insumo_dto.dart';
import 'package:agro_traceability/features/trazabilidad/data/dtos/trazabilidad_item_dto.dart';

class TrazabilidadRemoteDataSource {
  TrazabilidadRemoteDataSource(dynamic _);

  Future<List<TrazabilidadItemDto>> getByLote(String loteId) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final mockData = <String, List<TrazabilidadItemDto>>{
      'lote-1': const [
        TrazabilidadItemDto(
          id: 'tr-1',
          eventDate: '2026-03-20',
          eventType: 'SIEMBRA',
          title: 'Siembra inicial',
          description: 'Registro inicial del lote con semilla certificada.',
          recordedBy: 'Operario Campo',
          isIncident: false,
          insumos: [
            EventoInsumoDto(
              insumoId: 'ins-2',
              nombre: 'Semilla Castillo',
              quantity: 10,
              unitOfMeasure: 'kg',
              applicationMethod: 'Manual',
              observations: 'Distribución uniforme',
            ),
          ],
        ),
        TrazabilidadItemDto(
          id: 'tr-2',
          eventDate: '2026-03-23',
          eventType: 'RIEGO',
          title: 'Riego de establecimiento',
          description: 'Riego posterior a la siembra.',
          recordedBy: 'Operario Campo',
          isIncident: false,
          insumos: [],
        ),
        TrazabilidadItemDto(
          id: 'tr-3',
          eventDate: '2026-03-27',
          eventType: 'FERTILIZACION',
          title: 'Fertilización etapa 1',
          description: 'Aplicación inicial de fertilizante.',
          recordedBy: 'Stiven Admin',
          isIncident: false,
          insumos: [
            EventoInsumoDto(
              insumoId: 'ins-1',
              nombre: 'Fertilizante NPK',
              quantity: 3,
              unitOfMeasure: 'kg',
              applicationMethod: 'Manual',
              observations: 'Aplicado en zona central',
            ),
          ],
        ),
      ],
      'lote-2': const [
        TrazabilidadItemDto(
          id: 'tr-4',
          eventDate: '2026-03-18',
          eventType: 'SIEMBRA',
          title: 'Transplante de tomate',
          description: 'Se trasplantaron plántulas al lote.',
          recordedBy: 'Operario Campo',
          isIncident: false,
          insumos: [],
        ),
        TrazabilidadItemDto(
          id: 'tr-5',
          eventDate: '2026-03-22',
          eventType: 'INCIDENCIA',
          title: 'Afectación por lluvia',
          description: 'Exceso de humedad en un sector del lote.',
          recordedBy: 'Ana Gómez',
          isIncident: true,
          insumos: [],
        ),
      ],
      'lote-3': const [],
    };

    return mockData[loteId] ?? const [];
  }
}
