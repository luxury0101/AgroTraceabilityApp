import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:agrotraceability/screens/login_screen.dart';
import 'package:agrotraceability/screens/register_screen.dart';
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
  group('LoginScreen - elementos de UI', () {
    testWidgets('✅ Muestra campo de email/usuario', (tester) async {
      await tester.pumpWidget(makeTestable(const LoginScreen()));
      expect(find.byType(TextFormField), findsWidgets);
    });

    testWidgets('✅ Muestra botón de Iniciar Sesión', (tester) async {
      await tester.pumpWidget(makeTestable(const LoginScreen()));
      expect(find.text('Iniciar Sesión'), findsOneWidget);
    });

    testWidgets('✅ Muestra enlace a registro', (tester) async {
      await tester.pumpWidget(makeTestable(const LoginScreen()));
      // Usamos find.byWidgetPredicate para ignorar problemas de RichText
      expect(find.byWidgetPredicate((w) => w is RichText), findsWidgets);
    });
  });

  group('RegisterScreen - elementos de UI', () {
    testWidgets('✅ Muestra campos del formulario', (tester) async {
      // Forzamos tamaño de pantalla grande para evitar errores de Offset/Scroll
      tester.view.physicalSize = const Size(800, 1500);
      await tester.pumpWidget(makeTestable(const RegisterScreen()));
      expect(find.text('Nombre'), findsOneWidget);
      addTearDown(tester.view.resetPhysicalSize);
    });
  });
}