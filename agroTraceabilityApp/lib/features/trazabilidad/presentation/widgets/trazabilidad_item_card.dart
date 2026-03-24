import 'package:agro_traceability/features/trazabilidad/domain/entities/trazabilidad_item.dart';
import 'package:flutter/material.dart';

class TrazabilidadItemCard extends StatelessWidget {
  final TrazabilidadItem item;

  const TrazabilidadItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text('Fecha: ${item.eventDate}'),
            Text('Tipo: ${item.eventType}'),
            Text('Registrado por: ${item.recordedBy}'),
            if (item.isIncident)
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text(
                  'Incidencia reportada',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            const SizedBox(height: 10),
            Text(item.description),
            if (item.insumos.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'Insumos asociados',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              ...item.insumos.map(
                (insumo) => Text(
                  '- ${insumo.nombre}: ${insumo.quantity} ${insumo.unitOfMeasure}',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
