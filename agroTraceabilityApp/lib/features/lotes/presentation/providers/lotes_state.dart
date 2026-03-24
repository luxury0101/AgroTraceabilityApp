import 'package:agro_traceability/features/lotes/domain/entities/lote.dart';

class LotesState {
  final bool isLoading;
  final List<Lote> lotes;
  final String? errorMessage;

  const LotesState({
    required this.isLoading,
    required this.lotes,
    required this.errorMessage,
  });

  factory LotesState.initial() {
    return const LotesState(isLoading: false, lotes: [], errorMessage: null);
  }

  LotesState copyWith({
    bool? isLoading,
    List<Lote>? lotes,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LotesState(
      isLoading: isLoading ?? this.isLoading,
      lotes: lotes ?? this.lotes,
      errorMessage: clearError ? null : errorMessage,
    );
  }
}
