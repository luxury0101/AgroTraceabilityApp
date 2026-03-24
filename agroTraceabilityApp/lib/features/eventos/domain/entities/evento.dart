import 'package:agro_traceability/features/eventos/domain/entities/evento_insumo.dart';

class Evento {
  final String id;
  final String loteId;
  final String eventType;
  final String title;
  final String description;
  final String eventDate;
  final String recordedBy;
  final bool isIncident;
  final double? estimatedCost;
  final List<EventoInsumo> insumos;

  const Evento({
    required this.id,
    required this.loteId,
    required this.eventType,
    required this.title,
    required this.description,
    required this.eventDate,
    required this.recordedBy,
    required this.isIncident,
    required this.estimatedCost,
    required this.insumos,
  });
}
