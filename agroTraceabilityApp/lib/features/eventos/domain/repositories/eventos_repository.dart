import 'package:agro_traceability/features/eventos/domain/entities/event_type.dart';
import 'package:agro_traceability/features/eventos/domain/entities/evento.dart';
import 'package:agro_traceability/features/eventos/domain/entities/evento_insumo.dart';

abstract class EventosRepository {
  Future<List<Evento>> getEventosByLote(String loteId);

  Future<void> createEvento({
    required String loteId,
    required String eventType,
    required String title,
    required String description,
    required String eventDate,
    required bool isIncident,
    required double? estimatedCost,
    required List<EventoInsumo> insumos,
  });

  Future<List<EventType>> getEventTypes();
}
