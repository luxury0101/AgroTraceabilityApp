import 'package:agro_traceability/features/insumos/domain/entities/insumo.dart';

abstract class InsumosRepository {
  Future<List<Insumo>> getInsumos();
}
