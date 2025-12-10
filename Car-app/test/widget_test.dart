import 'package:flutter_test/flutter_test.dart';
import 'package:car_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CarApp());

    // Verify that the dashboard shows up
    expect(find.text('SU7 CONTROL'), findsOneWidget);
  });
}
