import 'package:agro_traceability/features/trazabilidad/data/datasources/trazabilidad_remote_datasource.dart';
import 'package:agro_traceability/features/trazabilidad/domain/entities/trazabilidad_item.dart';
import 'package:agro_traceability/features/trazabilidad/domain/repositories/trazabilidad_repository.dart';

class TrazabilidadRepositoryImpl implements TrazabilidadRepository {
  final TrazabilidadRemoteDataSource remoteDataSource;

  TrazabilidadRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<TrazabilidadItem>> getByLote(String loteId) async {
    final dtos = await remoteDataSource.getByLote(loteId);
    return dtos.map((e) => e.toEntity()).toList();
  }
}
