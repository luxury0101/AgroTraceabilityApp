import 'package:agro_traceability/features/trazabilidad/domain/entities/trazabilidad_item.dart';
import 'package:agro_traceability/features/trazabilidad/domain/repositories/trazabilidad_repository.dart';

class GetTrazabilidadByLoteUseCase {
  final TrazabilidadRepository repository;

  GetTrazabilidadByLoteUseCase(this.repository);

  Future<List<TrazabilidadItem>> call(String loteId) {
    return repository.getByLote(loteId);
  }
}
