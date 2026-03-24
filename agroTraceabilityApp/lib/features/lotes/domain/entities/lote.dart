class Lote {
  final String id;
  final String code;
  final String name;
  final String cropType;
  final String producerName;
  final String status;
  final double areaHectares;
  final String municipality;

  const Lote({
    required this.id,
    required this.code,
    required this.name,
    required this.cropType,
    required this.producerName,
    required this.status,
    required this.areaHectares,
    required this.municipality,
  });
}
