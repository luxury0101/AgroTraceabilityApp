import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../services/api_service.dart';
import '../config/theme.dart';

class QrScreen extends StatefulWidget {
  final int loteId;
  const QrScreen({super.key, required this.loteId});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  Map<String, dynamic>? _trazabilidad;
  bool _loading = true;
  String? _qrData;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final res = await ApiService.get('/trazabilidad/lote/${widget.loteId}');
      final traz = res['trazabilidad'];
      // Crear JSON compacto para QR
      final qrPayload = {
        'app': 'AgroTraceability',
        'lote': {
          'id': traz['lote']['id'],
          'codigo': traz['lote']['codigo'],
          'nombre': traz['lote']['nombre'],
          'cultivo': traz['lote']['tipo_cultivo'],
          'variedad': traz['lote']['variedad'],
          'estado': traz['lote']['estado'],
          'ubicacion': traz['lote']['ubicacion'],
        },
        'productor': traz['productor'],
        'total_eventos': traz['total_eventos'],
        'eventos': (traz['eventos'] as List).map((ev) => {
          'tipo': ev['tipo_evento'],
          'fecha': ev['fecha_evento'],
          'desc': ev['descripcion'] ?? '',
          'insumos': (ev['insumos'] as List).map((ins) => '${ins['insumo']}:${ins['cantidad']}${ins['unidad_medida'] ?? ''}').toList(),
        }).toList(),
        'generado': traz['generado_en'],
      };
      setState(() {
        _trazabilidad = traz;
        _qrData = jsonEncode(qrPayload);
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR de Trazabilidad')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _qrData == null
              ? const Center(child: Text('No se pudo generar el QR'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Text(_trazabilidad!['lote']['nombre'] ?? '', style: Theme.of(context).textTheme.titleLarge),
                              const SizedBox(height: 4),
                              Text('Código: ${_trazabilidad!['lote']['codigo'] ?? ''}', style: Theme.of(context).textTheme.bodyMedium),
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
                                child: QrImageView(
                                  data: _qrData!,
                                  version: QrVersions.auto,
                                  size: 250,
                                  backgroundColor: Colors.white,
                                  eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.circle, color: AppTheme.darkGreen),
                                  dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.circle, color: AppTheme.textDark),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(color: AppTheme.primaryGreen.withOpacity(0.08), borderRadius: BorderRadius.circular(20)),
                                child: Text('${_trazabilidad!['total_eventos']} eventos registrados',
                                    style: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.w600)),
                              ),
                              const SizedBox(height: 12),
                              Text('Productor: ${_trazabilidad!['productor']['nombre'] ?? ''}',
                                  style: const TextStyle(fontSize: 14, color: AppTheme.textMuted)),
                              Text('${_trazabilidad!['productor']['municipio'] ?? ''}, ${_trazabilidad!['productor']['departamento'] ?? ''}',
                                  style: const TextStyle(fontSize: 13, color: AppTheme.textMuted)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.info.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.info.withOpacity(0.2)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline, color: AppTheme.info, size: 20),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Otro productor con la app puede escanear este QR para ver el reporte completo de trazabilidad de este lote.',
                                style: TextStyle(fontSize: 13, color: AppTheme.textDark),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}