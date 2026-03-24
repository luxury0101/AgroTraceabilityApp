import 'package:agro_traceability/features/eventos/domain/entities/event_type.dart';
import 'package:agro_traceability/features/eventos/domain/entities/evento.dart';

class EventosState {
  final bool isLoading;
  final List<Evento> eventos;
  final List<EventType> eventTypes;
  final String? errorMessage;

  const EventosState({
    required this.isLoading,
    required this.eventos,
    required this.eventTypes,
    required this.errorMessage,
  });

  factory EventosState.initial() {
    return const EventosState(
      isLoading: false,
      eventos: [],
      eventTypes: [],
      errorMessage: null,
    );
  }

  EventosState copyWith({
    bool? isLoading,
    List<Evento>? eventos,
    List<EventType>? eventTypes,
    String? errorMessage,
    bool clearError = false,
  }) {
    return EventosState(
      isLoading: isLoading ?? this.isLoading,
      eventos: eventos ?? this.eventos,
      eventTypes: eventTypes ?? this.eventTypes,
      errorMessage: clearError ? null : errorMessage,
    );
  }
}
