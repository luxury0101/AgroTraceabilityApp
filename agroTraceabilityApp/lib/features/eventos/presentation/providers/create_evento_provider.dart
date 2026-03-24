import 'package:agro_traceability/core/error/app_exception.dart';
import 'package:agro_traceability/features/eventos/domain/entities/evento_insumo.dart';
import 'package:agro_traceability/features/eventos/domain/usecases/create_evento_usecase.dart';
import 'package:agro_traceability/features/eventos/presentation/providers/eventos_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createEventoUseCaseProvider = Provider<CreateEventoUseCase>(
  (ref) => CreateEventoUseCase(ref.read(eventosRepositoryProvider)),
);

final createEventoProvider =
    StateNotifierProvider<CreateEventoNotifier, AsyncValue<void>>(
      (ref) => CreateEventoNotifier(ref.read(createEventoUseCaseProvider)),
    );

class CreateEventoNotifier extends StateNotifier<AsyncValue<void>> {
  final CreateEventoUseCase createEventoUseCase;

  CreateEventoNotifier(this.createEventoUseCase)
    : super(const AsyncValue.data(null));

  Future<bool> createEvento({
    required String loteId,
    required String eventType,
    required String title,
    required String description,
    required String eventDate,
    required bool isIncident,
    required double? estimatedCost,
    required List<EventoInsumo> insumos,
  }) async {
    state = const AsyncValue.loading();

    try {
      await createEventoUseCase(
        loteId: loteId,
        eventType: eventType,
        title: title,
        description: description,
        eventDate: eventDate,
        isIncident: isIncident,
        estimatedCost: estimatedCost,
        insumos: insumos,
      );

      state = const AsyncValue.data(null);
      return true;
    } on AppException catch (e, st) {
      state = AsyncValue.error(e.message, st);
      return false;
    } catch (e, st) {
      state = AsyncValue.error('No se pudo registrar el evento.', st);
      return false;
    }
  }
}
