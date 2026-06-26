import 'package:flutter_test/flutter_test.dart';
import 'package:sumaq_ruta_ai/main.dart';

void main() {
  testWidgets('shows login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const SumaqRutaApp());

    expect(find.text('Sumaq Ruta AI'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Crear cuenta'), findsOneWidget);
  });
}
