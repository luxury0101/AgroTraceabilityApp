import 'package:agro_traceability/features/eventos/domain/entities/evento_insumo.dart';
import 'package:agro_traceability/features/insumos/domain/entities/insumo.dart';
import 'package:agro_traceability/features/insumos/presentation/providers/insumos_provider.dart';
import 'package:agro_traceability/features/insumos/presentation/widgets/insumo_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddInsumoDialog extends ConsumerStatefulWidget {
  const AddInsumoDialog({super.key});

  @override
  ConsumerState<AddInsumoDialog> createState() => _AddInsumoDialogState();
}

class _AddInsumoDialogState extends ConsumerState<AddInsumoDialog> {
  final _formKey = GlobalKey<FormState>();
  final _cantidadController = TextEditingController();
  final _unidadController = TextEditingController();
  final _metodoController = TextEditingController();
  final _observacionesController = TextEditingController();

  Insumo? _selectedInsumo;

  @override
  void dispose() {
    _cantidadController.dispose();
    _unidadController.dispose();
    _metodoController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedInsumo == null) return;

    final insumo = EventoInsumo(
      insumoId: _selectedInsumo!.id,
      nombre: _selectedInsumo!.nombre,
      quantity: double.tryParse(_cantidadController.text.trim()) ?? 0,
      unitOfMeasure: _selectedInsumo!.unidadMedida,
      applicationMethod: _metodoController.text.trim().isEmpty
          ? null
          : _metodoController.text.trim(),
      observations: _observacionesController.text.trim().isEmpty
          ? null
          : _observacionesController.text.trim(),
    );

    Navigator.of(context).pop(insumo);
  }

  @override
  Widget build(BuildContext context) {
    final insumosAsync = ref.watch(insumosProvider);

    return AlertDialog(
      title: const Text('Agregar insumo'),
      content: SizedBox(
        width: 420,
        child: insumosAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => Padding(
            padding: const EdgeInsets.all(8),
            child: Text(error.toString(), textAlign: TextAlign.center),
          ),
          data: (insumos) {
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InsumoSelector(
                      insumos: insumos,
                      selectedId: _selectedInsumo?.id,
                      onChanged: (value) {
                        setState(() {
                          _selectedInsumo = value;
                          _unidadController.text = value?.unidadMedida ?? '';
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _cantidadController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Cantidad'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Obligatorio';
                        }
                        if (double.tryParse(value.trim()) == null) {
                          return 'Número inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _unidadController,
                      readOnly: true,
                      decoration: const InputDecoration(labelText: 'Unidad'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _metodoController,
                      decoration: const InputDecoration(
                        labelText: 'Método de aplicación',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _observacionesController,
                      decoration: const InputDecoration(
                        labelText: 'Observaciones',
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(onPressed: _submit, child: const Text('Agregar')),
      ],
    );
  }
}
