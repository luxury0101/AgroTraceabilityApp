import 'package:agro_traceability/features/eventos/domain/entities/evento.dart';
import 'package:agro_traceability/features/eventos/domain/repositories/eventos_repository.dart';

class GetEventosByLoteUseCase {
  final EventosRepository repository;

  GetEventosByLoteUseCase(this.repository);

  Future<List<Evento>> call(String loteId) {
    return repository.getEventosByLote(loteId);
  }
}
