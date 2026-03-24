class EventoInsumo {
  final String? insumoId;
  final String nombre;
  final double quantity;
  final String unitOfMeasure;
  final String? applicationMethod;
  final String? observations;

  const EventoInsumo({
    required this.insumoId,
    required this.nombre,
    required this.quantity,
    required this.unitOfMeasure,
    required this.applicationMethod,
    required this.observations,
  });
}
