import 'package:agro_traceability/features/lotes/domain/entities/lote_detail.dart';

class LoteDetailDto {
  final String id;
  final String code;
  final String name;
  final String cropType;
  final String? cropVariety;
  final String producerName;
  final String status;
  final double areaHectares;
  final String municipality;
  final String? locationDescription;
  final String? expectedSowingDate;
  final String? expectedHarvestDate;
  final String? observations;

  const LoteDetailDto({
    required this.id,
    required this.code,
    required this.name,
    required this.cropType,
    required this.cropVariety,
    required this.producerName,
    required this.status,
    required this.areaHectares,
    required this.municipality,
    required this.locationDescription,
    required this.expectedSowingDate,
    required this.expectedHarvestDate,
    required this.observations,
  });

  factory LoteDetailDto.fromJson(Map<String, dynamic> json) {
    return LoteDetailDto(
      id: json['id']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      cropType: json['cropType']?.toString() ?? '',
      cropVariety: json['cropVariety']?.toString(),
      producerName: json['producerName']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      areaHectares: (json['areaHectares'] as num?)?.toDouble() ?? 0,
      municipality: json['municipality']?.toString() ?? '',
      locationDescription: json['locationDescription']?.toString(),
      expectedSowingDate: json['expectedSowingDate']?.toString(),
      expectedHarvestDate: json['expectedHarvestDate']?.toString(),
      observations: json['observations']?.toString(),
    );
  }

  LoteDetail toEntity() {
    return LoteDetail(
      id: id,
      code: code,
      name: name,
      cropType: cropType,
      cropVariety: cropVariety,
      producerName: producerName,
      status: status,
      areaHectares: areaHectares,
      municipality: municipality,
      locationDescription: locationDescription,
      expectedSowingDate: expectedSowingDate,
      expectedHarvestDate: expectedHarvestDate,
      observations: observations,
    );
  }
}
