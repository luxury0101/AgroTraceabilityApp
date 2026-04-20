import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../config/theme.dart';
import '../services/api_service.dart';
import 'lotes_list_screen.dart';
import 'create_lote_screen.dart';
import 'lote_detail_screen.dart';
import 'qr_scanner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _lotes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadLotes();
  }

  Future<void> _loadLotes() async {
    try {
      final response = await ApiService.get('/lotes');
      setState(() {
        _lotes = response['lotes'] ?? [];
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('AgroTraceability'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => auth.logout(),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadLotes,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Saludo
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppTheme.primaryGreen, AppTheme.darkGreen]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('¡Hola, ${auth.user?['nombre'] ?? 'Productor'}!',
                        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text('Bienvenido a tu panel de gestión agrícola',
                        style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 14)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _statCard(Icons.landscape, '${_lotes.length}', 'Lotes'),
                        const SizedBox(width: 12),
                        _statCard(
                          Icons.event_note,
                          '${_lotes.fold<int>(0, (sum, l) => sum + ((l['total_eventos'] ?? 0) as int))}',
                          'Eventos',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Acciones rápidas
              Row(
                children: [
                  Expanded(
                    child: _actionButton(Icons.add_circle_outline, 'Crear Lote', () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateLoteScreen())).then((_) => _loadLotes());
                    }),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _actionButton(Icons.list_alt, 'Ver Lotes', () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const LotesListScreen())).then((_) => _loadLotes());
                    }),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _actionButton(Icons.qr_code_scanner, 'Escanear QR', () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const QrScannerScreen()));
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Lotes recientes
              Text('Lotes recientes', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              if (_loading)
                const Center(child: CircularProgressIndicator())
              else if (_lotes.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.eco_outlined, size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      const Text('Aún no tienes lotes registrados'),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateLoteScreen())).then((_) => _loadLotes()),
                        child: const Text('Crear tu primer lote'),
                      ),
                    ],
                  ),
                )
              else
                ...(_lotes.take(5).map((lote) => _loteCard(lote))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
              Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: AppTheme.primaryGreen),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.primaryGreen)),
          ],
        ),
      ),
    );
  }

  Widget _loteCard(Map<String, dynamic> lote) {
    final estado = lote['estado'] ?? 'activo';
    final color = estado == 'activo' ? AppTheme.primaryGreen : estado == 'cosechado' ? AppTheme.accentAmber : AppTheme.textMuted;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(Icons.landscape, color: color),
        ),
        title: Text(lote['nombre'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${lote['tipo_cultivo'] ?? 'Sin cultivo'} • ${lote['codigo'] ?? ''}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${lote['total_eventos'] ?? 0}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const Text('eventos', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
          ],
        ),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LoteDetailScreen(loteId: lote['id']))).then((_) => _loadLotes()),
      ),
    );
  }
}