/*import 'package:agro_traceability/core/error/app_exception.dart';
import 'package:agro_traceability/core/error/error_mapper.dart';
import 'package:agro_traceability/core/network/api_client.dart';
import 'package:agro_traceability/core/network/api_endpoints.dart';
import 'package:agro_traceability/features/insumos/data/dtos/insumo_dto.dart';
import 'package:dio/dio.dart';

class InsumosRemoteDataSource {
  final ApiClient apiClient;

  InsumosRemoteDataSource(this.apiClient);

  Future<List<InsumoDto>> getInsumos() async {
    try {
      final response = await apiClient.dio.get(ApiEndpoints.insumos);
      final data = response.data;

      if (data is! List) {
        throw const AppException('La respuesta de insumos no es válida.');
      }

      return data
          .map((e) => InsumoDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ErrorMapper.mapDioError(e);
    } on AppException {
      rethrow;
    } catch (_) {
      throw const UnknownException(
        'Ocurrió un error al consultar los insumos.',
      );
    }
  }
}*/

import 'package:agro_traceability/features/insumos/data/dtos/insumo_dto.dart';

class InsumosRemoteDataSource {
  InsumosRemoteDataSource(dynamic _);

  Future<List<InsumoDto>> getInsumos() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return const [
      InsumoDto(
        id: 'ins-1',
        nombre: 'Fertilizante NPK',
        categoria: 'FERTILIZANTE',
        unidadMedida: 'kg',
      ),
      InsumoDto(
        id: 'ins-2',
        nombre: 'Semilla Castillo',
        categoria: 'SEMILLA',
        unidadMedida: 'kg',
      ),
      InsumoDto(
        id: 'ins-3',
        nombre: 'Insecticida X',
        categoria: 'PLAGUICIDA',
        unidadMedida: 'ml',
      ),
      InsumoDto(
        id: 'ins-4',
        nombre: 'Herbicida Selectivo',
        categoria: 'HERBICIDA',
        unidadMedida: 'l',
      ),
    ];
  }
}
