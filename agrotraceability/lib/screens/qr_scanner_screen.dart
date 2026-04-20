import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../config/theme.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool _scanned = false;
  Map<String, dynamic>? _reportData;

  void _onDetect(BarcodeCapture capture) {
    if (_scanned) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue == null) return;

    try {
      final data = jsonDecode(barcode!.rawValue!);
      if (data['app'] == 'AgroTraceability') {
        setState(() {
          _scanned = true;
          _reportData = data;
        });
      } else {
        _showError('Este QR no es de AgroTraceability');
      }
    } catch (e) {
      _showError('QR no reconocido');
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: AppTheme.danger));
  }

  void _resetScan() {
    setState(() {
      _scanned = false;
      _reportData = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_scanned && _reportData != null) {
      return _buildReport();
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear QR')),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(onDetect: _onDetect),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.black87,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code_scanner, color: Colors.white),
                SizedBox(width: 10),
                Text('Apunta al código QR de trazabilidad', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReport() {
    final lote = _reportData!['lote'] ?? {};
    final productor = _reportData!['productor'] ?? {};
    final eventos = _reportData!['eventos'] as List? ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte de Trazabilidad'),
        actions: [IconButton(icon: const Icon(Icons.qr_code_scanner), onPressed: _resetScan, tooltip: 'Escanear otro')],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
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
                  const Row(children: [
                    Icon(Icons.verified, color: Colors.white, size: 22),
                    SizedBox(width: 8),
                    Text('AgroTraceability', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  ]),
                  const SizedBox(height: 10),
                  Text(lote['nombre'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                  Text('${lote['cultivo'] ?? ''} (${lote['variedad'] ?? ''})', style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  Text('Productor: ${productor['nombre'] ?? ''}', style: const TextStyle(color: Colors.white, fontSize: 14)),
                  Text('${productor['municipio'] ?? ''}, ${productor['departamento'] ?? ''}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Text('Historial de eventos (${eventos.length})', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),

            ...eventos.asMap().entries.map((entry) {
              final ev = entry.value;
              final insumos = ev['insumos'] as List? ?? [];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(ev['tipo'] ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                          Text(ev['fecha'] ?? '', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                        ],
                      ),
                      if (ev['desc'] != null && ev['desc'].toString().isNotEmpty)
                        Padding(padding: const EdgeInsets.only(top: 6), child: Text(ev['desc'])),
                      if (insumos.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          children: insumos.map<Widget>((ins) => Chip(
                            label: Text(ins.toString(), style: const TextStyle(fontSize: 11)),
                            backgroundColor: AppTheme.bgLight,
                            visualDensity: VisualDensity.compact,
                          )).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}