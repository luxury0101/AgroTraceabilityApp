import 'package:agro_traceability/features/lotes/presentation/providers/lote_detail_provider.dart';
import 'package:agro_traceability/features/lotes/presentation/widgets/lote_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoteDetailScreen extends ConsumerWidget {
  final String loteId;

  const LoteDetailScreen({super.key, required this.loteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loteDetailProvider(loteId));

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del lote')),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(error.toString(), textAlign: TextAlign.center),
          ),
        ),
        data: (lote) {
          if (lote == null) {
            return const Center(
              child: Text('No se encontró información del lote.'),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                lote.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              LoteStatusBadge(status: lote.status),
              const SizedBox(height: 20),
              Text('Código: ${lote.code}'),
              Text('Cultivo: ${lote.cropType}'),
              Text('Variedad: ${lote.cropVariety ?? 'No especificada'}'),
              Text('Productor: ${lote.producerName}'),
              Text('Área: ${lote.areaHectares} ha'),
              Text('Municipio: ${lote.municipality}'),
              Text(
                'Ubicación: ${lote.locationDescription ?? 'No especificada'}',
              ),
              Text(
                'Siembra esperada: ${lote.expectedSowingDate ?? 'No definida'}',
              ),
              Text(
                'Cosecha esperada: ${lote.expectedHarvestDate ?? 'No definida'}',
              ),
              const SizedBox(height: 16),
              const Text(
                'Observaciones',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(lote.observations ?? 'Sin observaciones.'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.push('/lotes/$loteId/eventos');
                  },
                  icon: const Icon(Icons.list_alt),
                  label: const Text('Ver eventos'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.push('/lotes/$loteId/eventos/nuevo');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Registrar evento'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.push('/lotes/$loteId/trazabilidad');
                  },
                  icon: const Icon(Icons.timeline),
                  label: const Text('Ver trazabilidad'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
