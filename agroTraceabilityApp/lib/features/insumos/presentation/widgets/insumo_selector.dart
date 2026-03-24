import 'package:agro_traceability/features/insumos/domain/entities/insumo.dart';
import 'package:flutter/material.dart';

class InsumoSelector extends StatelessWidget {
  final List<Insumo> insumos;
  final String? selectedId;
  final ValueChanged<Insumo?> onChanged;

  const InsumoSelector({
    super.key,
    required this.insumos,
    required this.selectedId,
    required this.onChanged,
  });

  Insumo? _findById(String? id) {
    for (final insumo in insumos) {
      if (insumo.id == id) return insumo;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: selectedId,
      decoration: const InputDecoration(labelText: 'Insumo'),
      items: insumos
          .map(
            (insumo) => DropdownMenuItem<String>(
              value: insumo.id,
              child: Text('${insumo.nombre} (${insumo.unidadMedida})'),
            ),
          )
          .toList(),
      onChanged: (value) {
        onChanged(_findById(value));
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Selecciona un insumo';
        }
        return null;
      },
    );
  }
}
