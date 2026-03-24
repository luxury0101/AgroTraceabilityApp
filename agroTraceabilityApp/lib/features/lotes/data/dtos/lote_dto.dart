import 'package:agro_traceability/features/lotes/domain/entities/lote.dart';

class LoteDto {
  final String id;
  final String code;
  final String name;
  final String cropType;
  final String producerName;
  final String status;
  final double areaHectares;
  final String municipality;

  const LoteDto({
    required this.id,
    required this.code,
    required this.name,
    required this.cropType,
    required this.producerName,
    required this.status,
    required this.areaHectares,
    required this.municipality,
  });

  factory LoteDto.fromJson(Map<String, dynamic> json) {
    return LoteDto(
      id: json['id']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      cropType: json['cropType']?.toString() ?? '',
      producerName: json['producerName']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      areaHectares: (json['areaHectares'] as num?)?.toDouble() ?? 0,
      municipality: json['municipality']?.toString() ?? '',
    );
  }

  Lote toEntity() {
    return Lote(
      id: id,
      code: code,
      name: name,
      cropType: cropType,
      producerName: producerName,
      status: status,
      areaHectares: areaHectares,
      municipality: municipality,
    );
  }
}
