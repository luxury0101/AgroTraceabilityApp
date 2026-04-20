import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../config/theme.dart';

class CreateLoteScreen extends StatefulWidget {
  final Map<String, dynamic>? lote; // null = crear, con datos = editar
  const CreateLoteScreen({super.key, this.lote});

  @override
  State<CreateLoteScreen> createState() => _CreateLoteScreenState();
}

class _CreateLoteScreenState extends State<CreateLoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _codigoCtrl = TextEditingController();
  final _ubicacionCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  final _cultivoCtrl = TextEditingController();
  final _variedadCtrl = TextEditingController();
  final _observacionesCtrl = TextEditingController();
  bool _loading = false;
  bool get _isEditing => widget.lote != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final l = widget.lote!;
      _nombreCtrl.text = l['nombre'] ?? '';
      _codigoCtrl.text = l['codigo'] ?? '';
      _ubicacionCtrl.text = l['ubicacion'] ?? '';
      _areaCtrl.text = l['area_hectareas']?.toString() ?? '';
      _cultivoCtrl.text = l['tipo_cultivo'] ?? '';
      _variedadCtrl.text = l['variedad'] ?? '';
      _observacionesCtrl.text = l['observaciones'] ?? '';
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final body = {
        'nombre': _nombreCtrl.text.trim(),
        'codigo': _codigoCtrl.text.trim(),
        'ubicacion': _ubicacionCtrl.text.trim(),
        'area_hectareas': double.tryParse(_areaCtrl.text) ?? 0,
        'tipo_cultivo': _cultivoCtrl.text.trim(),
        'variedad': _variedadCtrl.text.trim(),
        'observaciones': _observacionesCtrl.text.trim(),
      };
      if (_isEditing) {
        await ApiService.put('/lotes/${widget.lote!['id']}', body);
      } else {
        await ApiService.post('/lotes', body);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isEditing ? 'Lote actualizado' : 'Lote creado exitosamente'), backgroundColor: AppTheme.primaryGreen),
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

  Widget _field(TextEditingController ctrl, String label, IconData icon, {TextInputType? type, bool required = true, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: ctrl,
        keyboardType: type,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
        validator: required ? (v) => v == null || v.isEmpty ? 'Campo obligatorio' : null : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Editar Lote' : 'Crear Lote')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _field(_nombreCtrl, 'Nombre del lote', Icons.landscape),
              _field(_codigoCtrl, 'Código (ej: LT-001)', Icons.tag),
              _field(_ubicacionCtrl, 'Ubicación', Icons.location_on_outlined, required: false),
              _field(_areaCtrl, 'Área (hectáreas)', Icons.square_foot, type: TextInputType.number, required: false),
              _field(_cultivoCtrl, 'Tipo de cultivo', Icons.eco, required: false),
              _field(_variedadCtrl, 'Variedad', Icons.grass, required: false),
              _field(_observacionesCtrl, 'Observaciones', Icons.notes, required: false, maxLines: 3),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _save,
                  icon: _loading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Icon(_isEditing ? Icons.save : Icons.add_circle_outline),
                  label: Text(_isEditing ? 'Guardar Cambios' : 'Crear Lote'),
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
    _nombreCtrl.dispose(); _codigoCtrl.dispose(); _ubicacionCtrl.dispose();
    _areaCtrl.dispose(); _cultivoCtrl.dispose(); _variedadCtrl.dispose();
    _observacionesCtrl.dispose();
    super.dispose();
  }
}