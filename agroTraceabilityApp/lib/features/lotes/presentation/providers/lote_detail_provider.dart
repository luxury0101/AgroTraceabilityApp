import 'package:agro_traceability/core/error/app_exception.dart';
import 'package:agro_traceability/features/lotes/domain/entities/lote_detail.dart';
import 'package:agro_traceability/features/lotes/domain/usecases/get_lote_detail_usecase.dart';
import 'package:agro_traceability/features/lotes/presentation/providers/lotes_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getLoteDetailUseCaseProvider = Provider<GetLoteDetailUseCase>(
  (ref) => GetLoteDetailUseCase(ref.read(lotesRepositoryProvider)),
);

final loteDetailProvider =
    StateNotifierProvider.family<
      LoteDetailNotifier,
      AsyncValue<LoteDetail?>,
      String
    >(
      (ref, loteId) =>
          LoteDetailNotifier(ref.read(getLoteDetailUseCaseProvider), loteId),
    );

class LoteDetailNotifier extends StateNotifier<AsyncValue<LoteDetail?>> {
  final GetLoteDetailUseCase getLoteDetailUseCase;
  final String loteId;

  LoteDetailNotifier(this.getLoteDetailUseCase, this.loteId)
    : super(const AsyncValue.loading()) {
    loadDetail();
  }

  Future<void> loadDetail() async {
    try {
      final detail = await getLoteDetailUseCase(loteId);
      state = AsyncValue.data(detail);
    } on AppException catch (e, st) {
      state = AsyncValue.error(e.message, st);
    } catch (e, st) {
      state = AsyncValue.error('No se pudo cargar el detalle del lote.', st);
    }
  }
}
