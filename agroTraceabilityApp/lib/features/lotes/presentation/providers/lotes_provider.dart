import 'package:agro_traceability/core/error/app_exception.dart';
import 'package:agro_traceability/features/auth/presentation/providers/auth_provider.dart';
import 'package:agro_traceability/features/lotes/data/datasources/lotes_remote_datasource.dart';
import 'package:agro_traceability/features/lotes/domain/usecases/get_lotes_usecase.dart';
import 'package:agro_traceability/features/lotes/presentation/providers/lotes_state.dart';
import 'package:agro_traceability/features/lotes/data/repositories/lotes_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final lotesRemoteDataSourceProvider = Provider<LotesRemoteDataSource>(
  (ref) => LotesRemoteDataSource(ref.read(apiClientProvider)),
);

final lotesRepositoryProvider = Provider<LotesRepositoryImpl>(
  (ref) => LotesRepositoryImpl(ref.read(lotesRemoteDataSourceProvider)),
);

final getLotesUseCaseProvider = Provider<GetLotesUseCase>(
  (ref) => GetLotesUseCase(ref.read(lotesRepositoryProvider)),
);

final lotesProvider = StateNotifierProvider<LotesNotifier, LotesState>((ref) {
  return LotesNotifier(ref.read(getLotesUseCaseProvider));
});

class LotesNotifier extends StateNotifier<LotesState> {
  final GetLotesUseCase getLotesUseCase;

  LotesNotifier(this.getLotesUseCase) : super(LotesState.initial());

  Future<void> loadLotes() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final lotes = await getLotesUseCase();
      state = state.copyWith(isLoading: false, lotes: lotes, clearError: true);
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Ocurrió un error al cargar los lotes.',
      );
    }
  }
}
