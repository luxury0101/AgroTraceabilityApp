import 'package:agro_traceability/features/eventos/data/datasources/eventos_remote_datasource.dart';
import 'package:agro_traceability/features/eventos/data/dtos/create_evento_request_dto.dart';
import 'package:agro_traceability/features/eventos/domain/entities/event_type.dart';
import 'package:agro_traceability/features/eventos/domain/entities/evento.dart';
import 'package:agro_traceability/features/eventos/domain/entities/evento_insumo.dart';
import 'package:agro_traceability/features/eventos/domain/repositories/eventos_repository.dart';

class EventosRepositoryImpl implements EventosRepository {
  final EventosRemoteDataSource remoteDataSource;

  EventosRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Evento>> getEventosByLote(String loteId) async {
    final dtos = await remoteDataSource.getEventosByLote(loteId);
    return dtos.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> createEvento({
    required String loteId,
    required String eventType,
    required String title,
    required String description,
    required String eventDate,
    required bool isIncident,
    required double? estimatedCost,
    required List<EventoInsumo> insumos,
  }) {
    return remoteDataSource.createEvento(
      CreateEventoRequestDto(
        loteId: loteId,
        eventType: eventType,
        title: title,
        description: description,
        eventDate: eventDate,
        isIncident: isIncident,
        estimatedCost: estimatedCost,
        insumos: insumos,
      ),
    );
  }

  @override
  Future<List<EventType>> getEventTypes() {
    return remoteDataSource.getEventTypes();
  }
}
