import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:car_app/providers/car_provider.dart';
import 'package:car_app/screens/lock_screen.dart';

void main() {
  testWidgets(
    'LockScreen owner registration flow registers owner and shows welcome dialog',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      // Mock flutter_secure_storage platform channel to avoid platform calls in tests
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
          child: const MaterialApp(home: LockScreen()),
        ),
      );

      // Verify initial state shows register button when no owner
      expect(find.text('REGISTER AS OWNER'), findsOneWidget);

      // Tap register button (ensure visible first)
      final registerFinder = find.text('REGISTER AS OWNER');
      await tester.ensureVisible(registerFinder);
      await tester.tap(registerFinder);
      await tester.pump();

      // Advance time to allow async registration flow (2s scan + 1s delay + dialogs)
      await tester.pump(const Duration(seconds: 4));
      // Give additional time for dialogs/navigation to update without waiting for repeating animations
      await tester.pump(const Duration(seconds: 2));

      // Provider should now be authenticated and have a registered KAD
      expect(provider.isAuthenticated, isTrue);
      expect(provider.registeredKads.isNotEmpty, isTrue);

      // Welcome dialog should be visible
      expect(find.text('Welcome!'), findsOneWidget);
    },
  );
}
