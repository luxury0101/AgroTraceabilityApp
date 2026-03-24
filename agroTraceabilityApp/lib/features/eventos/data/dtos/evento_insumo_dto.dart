import 'package:agro_traceability/features/eventos/domain/entities/evento_insumo.dart';

class EventoInsumoDto {
  final String? insumoId;
  final String nombre;
  final double quantity;
  final String unitOfMeasure;
  final String? applicationMethod;
  final String? observations;

  const EventoInsumoDto({
    required this.insumoId,
    required this.nombre,
    required this.quantity,
    required this.unitOfMeasure,
    required this.applicationMethod,
    required this.observations,
  });

  factory EventoInsumoDto.fromJson(Map<String, dynamic> json) {
    return EventoInsumoDto(
      insumoId: json['insumoId']?.toString(),
      nombre: json['nombre']?.toString() ?? '',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0,
      unitOfMeasure: json['unitOfMeasure']?.toString() ?? '',
      applicationMethod: json['applicationMethod']?.toString(),
      observations: json['observations']?.toString(),
    );
  }

  factory EventoInsumoDto.fromEntity(EventoInsumo entity) {
    return EventoInsumoDto(
      insumoId: entity.insumoId,
      nombre: entity.nombre,
      quantity: entity.quantity,
      unitOfMeasure: entity.unitOfMeasure,
      applicationMethod: entity.applicationMethod,
      observations: entity.observations,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'insumoId': insumoId,
      'nombre': nombre,
      'quantity': quantity,
      'unitOfMeasure': unitOfMeasure,
      'applicationMethod': applicationMethod,
      'observations': observations,
    };
  }

  EventoInsumo toEntity() {
    return EventoInsumo(
      insumoId: insumoId,
      nombre: nombre,
      quantity: quantity,
      unitOfMeasure: unitOfMeasure,
      applicationMethod: applicationMethod,
      observations: observations,
    );
  }
}
