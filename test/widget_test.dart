import 'package:flutter_test/flutter_test.dart';
import 'package:sumaq_ruta_ai/main.dart';

void main() {
  testWidgets('shows welcome landing screen', (WidgetTester tester) async {
    await tester.pumpWidget(const SumaqRutaApp());

    expect(find.text('SUMAQ IA'), findsOneWidget);
    expect(
      find.text('Impulsa el turismo gastronómico boliviano con IA'),
      findsOneWidget,
    );
    expect(find.text('¿Qué es SUMAQ IA?'), findsOneWidget);
    expect(find.text('Explora experiencias gastronómicas'), findsOneWidget);
    expect(find.text('¿Cómo ayuda Gemini en SUMAQ IA?'), findsOneWidget);
    expect(find.text('Impacto esperado'), findsOneWidget);
  });
}
