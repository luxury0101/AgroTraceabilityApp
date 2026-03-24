import 'package:agro_traceability/features/lotes/data/datasources/lotes_remote_datasource.dart';
import 'package:agro_traceability/features/lotes/domain/entities/lote.dart';
import 'package:agro_traceability/features/lotes/domain/entities/lote_detail.dart';
import 'package:agro_traceability/features/lotes/domain/repositories/lotes_repository.dart';

class LotesRepositoryImpl implements LotesRepository {
  final LotesRemoteDataSource remoteDataSource;

  LotesRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Lote>> getLotes() async {
    final dtos = await remoteDataSource.getLotes();
    return dtos.map((e) => e.toEntity()).toList();
  }

  @override
  Future<LoteDetail> getLoteDetail(String loteId) async {
    final dto = await remoteDataSource.getLoteDetail(loteId);
    return dto.toEntity();
  }
}
