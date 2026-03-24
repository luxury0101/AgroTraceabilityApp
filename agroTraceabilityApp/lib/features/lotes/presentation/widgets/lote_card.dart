import 'package:agro_traceability/features/lotes/domain/entities/lote.dart';
import 'package:agro_traceability/features/lotes/presentation/widgets/lote_status_badge.dart';
import 'package:flutter/material.dart';

class LoteCard extends StatelessWidget {
  final Lote lote;
  final VoidCallback onTap;

  const LoteCard({super.key, required this.lote, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      lote.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  LoteStatusBadge(status: lote.status),
                ],
              ),
              const SizedBox(height: 8),
              Text('Código: ${lote.code}'),
              Text('Cultivo: ${lote.cropType}'),
              Text('Productor: ${lote.producerName}'),
              Text('Área: ${lote.areaHectares} ha'),
              Text('Municipio: ${lote.municipality}'),
            ],
          ),
        ),
      ),
    );
  }
}
