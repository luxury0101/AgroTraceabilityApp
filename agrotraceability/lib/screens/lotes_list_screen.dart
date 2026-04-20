import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../config/theme.dart';
import 'create_lote_screen.dart';
import 'lote_detail_screen.dart';

class LotesListScreen extends StatefulWidget {
  const LotesListScreen({super.key});

  @override
  State<LotesListScreen> createState() => _LotesListScreenState();
}

class _LotesListScreenState extends State<LotesListScreen> {
  List<dynamic> _lotes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await ApiService.get('/lotes');
      setState(() { _lotes = res['lotes'] ?? []; _loading = false; });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Color _estadoColor(String estado) {
    switch (estado) {
      case 'activo': return AppTheme.primaryGreen;
      case 'en_produccion': return AppTheme.info;
      case 'cosechado': return AppTheme.accentAmber;
      case 'inactivo': return AppTheme.textMuted;
      default: return AppTheme.textMuted;
    }
  }

  String _estadoLabel(String estado) {
    switch (estado) {
      case 'activo': return 'Activo';
      case 'en_produccion': return 'En producción';
      case 'cosechado': return 'Cosechado';
      case 'inactivo': return 'Inactivo';
      default: return estado;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Lotes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateLoteScreen())).then((_) => _load()),
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _lotes.isEmpty
                ? const Center(child: Text('No hay lotes registrados'))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _lotes.length,
                    itemBuilder: (ctx, i) {
                      final lote = _lotes[i];
                      final estado = lote['estado'] ?? 'activo';
                      final color = _estadoColor(estado);
                      return Card(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LoteDetailScreen(loteId: lote['id']))).then((_) => _load()),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: color.withOpacity(0.1),
                                  child: Icon(Icons.landscape, color: color, size: 26),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(lote['nombre'] ?? '', style: Theme.of(context).textTheme.titleMedium),
                                      const SizedBox(height: 4),
                                      Text('${lote['tipo_cultivo'] ?? '—'} • ${lote['codigo'] ?? ''}',
                                          style: Theme.of(context).textTheme.bodyMedium),
                                      const SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: color.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(_estadoLabel(estado),
                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text('${lote['total_eventos'] ?? 0}',
                                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.primaryGreen)),
                                    const Text('eventos', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}