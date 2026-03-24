import 'package:agro_traceability/features/eventos/domain/entities/evento.dart';
import 'package:flutter/material.dart';

class EventoCard extends StatelessWidget {
  final Evento evento;

  const EventoCard({super.key, required this.evento});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              evento.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text('Tipo: ${evento.eventType}'),
            Text('Fecha: ${evento.eventDate}'),
            Text('Registrado por: ${evento.recordedBy}'),
            if (evento.estimatedCost != null)
              Text('Costo estimado: ${evento.estimatedCost}'),
            const SizedBox(height: 8),
            Text(evento.description),
            if (evento.insumos.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'Insumos',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              ...evento.insumos.map(
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
