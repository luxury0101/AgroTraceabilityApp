import 'package:agro_traceability/features/eventos/presentation/providers/eventos_provider.dart';
import 'package:agro_traceability/features/eventos/presentation/widgets/evento_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EventosListScreen extends ConsumerWidget {
  final String loteId;

  const EventosListScreen({super.key, required this.loteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(eventosProvider(loteId));

    return Scaffold(
      appBar: AppBar(title: const Text('Eventos del lote')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/lotes/$loteId/eventos/nuevo'),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo evento'),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(eventosProvider(loteId).notifier).refreshEventos(),
        child: Builder(
          builder: (context) {
            if (state.isLoading && state.eventos.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage != null && state.eventos.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 180),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        state.errorMessage!,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              );
            }

            if (state.eventos.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 180),
                  Center(child: Text('No hay eventos registrados.')),
                ],
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.eventos.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final evento = state.eventos[index];
                return EventoCard(evento: evento);
              },
            );
          },
        ),
      ),
    );
  }
}
