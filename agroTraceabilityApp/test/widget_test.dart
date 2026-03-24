import 'package:agro_traceability/app/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('La app carga correctamente', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AgroTraceabilityApp()));

    expect(find.text('Iniciar sesión'), findsOneWidget);
  });
}
