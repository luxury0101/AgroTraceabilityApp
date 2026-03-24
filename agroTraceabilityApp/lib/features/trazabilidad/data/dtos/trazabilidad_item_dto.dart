import 'package:agro_traceability/features/eventos/data/dtos/evento_insumo_dto.dart';
import 'package:agro_traceability/features/trazabilidad/domain/entities/trazabilidad_item.dart';

class TrazabilidadItemDto {
  final String id;
  final String eventDate;
  final String eventType;
  final String title;
  final String description;
  final String recordedBy;
  final bool isIncident;
  final List<EventoInsumoDto> insumos;

  const TrazabilidadItemDto({
    required this.id,
    required this.eventDate,
    required this.eventType,
    required this.title,
    required this.description,
    required this.recordedBy,
    required this.isIncident,
    required this.insumos,
  });

  factory TrazabilidadItemDto.fromJson(Map<String, dynamic> json) {
    final rawInsumos = json['insumos'];

    return TrazabilidadItemDto(
      id: json['id']?.toString() ?? '',
      eventDate: json['eventDate']?.toString() ?? '',
      eventType: json['eventType']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      recordedBy: json['recordedBy']?.toString() ?? '',
      isIncident: json['isIncident'] as bool? ?? false,
      insumos: rawInsumos is List
          ? rawInsumos
                .map((e) => EventoInsumoDto.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
    );
  }

  TrazabilidadItem toEntity() {
    return TrazabilidadItem(
      id: id,
      eventDate: eventDate,
      eventType: eventType,
      title: title,
      description: description,
      recordedBy: recordedBy,
      isIncident: isIncident,
      insumos: insumos.map((e) => e.toEntity()).toList(),
    );
  }
}
