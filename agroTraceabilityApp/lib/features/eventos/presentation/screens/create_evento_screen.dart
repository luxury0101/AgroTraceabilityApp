import 'package:agro_traceability/features/eventos/presentation/providers/create_evento_form_provider.dart';
import 'package:agro_traceability/features/eventos/presentation/providers/eventos_provider.dart';
import 'package:agro_traceability/features/eventos/presentation/widgets/evento_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateEventoScreen extends ConsumerWidget {
  final String loteId;

  const CreateEventoScreen({super.key, required this.loteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(eventosProvider(loteId));

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar evento')),
      body: state.isLoading && state.eventTypes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: EventoForm(
                  loteId: loteId,
                  eventTypes: state.eventTypes,
                  onSuccess: () async {
                    await ref
                        .read(eventosProvider(loteId).notifier)
                        .refreshEventos();
                    ref.read(createEventoFormProvider.notifier).reset();
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
            ),
    );
  }
}
