import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:car_app/providers/car_provider.dart';

void main() {
  group('CarProvider Registration & Auth', () {
    setUp(() async {
      // Ensure SharedPreferences uses an in-memory mock for tests
      SharedPreferences.setMockInitialValues({});
    });

    test('register owner and authenticate via scan', () async {
      final provider = CarProvider();
      await provider.initialize();

      final kad = '950123-01-5678';

      await provider.registerKad(kadNumber: kad, name: 'Alice', isOwner: true);

      expect(provider.isKadRegistered(kad), true);
      expect(provider.isKadOwner(kad), true);
      expect(provider.currentUserKad, kad);
      expect(provider.isAuthenticated, true);

      // Logout then scan again
      provider.logout();
      expect(provider.isAuthenticated, false);

      final scanned = await provider.scanMyKad(mockKadNumber: kad);
      expect(scanned, true);
      expect(provider.isAuthenticated, true);
    });

    test('duplicate registration throws', () async {
      final provider = CarProvider();
      await provider.initialize();

      final kad = '950123-01-5678';
      await provider.registerKad(kadNumber: kad, name: 'Alice', isOwner: false);

      expect(
        () async => await provider.registerKad(
          kadNumber: kad,
          name: 'Alice',
          isOwner: false,
        ),
        throwsException,
      );
    });

    test('transfer owner requires registered target', () async {
      final provider = CarProvider();
      await provider.initialize();

      final owner = '950123-01-5678';
      final other = '010101-01-0001';

      await provider.registerKad(
        kadNumber: owner,
        name: 'Owner',
        isOwner: true,
      );
      // Attempting to transfer to unregistered KAD should throw
      expect(() async => await provider.transferOwner(other), throwsException);

      // Register the other and then transfer
      await provider.registerKad(
        kadNumber: other,
        name: 'Other',
        isOwner: false,
      );
      await provider.transferOwner(other);
      expect(provider.isKadOwner(other), true);
      expect(provider.isKadOwner(owner), false);
    });
  });
}
