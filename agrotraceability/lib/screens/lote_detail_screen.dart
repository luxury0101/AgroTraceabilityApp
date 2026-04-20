import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../config/theme.dart';
import 'create_lote_screen.dart';
import 'create_evento_screen.dart';
import 'eventos_list_screen.dart';
import 'trazabilidad_screen.dart';
import 'qr_screen.dart';

class LoteDetailScreen extends StatefulWidget {
  final int loteId;
  const LoteDetailScreen({super.key, required this.loteId});

  @override
  State<LoteDetailScreen> createState() => _LoteDetailScreenState();
}

class _LoteDetailScreenState extends State<LoteDetailScreen> {
  Map<String, dynamic>? _lote;
  List<dynamic> _eventos = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final loteRes = await ApiService.get('/lotes/${widget.loteId}');
      final eventosRes = await ApiService.get('/lotes/${widget.loteId}/eventos');
      setState(() {
        _lote = loteRes['lote'];
        _eventos = eventosRes['eventos'] ?? [];
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(appBar: AppBar(title: const Text('Detalle del Lote')), body: const Center(child: CircularProgressIndicator()));
    }
    if (_lote == null) {
      return Scaffold(appBar: AppBar(title: const Text('Detalle del Lote')), body: const Center(child: Text('Lote no encontrado')));
    }

    final l = _lote!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l['nombre'] ?? 'Lote'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CreateLoteScreen(lote: l))).then((_) => _load()),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CreateEventoScreen(loteId: widget.loteId))).then((_) => _load()),
        icon: const Icon(Icons.add),
        label: const Text('Evento'),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: AppTheme.primaryGreen.withOpacity(0.1),
                            child: const Icon(Icons.landscape, color: AppTheme.primaryGreen, size: 26),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l['nombre'] ?? '', style: Theme.of(context).textTheme.titleLarge),
                                Text('Código: ${l['codigo'] ?? ''}', style: Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      _infoRow(Icons.eco, 'Cultivo', '${l['tipo_cultivo'] ?? '—'} (${l['variedad'] ?? '—'})'),
                      _infoRow(Icons.location_on_outlined, 'Ubicación', l['ubicacion'] ?? '—'),
                      _infoRow(Icons.square_foot, 'Área', '${l['area_hectareas'] ?? '—'} ha'),
                      _infoRow(Icons.flag_outlined, 'Estado', l['estado'] ?? 'activo'),
                      if (l['observaciones'] != null && l['observaciones'].toString().isNotEmpty)
                        _infoRow(Icons.notes, 'Observaciones', l['observaciones']),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Action buttons
              Row(
                children: [
                  Expanded(child: _actionBtn(Icons.timeline, 'Trazabilidad', AppTheme.primaryGreen, () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => TrazabilidadScreen(loteId: widget.loteId)));
                  })),
                  const SizedBox(width: 10),
                  Expanded(child: _actionBtn(Icons.qr_code, 'Generar QR', AppTheme.info, () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => QrScreen(loteId: widget.loteId)));
                  })),
                ],
              ),
              const SizedBox(height: 24),

              // Eventos recientes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Eventos recientes', style: Theme.of(context).textTheme.titleLarge),
                  if (_eventos.isNotEmpty)
                    TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EventosListScreen(loteId: widget.loteId, loteNombre: l['nombre'] ?? ''))),
                      child: const Text('Ver todos'),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              if (_eventos.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                  child: const Column(
                    children: [
                      Icon(Icons.event_note, size: 40, color: AppTheme.textMuted),
                      SizedBox(height: 8),
                      Text('Sin eventos registrados'),
                    ],
                  ),
                )
              else
                ..._eventos.take(5).map((ev) => _eventoTile(ev)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.textMuted),
          const SizedBox(width: 10),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14, color: AppTheme.textMuted))),
        ],
      ),
    );
  }

  Widget _actionBtn(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withOpacity(0.3))),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: color, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _eventoTile(Map<String, dynamic> ev) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryGreen.withOpacity(0.1),
          child: const Icon(Icons.event, color: AppTheme.primaryGreen, size: 20),
        ),
        title: Text(ev['tipo_evento_nombre'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(ev['fecha_evento'] ?? ''),
        trailing: const Icon(Icons.chevron_right, color: AppTheme.textMuted),
        onTap: () => _showEventoDetail(ev),
      ),
    );
  }

  void _showEventoDetail(Map<String, dynamic> ev) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ev['tipo_evento_nombre'] ?? '', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Fecha: ${ev['fecha_evento'] ?? ''}'),
            if (ev['descripcion'] != null) ...[const SizedBox(height: 8), Text(ev['descripcion'])],
            if (ev['observaciones'] != null) ...[const SizedBox(height: 8), Text('Obs: ${ev['observaciones']}', style: const TextStyle(color: AppTheme.textMuted))],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}