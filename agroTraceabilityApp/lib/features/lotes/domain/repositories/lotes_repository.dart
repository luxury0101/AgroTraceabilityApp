import 'package:agro_traceability/features/lotes/domain/entities/lote.dart';
import 'package:agro_traceability/features/lotes/domain/entities/lote_detail.dart';

abstract class LotesRepository {
  Future<List<Lote>> getLotes();
  Future<LoteDetail> getLoteDetail(String loteId);
}
