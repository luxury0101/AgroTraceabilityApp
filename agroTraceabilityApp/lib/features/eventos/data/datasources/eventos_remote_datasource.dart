/*import 'package:agro_traceability/core/error/app_exception.dart';
import 'package:agro_traceability/core/error/error_mapper.dart';
import 'package:agro_traceability/core/network/api_client.dart';
import 'package:agro_traceability/core/network/api_endpoints.dart';
import 'package:agro_traceability/features/eventos/data/dtos/create_evento_request_dto.dart';
import 'package:agro_traceability/features/eventos/data/dtos/evento_dto.dart';
import 'package:agro_traceability/features/eventos/domain/entities/event_type.dart';
import 'package:dio/dio.dart';

class EventosRemoteDataSource {
  final ApiClient apiClient;

  EventosRemoteDataSource(this.apiClient);

  Future<List<EventoDto>> getEventosByLote(String loteId) async {
    try {
      final response = await apiClient.dio.get(
        ApiEndpoints.eventosByLote(loteId),
      );
      final data = response.data;

      if (data is! List) {
        throw const AppException('La respuesta de eventos no es válida.');
      }

      return data
          .map((e) => EventoDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ErrorMapper.mapDioError(e);
    } on AppException {
      rethrow;
    } catch (_) {
      throw const UnknownException(
        'Ocurrió un error al consultar los eventos.',
      );
    }
  }

  Future<void> createEvento(CreateEventoRequestDto request) async {
    try {
      await apiClient.dio.post(ApiEndpoints.eventos, data: request.toJson());
    } on DioException catch (e) {
      throw ErrorMapper.mapDioError(e);
    } on AppException {
      rethrow;
    } catch (_) {
      throw const UnknownException('Ocurrió un error al registrar el evento.');
    }
  }

  Future<List<EventType>> getEventTypes() async {
    return const [
      EventType(code: 'SIEMBRA', name: 'Siembra'),
      EventType(code: 'RIEGO', name: 'Riego'),
      EventType(code: 'FERTILIZACION', name: 'Fertilización'),
      EventType(code: 'APLICACION_INSUMO', name: 'Aplicación de insumo'),
      EventType(code: 'CONTROL_PLAGAS', name: 'Control de plagas'),
      EventType(code: 'PODA', name: 'Poda'),
      EventType(code: 'COSECHA', name: 'Cosecha'),
      EventType(code: 'INCIDENCIA', name: 'Incidencia'),
      EventType(code: 'INSPECCION', name: 'Inspección'),
      EventType(code: 'OTRO', name: 'Otro'),
    ];
  }
}*/
import 'package:agro_traceability/features/eventos/data/dtos/create_evento_request_dto.dart';
import 'package:agro_traceability/features/eventos/data/dtos/evento_dto.dart';
import 'package:agro_traceability/features/eventos/data/dtos/evento_insumo_dto.dart';
import 'package:agro_traceability/features/eventos/domain/entities/event_type.dart';

class EventosRemoteDataSource {
  EventosRemoteDataSource(dynamic _);

  Future<List<EventoDto>> getEventosByLote(String loteId) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final mockEventos = <String, List<EventoDto>>{
      'lote-1': const [
        EventoDto(
          id: 'ev-1',
          loteId: 'lote-1',
          eventType: 'SIEMBRA',
          title: 'Siembra inicial',
          description: 'Se realizó la siembra inicial del lote.',
          eventDate: '2026-03-20',
          recordedBy: 'Operario Campo',
          isIncident: false,
          estimatedCost: 120000,
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
        EventoDto(
          id: 'ev-2',
          loteId: 'lote-1',
          eventType: 'RIEGO',
          title: 'Riego de establecimiento',
          description: 'Riego manual realizado en horas de la mañana.',
          eventDate: '2026-03-23',
          recordedBy: 'Operario Campo',
          isIncident: false,
          estimatedCost: 25000,
          insumos: [],
        ),
        EventoDto(
          id: 'ev-3',
          loteId: 'lote-1',
          eventType: 'FERTILIZACION',
          title: 'Fertilización etapa 1',
          description: 'Aplicación inicial de fertilizante NPK.',
          eventDate: '2026-03-27',
          recordedBy: 'Stiven Admin',
          isIncident: false,
          estimatedCost: 85000,
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
        EventoDto(
          id: 'ev-4',
          loteId: 'lote-2',
          eventType: 'SIEMBRA',
          title: 'Transplante de tomate',
          description: 'Se trasplantaron plántulas al lote.',
          eventDate: '2026-03-18',
          recordedBy: 'Operario Campo',
          isIncident: false,
          estimatedCost: 98000,
          insumos: [],
        ),
        EventoDto(
          id: 'ev-5',
          loteId: 'lote-2',
          eventType: 'INCIDENCIA',
          title: 'Afectación por lluvia',
          description: 'Se identificó exceso de humedad en un sector.',
          eventDate: '2026-03-22',
          recordedBy: 'Ana Gómez',
          isIncident: true,
          estimatedCost: null,
          insumos: [],
        ),
      ],
      'lote-3': const [],
    };

    return mockEventos[loteId] ?? const [];
  }

  Future<void> createEvento(CreateEventoRequestDto request) async {
    await Future.delayed(const Duration(milliseconds: 900));
  }

  Future<List<EventType>> getEventTypes() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return const [
      EventType(code: 'SIEMBRA', name: 'Siembra'),
      EventType(code: 'RIEGO', name: 'Riego'),
      EventType(code: 'FERTILIZACION', name: 'Fertilización'),
      EventType(code: 'APLICACION_INSUMO', name: 'Aplicación de insumo'),
      EventType(code: 'CONTROL_PLAGAS', name: 'Control de plagas'),
      EventType(code: 'PODA', name: 'Poda'),
      EventType(code: 'COSECHA', name: 'Cosecha'),
      EventType(code: 'INCIDENCIA', name: 'Incidencia'),
      EventType(code: 'INSPECCION', name: 'Inspección'),
      EventType(code: 'OTRO', name: 'Otro'),
    ];
  }
}
