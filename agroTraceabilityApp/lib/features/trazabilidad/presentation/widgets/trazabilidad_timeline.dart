import 'package:flutter/material.dart';

class LoteStatusBadge extends StatelessWidget {
  final String status;

  const LoteStatusBadge({super.key, required this.status});

  Color _backgroundColor() {
    switch (status.toUpperCase()) {
      case 'SEMBRADO':
      case 'EN_PRODUCCION':
        return Colors.green.shade100;
      case 'PLANIFICADO':
      case 'PREPARACION':
        return Colors.orange.shade100;
      case 'COSECHADO':
      case 'CERRADO':
        return Colors.blue.shade100;
      case 'SUSPENDIDO':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Color _textColor() {
    switch (status.toUpperCase()) {
      case 'SEMBRADO':
      case 'EN_PRODUCCION':
        return Colors.green.shade800;
      case 'PLANIFICADO':
      case 'PREPARACION':
        return Colors.orange.shade800;
      case 'COSECHADO':
      case 'CERRADO':
        return Colors.blue.shade800;
      case 'SUSPENDIDO':
        return Colors.red.shade800;
      default:
        return Colors.grey.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _backgroundColor(),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: _textColor(),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
