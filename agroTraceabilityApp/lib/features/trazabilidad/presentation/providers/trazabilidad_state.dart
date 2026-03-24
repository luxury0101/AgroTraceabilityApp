import 'package:agro_traceability/features/trazabilidad/domain/entities/trazabilidad_item.dart';

class TrazabilidadState {
  final bool isLoading;
  final List<TrazabilidadItem> items;
  final String? errorMessage;

  const TrazabilidadState({
    required this.isLoading,
    required this.items,
    required this.errorMessage,
  });

  factory TrazabilidadState.initial() {
    return const TrazabilidadState(
      isLoading: false,
      items: [],
      errorMessage: null,
    );
  }

  TrazabilidadState copyWith({
    bool? isLoading,
    List<TrazabilidadItem>? items,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TrazabilidadState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      errorMessage: clearError ? null : errorMessage,
    );
  }
}
