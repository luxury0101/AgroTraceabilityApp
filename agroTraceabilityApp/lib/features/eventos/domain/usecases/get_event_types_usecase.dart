import 'package:agro_traceability/features/eventos/domain/entities/event_type.dart';
import 'package:agro_traceability/features/eventos/domain/repositories/eventos_repository.dart';

class GetEventTypesUseCase {
  final EventosRepository repository;

  GetEventTypesUseCase(this.repository);

  Future<List<EventType>> call() {
    return repository.getEventTypes();
  }
}
