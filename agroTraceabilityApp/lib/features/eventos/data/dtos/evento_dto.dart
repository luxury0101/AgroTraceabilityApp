import 'package:agro_traceability/features/eventos/data/dtos/evento_insumo_dto.dart';
import 'package:agro_traceability/features/eventos/domain/entities/evento.dart';

class EventoDto {
  final String id;
  final String loteId;
  final String eventType;
  final String title;
  final String description;
  final String eventDate;
  final String recordedBy;
  final bool isIncident;
  final double? estimatedCost;
  final List<EventoInsumoDto> insumos;

  const EventoDto({
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

  factory EventoDto.fromJson(Map<String, dynamic> json) {
    final rawInsumos = json['insumos'];

    return EventoDto(
      id: json['id']?.toString() ?? '',
      loteId: json['loteId']?.toString() ?? '',
      eventType: json['eventType']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      eventDate: json['eventDate']?.toString() ?? '',
      recordedBy: json['recordedBy']?.toString() ?? '',
      isIncident: json['isIncident'] as bool? ?? false,
      estimatedCost: (json['estimatedCost'] as num?)?.toDouble(),
      insumos: rawInsumos is List
          ? rawInsumos
                .map((e) => EventoInsumoDto.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
    );
  }

  Evento toEntity() {
    return Evento(
      id: id,
      loteId: loteId,
      eventType: eventType,
      title: title,
      description: description,
      eventDate: eventDate,
      recordedBy: recordedBy,
      isIncident: isIncident,
      estimatedCost: estimatedCost,
      insumos: insumos.map((e) => e.toEntity()).toList(),
    );
  }
}
