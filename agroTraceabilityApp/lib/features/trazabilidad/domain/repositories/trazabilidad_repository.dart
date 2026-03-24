import 'package:agro_traceability/features/trazabilidad/domain/entities/trazabilidad_item.dart';

abstract class TrazabilidadRepository {
  Future<List<TrazabilidadItem>> getByLote(String loteId);
}
