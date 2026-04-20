import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:agrotraceability/screens/create_lote_screen.dart';
import 'package:agrotraceability/providers/auth_provider.dart';
import 'package:agrotraceability/config/theme.dart';

Widget makeTestable(Widget child) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
    ],
    child: MaterialApp(
      theme: AppTheme.theme,
      home: child,
    ),
  );
}

void main() {
  group('CreateLoteScreen', () {
    testWidgets('✅ Muestra UI de creación', (tester) async {
      // Pantalla grande para evitar que el botón quede "fuera"
      tester.view.physicalSize = const Size(800, 1500);
      await tester.pumpWidget(makeTestable(const CreateLoteScreen()));

      expect(find.text('Nombre del lote'), findsOneWidget);
      
      // Buscar el botón por texto en lugar de tipo para evitar conflictos
      expect(find.text('Crear Lote'), findsWidgets);
      
      addTearDown(tester.view.resetPhysicalSize);
    });

    testWidgets('✅ Modo edición carga datos', (tester) async {
      final lote = {'id': 1, 'nombre': 'Lote Test', 'codigo': 'T-01'};
      await tester.pumpWidget(makeTestable(CreateLoteScreen(lote: lote)));
      await tester.pump();
      expect(find.text('Lote Test'), findsOneWidget);
    });
  });
}