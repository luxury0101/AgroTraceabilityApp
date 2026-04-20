import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../config/theme.dart';
import 'qr_screen.dart';

class TrazabilidadScreen extends StatefulWidget {
  final int loteId;
  const TrazabilidadScreen({super.key, required this.loteId});

  @override
  State<TrazabilidadScreen> createState() => _TrazabilidadScreenState();
}

class _TrazabilidadScreenState extends State<TrazabilidadScreen> {
  Map<String, dynamic>? _data;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final res = await ApiService.get('/trazabilidad/lote/${widget.loteId}');
      setState(() { _data = res['trazabilidad']; _loading = false; });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trazabilidad'),
        actions: [
          if (_data != null)
            IconButton(
              icon: const Icon(Icons.qr_code),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => QrScreen(loteId: widget.loteId))),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _data == null
              ? const Center(child: Text('No se pudo cargar la trazabilidad'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Lote info
                      _sectionCard(
                        icon: Icons.landscape,
                        title: _data!['lote']['nombre'] ?? '',
                        children: [
                          _row('Código', _data!['lote']['codigo'] ?? ''),
                          _row('Cultivo', '${_data!['lote']['tipo_cultivo'] ?? '—'} (${_data!['lote']['variedad'] ?? '—'})'),
                          _row('Área', '${_data!['lote']['area_hectareas'] ?? '—'} ha'),
                          _row('Estado', _data!['lote']['estado'] ?? ''),
                          _row('Ubicación', _data!['lote']['ubicacion'] ?? '—'),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Productor info
                      _sectionCard(
                        icon: Icons.person,
                        title: 'Productor',
                        children: [
                          _row('Nombre', _data!['productor']['nombre'] ?? ''),
                          _row('Documento', _data!['productor']['documento'] ?? ''),
                          _row('Municipio', '${_data!['productor']['municipio'] ?? ''}, ${_data!['productor']['departamento'] ?? ''}'),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Timeline de eventos
                      Row(
                        children: [
                          Text('Historial de eventos (${_data!['total_eventos']})', style: Theme.of(context).textTheme.titleLarge),
                        ],
                      ),
                      const SizedBox(height: 12),

                      if ((_data!['eventos'] as List).isEmpty)
                        const Center(child: Text('Sin eventos registrados'))
                      else
                        ...(_data!['eventos'] as List).asMap().entries.map((entry) {
                          final i = entry.key;
                          final ev = entry.value;
                          final insumos = ev['insumos'] as List? ?? [];
                          final isLast = i == (_data!['eventos'] as List).length - 1;

                          return IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 36,
                                  child: Column(
                                    children: [
                                      Container(width: 12, height: 12, decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.primaryGreen, border: Border.all(color: Colors.white, width: 2))),
                                      if (!isLast) Expanded(child: Container(width: 2, color: Colors.grey.shade300)),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 14),
                                    child: Card(
                                      margin: EdgeInsets.zero,
                                      child: Padding(
                                        padding: const EdgeInsets.all(14),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(ev['tipo_evento'] ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                                                Text(ev['fecha_evento'] ?? '', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                                              ],
                                            ),
                                            if (ev['descripcion'] != null) ...[
                                              const SizedBox(height: 6),
                                              Text(ev['descripcion'], style: const TextStyle(fontSize: 14)),
                                            ],
                                            if (ev['observaciones'] != null) ...[
                                              const SizedBox(height: 4),
                                              Text('Obs: ${ev['observaciones']}', style: const TextStyle(fontSize: 13, color: AppTheme.textMuted)),
                                            ],
                                            if (insumos.isNotEmpty) ...[
                                              const SizedBox(height: 8),
                                              Container(
                                                padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(color: AppTheme.bgLight, borderRadius: BorderRadius.circular(8)),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text('Insumos:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                                    ...insumos.map<Widget>((ins) => Padding(
                                                      padding: const EdgeInsets.only(top: 4),
                                                      child: Text('• ${ins['insumo']} — ${ins['cantidad']} ${ins['unidad_medida'] ?? ''}',
                                                          style: const TextStyle(fontSize: 13)),
                                                    )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                    ],
                  ),
                ),
    );
  }

  Widget _sectionCard({required IconData icon, required String title, required List<Widget> children}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, color: AppTheme.primaryGreen),
              const SizedBox(width: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
            ]),
            const Divider(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 90, child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppTheme.textMuted))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}