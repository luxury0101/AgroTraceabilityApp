import 'package:agro_traceability/core/error/app_exception.dart';
import 'package:agro_traceability/features/auth/presentation/providers/auth_provider.dart';
import 'package:agro_traceability/features/eventos/data/datasources/eventos_remote_datasource.dart';
import 'package:agro_traceability/features/eventos/data/repositories/eventos_repository_impl.dart';
import 'package:agro_traceability/features/eventos/domain/entities/event_type.dart';
import 'package:agro_traceability/features/eventos/domain/entities/evento.dart';
import 'package:agro_traceability/features/eventos/domain/usecases/get_event_types_usecase.dart';
import 'package:agro_traceability/features/eventos/domain/usecases/get_eventos_by_lote_usecase.dart';
import 'package:agro_traceability/features/eventos/presentation/providers/eventos_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventosRemoteDataSourceProvider = Provider<EventosRemoteDataSource>(
  (ref) => EventosRemoteDataSource(ref.read(apiClientProvider)),
);

final eventosRepositoryProvider = Provider<EventosRepositoryImpl>(
  (ref) => EventosRepositoryImpl(ref.read(eventosRemoteDataSourceProvider)),
);

final getEventosByLoteUseCaseProvider = Provider<GetEventosByLoteUseCase>(
  (ref) => GetEventosByLoteUseCase(ref.read(eventosRepositoryProvider)),
);

final getEventTypesUseCaseProvider = Provider<GetEventTypesUseCase>(
  (ref) => GetEventTypesUseCase(ref.read(eventosRepositoryProvider)),
);

final eventosProvider =
    StateNotifierProvider.family<EventosNotifier, EventosState, String>(
      (ref, loteId) => EventosNotifier(
        loteId: loteId,
        getEventosByLoteUseCase: ref.read(getEventosByLoteUseCaseProvider),
        getEventTypesUseCase: ref.read(getEventTypesUseCaseProvider),
      ),
    );

class EventosNotifier extends StateNotifier<EventosState> {
  final String loteId;
  final GetEventosByLoteUseCase getEventosByLoteUseCase;
  final GetEventTypesUseCase getEventTypesUseCase;

  EventosNotifier({
    required this.loteId,
    required this.getEventosByLoteUseCase,
    required this.getEventTypesUseCase,
  }) : super(EventosState.initial()) {
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final List<Evento> eventos = await getEventosByLoteUseCase(loteId);
      final List<EventType> eventTypes = await getEventTypesUseCase();

      state = state.copyWith(
        isLoading: false,
        eventos: eventos,
        eventTypes: eventTypes,
        clearError: true,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Ocurrió un error al cargar los eventos.',
      );
    }
  }

  Future<void> refreshEventos() async {
    try {
      final eventos = await getEventosByLoteUseCase(loteId);
      state = state.copyWith(eventos: eventos, clearError: true);
    } on AppException catch (e) {
      state = state.copyWith(errorMessage: e.message);
    } catch (_) {
      state = state.copyWith(
        errorMessage: 'No se pudieron actualizar los eventos.',
      );
    }
  }
}
