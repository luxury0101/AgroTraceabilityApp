import 'package:agro_traceability/features/eventos/domain/entities/evento_insumo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateEventoFormState {
  final String eventType;
  final bool isIncident;
  final List<EventoInsumo> insumos;

  const CreateEventoFormState({
    required this.eventType,
    required this.isIncident,
    required this.insumos,
  });

  factory CreateEventoFormState.initial() {
    return const CreateEventoFormState(
      eventType: '',
      isIncident: false,
      insumos: [],
    );
  }

  CreateEventoFormState copyWith({
    String? eventType,
    bool? isIncident,
    List<EventoInsumo>? insumos,
  }) {
    return CreateEventoFormState(
      eventType: eventType ?? this.eventType,
      isIncident: isIncident ?? this.isIncident,
      insumos: insumos ?? this.insumos,
    );
  }
}

final createEventoFormProvider =
    StateNotifierProvider<CreateEventoFormNotifier, CreateEventoFormState>(
      (ref) => CreateEventoFormNotifier(),
    );

class CreateEventoFormNotifier extends StateNotifier<CreateEventoFormState> {
  CreateEventoFormNotifier() : super(CreateEventoFormState.initial());

  void setEventType(String value) {
    state = state.copyWith(eventType: value);
  }

  void setIncident(bool value) {
    state = state.copyWith(isIncident: value);
  }

  void addInsumo(EventoInsumo insumo) {
    state = state.copyWith(insumos: [...state.insumos, insumo]);
  }

  void removeInsumo(int index) {
    final updated = [...state.insumos]..removeAt(index);
    state = state.copyWith(insumos: updated);
  }

  void reset() {
    state = CreateEventoFormState.initial();
  }
}
