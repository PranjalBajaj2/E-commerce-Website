import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_ecommerce/main.dart';

void main() {
  testWidgets('Lumina app renders home screen with brand header', (WidgetTester tester) async {
    await tester.pumpWidget(const LuminaApp());
    await tester.pumpAndSettle();

    // Verify LUMINA brand header is rendered
    expect(find.text('LUMINA'), findsOneWidget);

    // Verify shop categories and new arrivals header
    expect(find.text('Shop by Category'), findsOneWidget);
    expect(find.text('New Arrivals'), findsOneWidget);
  });
}
