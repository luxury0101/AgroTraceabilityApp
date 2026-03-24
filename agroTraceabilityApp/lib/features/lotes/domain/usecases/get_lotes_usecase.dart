import 'package:agro_traceability/features/lotes/domain/entities/lote.dart';
import 'package:agro_traceability/features/lotes/domain/repositories/lotes_repository.dart';

class GetLotesUseCase {
  final LotesRepository repository;

  GetLotesUseCase(this.repository);

  Future<List<Lote>> call() {
    return repository.getLotes();
  }
}
