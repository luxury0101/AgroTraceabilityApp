import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../config/theme.dart';

class EventosListScreen extends StatefulWidget {
  final int loteId;
  final String loteNombre;
  const EventosListScreen({super.key, required this.loteId, required this.loteNombre});

  @override
  State<EventosListScreen> createState() => _EventosListScreenState();
}

class _EventosListScreenState extends State<EventosListScreen> {
  List<dynamic> _eventos = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final res = await ApiService.get('/lotes/${widget.loteId}/eventos');
      setState(() { _eventos = res['eventos'] ?? []; _loading = false; });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  IconData _iconForTipo(String? nombre) {
    switch (nombre?.toLowerCase()) {
      case 'siembra': return Icons.grass;
      case 'riego': return Icons.water_drop;
      case 'fertilización': return Icons.science;
      case 'control de plagas': return Icons.bug_report;
      case 'cosecha': return Icons.shopping_basket;
      case 'incidencia': return Icons.warning_amber;
      case 'poda': return Icons.content_cut;
      case 'preparación de suelo': return Icons.terrain;
      default: return Icons.event;
    }
  }

  Color _colorForTipo(String? nombre) {
    switch (nombre?.toLowerCase()) {
      case 'siembra': return const Color(0xFF4CAF50);
      case 'riego': return const Color(0xFF2196F3);
      case 'fertilización': return const Color(0xFFFF9800);
      case 'control de plagas': return const Color(0xFFF44336);
      case 'cosecha': return const Color(0xFF9C27B0);
      case 'incidencia': return const Color(0xFFFF5722);
      case 'poda': return const Color(0xFF795548);
      default: return AppTheme.primaryGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Eventos: ${widget.loteNombre}')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _eventos.isEmpty
              ? const Center(child: Text('No hay eventos registrados'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: _eventos.length,
                  itemBuilder: (ctx, i) {
                    final ev = _eventos[i];
                    final tipo = ev['tipo_evento_nombre'] ?? '';
                    final color = _colorForTipo(tipo);
                    final icon = _iconForTipo(tipo);
                    final isLast = i == _eventos.length - 1;

                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Timeline line + dot
                          SizedBox(
                            width: 40,
                            child: Column(
                              children: [
                                Container(
                                  width: 14, height: 14,
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: color, border: Border.all(color: Colors.white, width: 2)),
                                ),
                                if (!isLast) Expanded(child: Container(width: 2, color: Colors.grey.shade300)),
                              ],
                            ),
                          ),
                          // Card
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Card(
                                margin: EdgeInsets.zero,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () => _showDetail(ev),
                                  child: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Row(
                                      children: [
                                        CircleAvatar(backgroundColor: color.withOpacity(0.12), child: Icon(icon, color: color, size: 20)),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(tipo, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                                              const SizedBox(height: 2),
                                              Text(ev['fecha_evento'] ?? '', style: const TextStyle(fontSize: 13, color: AppTheme.textMuted)),
                                              if (ev['descripcion'] != null && ev['descripcion'].toString().isNotEmpty)
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 4),
                                                  child: Text(ev['descripcion'], maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)),
                                                ),
                                            ],
                                          ),
                                        ),
                                        const Icon(Icons.chevron_right, color: AppTheme.textMuted),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  void _showDetail(Map<String, dynamic> ev) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (_, scrollCtrl) => SingleChildScrollView(
          controller: scrollCtrl,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              Text(ev['tipo_evento_nombre'] ?? '', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              _detailRow(Icons.calendar_today, 'Fecha', ev['fecha_evento'] ?? ''),
              if (ev['descripcion'] != null) _detailRow(Icons.description, 'Descripción', ev['descripcion']),
              if (ev['observaciones'] != null) _detailRow(Icons.notes, 'Observaciones', ev['observaciones']),
              _detailRow(Icons.person, 'Registrado por', '${ev['registrado_por_nombre'] ?? ''} ${ev['registrado_por_apellido'] ?? ''}'),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppTheme.textMuted),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppTheme.textMuted)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}