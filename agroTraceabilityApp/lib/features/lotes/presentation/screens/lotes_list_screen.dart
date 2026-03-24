import 'package:agro_traceability/features/lotes/presentation/providers/lotes_provider.dart';
import 'package:agro_traceability/features/lotes/presentation/widgets/lote_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LotesListScreen extends ConsumerStatefulWidget {
  const LotesListScreen({super.key});

  @override
  ConsumerState<LotesListScreen> createState() => _LotesListScreenState();
}

class _LotesListScreenState extends ConsumerState<LotesListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(lotesProvider.notifier).loadLotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(lotesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Lotes')),
      body: RefreshIndicator(
        onRefresh: () => ref.read(lotesProvider.notifier).loadLotes(),
        child: Builder(
          builder: (context) {
            if (state.isLoading && state.lotes.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage != null && state.lotes.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 160),
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

            if (state.lotes.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 160),
                  Center(child: Text('No hay lotes disponibles.')),
                ],
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.lotes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final lote = state.lotes[index];

                return LoteCard(
                  lote: lote,
                  onTap: () => context.push('/lotes/${lote.id}'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
