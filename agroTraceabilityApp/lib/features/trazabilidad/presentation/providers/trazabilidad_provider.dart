import 'package:agro_traceability/core/error/app_exception.dart';
import 'package:agro_traceability/features/auth/presentation/providers/auth_provider.dart';
import 'package:agro_traceability/features/trazabilidad/data/datasources/trazabilidad_remote_datasource.dart';
import 'package:agro_traceability/features/trazabilidad/data/repositories/trazabilidad_repository_impl.dart';
import 'package:agro_traceability/features/trazabilidad/domain/usecases/get_trazabilidad_by_lote_usecase.dart';
import 'package:agro_traceability/features/trazabilidad/presentation/providers/trazabilidad_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final trazabilidadRemoteDataSourceProvider =
    Provider<TrazabilidadRemoteDataSource>(
      (ref) => TrazabilidadRemoteDataSource(ref.read(apiClientProvider)),
    );

final trazabilidadRepositoryProvider = Provider<TrazabilidadRepositoryImpl>(
  (ref) => TrazabilidadRepositoryImpl(
    ref.read(trazabilidadRemoteDataSourceProvider),
  ),
);

final getTrazabilidadByLoteUseCaseProvider =
    Provider<GetTrazabilidadByLoteUseCase>(
      (ref) => GetTrazabilidadByLoteUseCase(
        ref.read(trazabilidadRepositoryProvider),
      ),
    );

final trazabilidadProvider =
    StateNotifierProvider.family<
      TrazabilidadNotifier,
      TrazabilidadState,
      String
    >(
      (ref, loteId) => TrazabilidadNotifier(
        loteId: loteId,
        getTrazabilidadByLoteUseCase: ref.read(
          getTrazabilidadByLoteUseCaseProvider,
        ),
      ),
    );

class TrazabilidadNotifier extends StateNotifier<TrazabilidadState> {
  final String loteId;
  final GetTrazabilidadByLoteUseCase getTrazabilidadByLoteUseCase;

  TrazabilidadNotifier({
    required this.loteId,
    required this.getTrazabilidadByLoteUseCase,
  }) : super(TrazabilidadState.initial()) {
    load();
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final items = await getTrazabilidadByLoteUseCase(loteId);
      state = state.copyWith(isLoading: false, items: items, clearError: true);
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'No se pudo cargar la trazabilidad.',
      );
    }
  }
}
