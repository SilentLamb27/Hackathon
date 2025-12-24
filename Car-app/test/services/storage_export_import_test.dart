import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:car_app/services/storage_service.dart';
import 'package:car_app/models/registered_kad.dart';
import 'package:car_app/models/emergency_contact.dart';
import 'package:car_app/models/guest_access.dart';

void main() {
  test('export and import data round-trip', () async {
    SharedPreferences.setMockInitialValues({});

    // Prepare some data
    final contact = EmergencyContact(id: 'c1', name: 'John', phone: '0123456789', relationship: 'Friend');
    final kad = RegisteredKad(
      kadNumber: '950123-01-5678',
      ownerName: 'Alice',
      dateOfBirth: DateTime(1995, 1, 23),
      firstRegistered: DateTime.now(),
      lastAccessed: DateTime.now(),
      isOwner: true,
      accessCount: 2,
    );
    final guest = GuestAccess(
      id: 'g1',
      guestName: 'Bob',
      qrCode: 'qr1',
      expiryTime: DateTime.now().add(const Duration(days: 7)),
      allowedFeatures: [],
      isActive: true,
    );

    await StorageService.saveEmergencyContacts([contact]);
    await StorageService.saveRegisteredKads([kad]);
    await StorageService.saveGuestAccesses([guest]);
    await StorageService.setCarOwnerKad(kad.kadNumber);

    final exported = await StorageService.exportAllDataJson();
    expect(exported, isNotNull);

    // Clear storage
    await StorageService.clearAllData();

    // Import back
    final result = await StorageService.importAllDataFromJson(exported);
    expect(result, isA<StorageSuccess<void>>());

    final loadedKads = await StorageService.loadRegisteredKads();
    final loadedContacts = await StorageService.loadEmergencyContacts();
    final loadedGuests = await StorageService.loadGuestAccesses();
    final owner = await StorageService.getCarOwnerKad();

    expect(loadedKads.length, 1);
    expect(loadedContacts.length, 1);
    expect(loadedGuests.length, 1);
    expect(owner, kad.kadNumber);
  });
}
