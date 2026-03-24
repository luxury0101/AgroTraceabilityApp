import 'package:agro_traceability/features/eventos/data/dtos/evento_insumo_dto.dart';
import 'package:agro_traceability/features/eventos/domain/entities/evento_insumo.dart';

class CreateEventoRequestDto {
  final String loteId;
  final String eventType;
  final String title;
  final String description;
  final String eventDate;
  final bool isIncident;
  final double? estimatedCost;
  final List<EventoInsumo> insumos;

  const CreateEventoRequestDto({
    required this.loteId,
    required this.eventType,
    required this.title,
    required this.description,
    required this.eventDate,
    required this.isIncident,
    required this.estimatedCost,
    required this.insumos,
  });

  Map<String, dynamic> toJson() {
    return {
      'loteId': loteId,
      'eventType': eventType,
      'title': title,
      'description': description,
      'eventDate': eventDate,
      'isIncident': isIncident,
      'estimatedCost': estimatedCost,
      'insumos': insumos
          .map((e) => EventoInsumoDto.fromEntity(e).toJson())
          .toList(),
    };
  }
}
