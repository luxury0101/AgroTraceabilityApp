import 'package:agro_traceability/features/eventos/domain/entities/evento_insumo.dart';

class TrazabilidadItem {
  final String id;
  final String eventDate;
  final String eventType;
  final String title;
  final String description;
  final String recordedBy;
  final bool isIncident;
  final List<EventoInsumo> insumos;

  const TrazabilidadItem({
    required this.id,
    required this.eventDate,
    required this.eventType,
    required this.title,
    required this.description,
    required this.recordedBy,
    required this.isIncident,
    required this.insumos,
  });
}
