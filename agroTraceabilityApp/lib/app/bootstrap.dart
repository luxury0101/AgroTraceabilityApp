import 'package:agro_traceability/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void bootstrap() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: AgroTraceabilityApp()));
}
