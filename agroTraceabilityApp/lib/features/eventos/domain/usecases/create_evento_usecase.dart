import 'package:agro_traceability/features/eventos/domain/entities/evento_insumo.dart';
import 'package:agro_traceability/features/eventos/domain/repositories/eventos_repository.dart';

class CreateEventoUseCase {
  final EventosRepository repository;

  CreateEventoUseCase(this.repository);

  Future<void> call({
    required String loteId,
    required String eventType,
    required String title,
    required String description,
    required String eventDate,
    required bool isIncident,
    required double? estimatedCost,
    required List<EventoInsumo> insumos,
  }) {
    return repository.createEvento(
      loteId: loteId,
      eventType: eventType,
      title: title,
      description: description,
      eventDate: eventDate,
      isIncident: isIncident,
      estimatedCost: estimatedCost,
      insumos: insumos,
    );
  }
}
