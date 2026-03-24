import 'package:agro_traceability/core/error/app_exception.dart';
import 'package:agro_traceability/features/auth/presentation/providers/auth_provider.dart';
import 'package:agro_traceability/features/insumos/data/datasources/insumos_remote_datasource.dart';
import 'package:agro_traceability/features/insumos/data/repositories/insumos_repository_impl.dart';
import 'package:agro_traceability/features/insumos/domain/entities/insumo.dart';
import 'package:agro_traceability/features/insumos/domain/usecases/get_insumos_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final insumosRemoteDataSourceProvider = Provider<InsumosRemoteDataSource>(
  (ref) => InsumosRemoteDataSource(ref.read(apiClientProvider)),
);

final insumosRepositoryProvider = Provider<InsumosRepositoryImpl>(
  (ref) => InsumosRepositoryImpl(ref.read(insumosRemoteDataSourceProvider)),
);

final getInsumosUseCaseProvider = Provider<GetInsumosUseCase>(
  (ref) => GetInsumosUseCase(ref.read(insumosRepositoryProvider)),
);

final insumosProvider = FutureProvider<List<Insumo>>((ref) async {
  try {
    return await ref.read(getInsumosUseCaseProvider)();
  } on AppException {
    rethrow;
  } catch (_) {
    throw Exception('No se pudieron cargar los insumos.');
  }
});
