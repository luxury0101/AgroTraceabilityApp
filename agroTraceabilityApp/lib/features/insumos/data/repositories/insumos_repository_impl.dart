import 'package:agro_traceability/features/insumos/data/datasources/insumos_remote_datasource.dart';
import 'package:agro_traceability/features/insumos/domain/entities/insumo.dart';
import 'package:agro_traceability/features/insumos/domain/repositories/insumos_repository.dart';

class InsumosRepositoryImpl implements InsumosRepository {
  final InsumosRemoteDataSource remoteDataSource;

  InsumosRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Insumo>> getInsumos() async {
    final dtos = await remoteDataSource.getInsumos();
    return dtos.map((e) => e.toEntity()).toList();
  }
}
