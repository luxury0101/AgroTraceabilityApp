import 'package:agro_traceability/features/eventos/domain/entities/event_type.dart';
import 'package:agro_traceability/features/eventos/presentation/providers/create_evento_form_provider.dart';
import 'package:agro_traceability/features/eventos/presentation/providers/create_evento_provider.dart';
import 'package:agro_traceability/features/eventos/presentation/widgets/evento_type_dropdown.dart';
import 'package:agro_traceability/features/eventos/presentation/widgets/insumos_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventoForm extends ConsumerStatefulWidget {
  final String loteId;
  final List<EventType> eventTypes;
  final VoidCallback? onSuccess;

  const EventoForm({
    super.key,
    required this.loteId,
    required this.eventTypes,
    this.onSuccess,
  });

  @override
  ConsumerState<EventoForm> createState() => _EventoFormState();
}

class _EventoFormState extends ConsumerState<EventoForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _costController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _costController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 5),
      initialDate: now,
    );

    if (selected != null) {
      _dateController.text = selected.toIso8601String().split('T').first;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final formState = ref.read(createEventoFormProvider);
    final notifier = ref.read(createEventoProvider.notifier);

    final success = await notifier.createEvento(
      loteId: widget.loteId,
      eventType: formState.eventType,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      eventDate: _dateController.text.trim(),
      isIncident: formState.isIncident,
      estimatedCost: _costController.text.trim().isEmpty
          ? null
          : double.tryParse(_costController.text.trim()),
      insumos: formState.insumos,
    );

    if (success && mounted) {
      ref.read(createEventoFormProvider.notifier).reset();
      widget.onSuccess?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(createEventoFormProvider);
    final createState = ref.watch(createEventoProvider);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          EventoTypeDropdown(
            value: formState.eventType,
            items: widget.eventTypes,
            onChanged: (value) {
              ref
                  .read(createEventoFormProvider.notifier)
                  .setEventType(value ?? '');
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Título'),
            validator: (value) =>
                value == null || value.trim().isEmpty ? 'Obligatorio' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Descripción'),
            maxLines: 3,
            validator: (value) =>
                value == null || value.trim().isEmpty ? 'Obligatorio' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _dateController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Fecha del evento',
              suffixIcon: Icon(Icons.calendar_today),
            ),
            onTap: _pickDate,
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Selecciona una fecha'
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _costController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Costo estimado (opcional)',
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('¿Es una incidencia?'),
            value: formState.isIncident,
            onChanged: (value) {
              ref.read(createEventoFormProvider.notifier).setIncident(value);
            },
          ),
          const SizedBox(height: 16),
          const InsumosSection(),
          const SizedBox(height: 20),
          if (createState.hasError) ...[
            Text(
              createState.error.toString(),
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 12),
          ],
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: createState.isLoading ? null : _submit,
              child: createState.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Guardar evento'),
            ),
          ),
        ],
      ),
    );
  }
}
