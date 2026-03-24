import 'package:agro_traceability/features/insumos/domain/entities/insumo.dart';

class InsumoDto {
  final String id;
  final String nombre;
  final String categoria;
  final String unidadMedida;

  const InsumoDto({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.unidadMedida,
  });

  factory InsumoDto.fromJson(Map<String, dynamic> json) {
    return InsumoDto(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      categoria: json['categoria']?.toString() ?? '',
      unidadMedida: json['unidadMedida']?.toString() ?? '',
    );
  }

  Insumo toEntity() {
    return Insumo(
      id: id,
      nombre: nombre,
      categoria: categoria,
      unidadMedida: unidadMedida,
    );
  }
}
