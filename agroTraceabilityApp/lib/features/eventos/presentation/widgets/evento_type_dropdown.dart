import 'package:agro_traceability/features/eventos/domain/entities/event_type.dart';
import 'package:flutter/material.dart';

class EventoTypeDropdown extends StatelessWidget {
  final String value;
  final List<EventType> items;
  final ValueChanged<String?> onChanged;

  const EventoTypeDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value.isEmpty ? null : value,
      decoration: const InputDecoration(labelText: 'Tipo de evento'),
      items: items
          .map(
            (item) => DropdownMenuItem<String>(
              value: item.code,
              child: Text(item.name),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Selecciona un tipo de evento';
        }
        return null;
      },
    );
  }
}
