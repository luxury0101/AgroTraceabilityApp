import 'package:agro_traceability/features/insumos/domain/entities/insumo.dart';
import 'package:agro_traceability/features/insumos/domain/repositories/insumos_repository.dart';

class GetInsumosUseCase {
  final InsumosRepository repository;

  GetInsumosUseCase(this.repository);

  Future<List<Insumo>> call() {
    return repository.getInsumos();
  }
}
