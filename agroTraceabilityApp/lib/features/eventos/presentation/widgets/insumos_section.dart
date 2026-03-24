import 'package:agro_traceability/features/eventos/presentation/widgets/add_insumo_dialog.dart';
import 'package:agro_traceability/features/eventos/presentation/providers/create_evento_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InsumosSection extends ConsumerWidget {
  const InsumosSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(createEventoFormProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Insumos',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            TextButton.icon(
              onPressed: () async {
                final insumo = await showDialog(
                  context: context,
                  builder: (_) => const AddInsumoDialog(),
                );

                if (insumo != null) {
                  ref.read(createEventoFormProvider.notifier).addInsumo(insumo);
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Agregar'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (formState.insumos.isEmpty)
          const Text('No se han agregado insumos.'),
        ...List.generate(formState.insumos.length, (index) {
          final insumo = formState.insumos[index];

          return Card(
            child: ListTile(
              title: Text(insumo.nombre),
              subtitle: Text(
                '${insumo.quantity} ${insumo.unitOfMeasure}'
                '${insumo.applicationMethod != null ? ' · ${insumo.applicationMethod}' : ''}',
              ),
              trailing: IconButton(
                onPressed: () {
                  ref
                      .read(createEventoFormProvider.notifier)
                      .removeInsumo(index);
                },
                icon: const Icon(Icons.delete_outline),
              ),
            ),
          );
        }),
      ],
    );
  }
}
