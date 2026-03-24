import 'package:agro_traceability/features/trazabilidad/presentation/providers/trazabilidad_provider.dart';
import 'package:agro_traceability/features/trazabilidad/presentation/widgets/trazabilidad_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrazabilidadScreen extends ConsumerWidget {
  final String loteId;

  const TrazabilidadScreen({super.key, required this.loteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(trazabilidadProvider(loteId));

    return Scaffold(
      appBar: AppBar(title: const Text('Trazabilidad')),
      body: RefreshIndicator(
        onRefresh: () => ref.read(trazabilidadProvider(loteId).notifier).load(),
        child: Builder(
          builder: (context) {
            if (state.isLoading && state.items.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage != null && state.items.isEmpty) {
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

            if (state.items.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 180),
                  Center(child: Text('No hay trazabilidad disponible.')),
                ],
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = state.items[index];
                return TrazabilidadItemCard(item: item);
              },
            );
          },
        ),
      ),
    );
  }
}
