class LoteDetail {
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

  const LoteDetail({
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
}
