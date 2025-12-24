import 'package:flutter_test/flutter_test.dart';
import 'package:car_app/models/registered_kad.dart';

void main() {
  group('RegisteredKad Model Tests', () {
    test('extracts date of birth correctly from MyKAD number', () {
      // Test 1995 birth year
      final dob1 = RegisteredKad.extractDateOfBirth('950123-01-5678');
      expect(dob1, isNotNull);
      expect(dob1?.year, 1995);
      expect(dob1?.month, 1);
      expect(dob1?.day, 23);

      // Test 2001 birth year
      final dob2 = RegisteredKad.extractDateOfBirth('010515-10-1234');
      expect(dob2, isNotNull);
      expect(dob2?.year, 2001);
      expect(dob2?.month, 5);
      expect(dob2?.day, 15);
    });

    test('returns null for invalid MyKAD format', () {
      expect(RegisteredKad.extractDateOfBirth('invalid'), isNull);
      expect(RegisteredKad.extractDateOfBirth('123'), isNull);
      expect(RegisteredKad.extractDateOfBirth(''), isNull);
    });

    test('calculates age correctly', () {
      final birthDate = DateTime(1995, 1, 23);
      final kad = RegisteredKad(
        kadNumber: '950123-01-5678',
        ownerName: 'Test User',
        dateOfBirth: birthDate,
        firstRegistered: DateTime.now(),
        lastAccessed: DateTime.now(),
        isOwner: true,
      );

      final expectedAge = DateTime.now().year - 1995;
      // Account for birthday not yet occurred this year
      final actualAge = kad.age;
      expect(actualAge, greaterThanOrEqualTo(expectedAge - 1));
      expect(actualAge, lessThanOrEqualTo(expectedAge));
    });

    test('isEligibleToDrive returns true for 18+', () {
      final kad = RegisteredKad(
        kadNumber: '950123-01-5678',
        ownerName: 'Test User',
        dateOfBirth: DateTime(1995, 1, 23), // Over 18
        firstRegistered: DateTime.now(),
        lastAccessed: DateTime.now(),
        isOwner: true,
      );

      expect(kad.isEligibleToDrive, true);
    });

    test('isEligibleToDrive returns false for under 18', () {
      final kad = RegisteredKad(
        kadNumber: '100101-01-1234',
        ownerName: 'Test User',
        dateOfBirth: DateTime(2010, 1, 1), // Under 18
        firstRegistered: DateTime.now(),
        lastAccessed: DateTime.now(),
        isOwner: false,
      );

      expect(kad.isEligibleToDrive, false);
    });

    test('toJson and fromJson work correctly', () {
      final kad = RegisteredKad(
        kadNumber: '950123-01-5678',
        ownerName: 'Test User',
        dateOfBirth: DateTime(1995, 1, 23),
        firstRegistered: DateTime(2020, 1, 1),
        lastAccessed: DateTime(2024, 1, 1),
        isOwner: true,
        accessCount: 5,
      );

      final json = kad.toJson();
      final restored = RegisteredKad.fromJson(json);

      expect(restored.kadNumber, kad.kadNumber);
      expect(restored.ownerName, kad.ownerName);
      expect(restored.dateOfBirth, kad.dateOfBirth);
      expect(restored.isOwner, kad.isOwner);
      expect(restored.accessCount, kad.accessCount);
    });

    test('copyWith creates new instance with updated fields', () {
      final original = RegisteredKad(
        kadNumber: '950123-01-5678',
        ownerName: 'Original Name',
        dateOfBirth: DateTime(1995, 1, 23),
        firstRegistered: DateTime(2020, 1, 1),
        lastAccessed: DateTime(2024, 1, 1),
        isOwner: false,
        accessCount: 1,
      );

      final updated = original.copyWith(
        ownerName: 'Updated Name',
        accessCount: 10,
      );

      expect(updated.ownerName, 'Updated Name');
      expect(updated.accessCount, 10);
      expect(updated.kadNumber, original.kadNumber);
      expect(updated.dateOfBirth, original.dateOfBirth);
    });
  });
}

