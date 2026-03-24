import 'package:agro_traceability/features/lotes/domain/entities/lote_detail.dart';
import 'package:agro_traceability/features/lotes/domain/repositories/lotes_repository.dart';

class GetLoteDetailUseCase {
  final LotesRepository repository;

  GetLoteDetailUseCase(this.repository);

  Future<LoteDetail> call(String loteId) {
    return repository.getLoteDetail(loteId);
  }
}
