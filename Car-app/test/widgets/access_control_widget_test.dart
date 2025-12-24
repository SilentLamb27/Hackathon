import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:car_app/providers/car_provider.dart';
import 'package:car_app/screens/access_control_screen.dart';

void main() {
  testWidgets(
    'AccessControlScreen shows no KADs then updates after registration',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      // Mock flutter_secure_storage platform channel
      const MethodChannel secureChannel = MethodChannel(
        'plugins.it_nomads.com/flutter_secure_storage',
      );
      secureChannel.setMockMethodCallHandler((call) async {
        return null;
      });

      final provider = CarProvider();

      await tester.pumpWidget(
        ChangeNotifierProvider<CarProvider>.value(
          value: provider,
          child: const MaterialApp(home: AccessControlScreen()),
        ),
      );

      // Initially no KADs
      expect(find.text('No MyKADs registered yet'), findsOneWidget);

      // Register a KAD via provider
      await provider.registerKad(
        kadNumber: '950123-01-5678',
        name: 'Test Owner',
        // Register as non-owner to avoid secure storage write in tests
        isOwner: false,
      );

      // Rebuild UI
      await tester.pumpAndSettle();

      // The registered KAD should appear in the list
      expect(find.text('Test Owner'), findsOneWidget);
      // Non-owner icon should be displayed (person)
      expect(find.byIcon(Icons.person), findsWidgets);
    },
  );
}
