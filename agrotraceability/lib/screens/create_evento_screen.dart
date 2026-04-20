import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../config/theme.dart';

class CreateEventoScreen extends StatefulWidget {
  final int loteId;
  const CreateEventoScreen({super.key, required this.loteId});

  @override
  State<CreateEventoScreen> createState() => _CreateEventoScreenState();
}

class _CreateEventoScreenState extends State<CreateEventoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descripcionCtrl = TextEditingController();
  final _observacionesCtrl = TextEditingController();
  List<dynamic> _tiposEvento = [];
  int? _selectedTipo;
  DateTime _fechaEvento = DateTime.now();
  bool _loading = false;

  // Insumos temporales
  final List<Map<String, dynamic>> _insumos = [];
  final _insumoNombreCtrl = TextEditingController();
  final _insumoCantidadCtrl = TextEditingController();
  final _insumoUnidadCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTipos();
  }

  Future<void> _loadTipos() async {
    try {
      final res = await ApiService.get('/tipos-evento');
      setState(() => _tiposEvento = res['tipos'] ?? []);
    } catch (e) { /* silent */ }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaEvento,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _fechaEvento = picked);
  }

  void _addInsumo() {
    if (_insumoNombreCtrl.text.isEmpty || _insumoCantidadCtrl.text.isEmpty) return;
    setState(() {
      _insumos.add({
        'nombre': _insumoNombreCtrl.text.trim(),
        'cantidad': double.tryParse(_insumoCantidadCtrl.text) ?? 0,
        'unidad_medida': _insumoUnidadCtrl.text.trim(),
      });
      _insumoNombreCtrl.clear();
      _insumoCantidadCtrl.clear();
      _insumoUnidadCtrl.clear();
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _selectedTipo == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecciona el tipo de evento'), backgroundColor: AppTheme.danger));
      return;
    }
    setState(() => _loading = true);
    try {
      final eventoRes = await ApiService.post('/lotes/${widget.loteId}/eventos', {
        'tipo_evento_id': _selectedTipo,
        'fecha_evento': DateFormat('yyyy-MM-dd').format(_fechaEvento),
        'descripcion': _descripcionCtrl.text.trim(),
        'observaciones': _observacionesCtrl.text.trim(),
      });

      // Registrar insumos si hay
      final eventoId = eventoRes['evento']['id'];
      for (final insumo in _insumos) {
        await ApiService.post('/eventos/$eventoId/insumos', {
          'nombre': insumo['nombre'],
          'cantidad': insumo['cantidad'],
          'unidad_medida': insumo['unidad_medida'],
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Evento registrado exitosamente'), backgroundColor: AppTheme.primaryGreen),
        );
        Navigator.pop(context, true);
      }
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message), backgroundColor: AppTheme.danger));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error de conexión'), backgroundColor: AppTheme.danger));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Evento')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tipo de evento
              Text('Tipo de evento', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _selectedTipo,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.category)),
                hint: const Text('Seleccionar tipo'),
                items: _tiposEvento.map<DropdownMenuItem<int>>((t) {
                  return DropdownMenuItem(value: t['id'] as int, child: Text(t['nombre']));
                }).toList(),
                onChanged: (v) => setState(() => _selectedTipo = v),
                validator: (v) => v == null ? 'Selecciona un tipo' : null,
              ),
              const SizedBox(height: 16),

              // Fecha
              Text('Fecha del evento', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: AppTheme.textMuted),
                      const SizedBox(width: 12),
                      Text(DateFormat('dd/MM/yyyy').format(_fechaEvento), style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Descripción
              TextFormField(
                controller: _descripcionCtrl,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Descripción', prefixIcon: Icon(Icons.description)),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _observacionesCtrl,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Observaciones (opcional)', prefixIcon: Icon(Icons.notes)),
              ),
              const SizedBox(height: 24),

              // Insumos
              Text('Insumos aplicados', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: TextField(controller: _insumoNombreCtrl, decoration: const InputDecoration(hintText: 'Nombre', isDense: true))),
                        const SizedBox(width: 8),
                        SizedBox(width: 70, child: TextField(controller: _insumoCantidadCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'Cant.', isDense: true))),
                        const SizedBox(width: 8),
                        SizedBox(width: 60, child: TextField(controller: _insumoUnidadCtrl, decoration: const InputDecoration(hintText: 'Und', isDense: true))),
                        IconButton(icon: const Icon(Icons.add_circle, color: AppTheme.primaryGreen), onPressed: _addInsumo),
                      ],
                    ),
                    if (_insumos.isNotEmpty) ...[
                      const Divider(),
                      ..._insumos.asMap().entries.map((e) => ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(e.value['nombre']),
                        subtitle: Text('${e.value['cantidad']} ${e.value['unidad_medida']}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: AppTheme.danger, size: 20),
                          onPressed: () => setState(() => _insumos.removeAt(e.key)),
                        ),
                      )),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _save,
                  icon: _loading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.save),
                  label: const Text('Registrar Evento'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descripcionCtrl.dispose(); _observacionesCtrl.dispose();
    _insumoNombreCtrl.dispose(); _insumoCantidadCtrl.dispose(); _insumoUnidadCtrl.dispose();
    super.dispose();
  }
}