import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/emergency_contact.dart';
import '../models/guest_access.dart';
import '../models/registered_kad.dart';

/// Storage Service
/// Handles persistent data storage using SharedPreferences
///
/// All methods include proper error handling and return safe defaults
/// on failure to prevent app crashes.
// Result type for storage operations
abstract class StorageResult<T> {}

class StorageSuccess<T> extends StorageResult<T> {
  final T data;
  StorageSuccess(this.data);
}

class StorageFailure<T> extends StorageResult<T> {
  final String message;
  StorageFailure(this.message);
}

class StorageService {
  static const String _emergencyContactsKey = 'emergency_contacts';
  static const String _registeredKadsKey = 'registered_kads';
  static const String _guestAccessesKey = 'guest_accesses';
  static const String _carOwnerKadKey = 'car_owner_kad';
  // Secure storage instance for sensitive data
  static const _secureStorage = FlutterSecureStorage();

  // Emergency Contacts
  static Future<List<EmergencyContact>> loadEmergencyContacts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_emergencyContactsKey);
      if (jsonString == null || jsonString.isEmpty) return [];

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => EmergencyContact.fromJson(json)).toList();
    } on FormatException catch (e) {
      // Corrupted data - clear and return empty
      await _clearKey(_emergencyContactsKey);
      return [];
    } catch (e) {
      // Log error but don't crash the app
      return [];
    }
  }

  static Future<StorageResult<void>> saveEmergencyContacts(
    List<EmergencyContact> contacts,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(contacts.map((c) => c.toJson()).toList());
      final success = await prefs.setString(_emergencyContactsKey, jsonString);
      if (success) {
        return StorageSuccess<void>(null);
      } else {
        return StorageFailure<void>('Failed to save emergency contacts');
      }
    } catch (e) {
      return StorageFailure<void>(
        'Error saving emergency contacts: ${e.toString()}',
      );
    }
  }

  // Registered MyKADs
  static Future<List<RegisteredKad>> loadRegisteredKads() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_registeredKadsKey);
      if (jsonString == null || jsonString.isEmpty) return [];

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => RegisteredKad.fromJson(json)).toList();
    } on FormatException catch (e) {
      // Corrupted data - clear and return empty
      await _clearKey(_registeredKadsKey);
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<StorageResult<void>> saveRegisteredKads(
    List<RegisteredKad> kads,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(kads.map((k) => k.toJson()).toList());
      final success = await prefs.setString(_registeredKadsKey, jsonString);
      if (success) {
        return StorageSuccess<void>(null);
      } else {
        return StorageFailure<void>('Failed to save registered KADs');
      }
    } catch (e) {
      return StorageFailure<void>(
        'Error saving registered KADs: ${e.toString()}',
      );
    }
  }

  // Guest Accesses
  static Future<List<GuestAccess>> loadGuestAccesses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_guestAccessesKey);
      if (jsonString == null || jsonString.isEmpty) return [];

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => GuestAccess.fromJson(json)).toList();
    } on FormatException catch (e) {
      // Corrupted data - clear and return empty
      await _clearKey(_guestAccessesKey);
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<StorageResult<void>> saveGuestAccesses(
    List<GuestAccess> accesses,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(accesses.map((a) => a.toJson()).toList());
      final success = await prefs.setString(_guestAccessesKey, jsonString);
      if (success) {
        return StorageSuccess<void>(null);
      } else {
        return StorageFailure<void>('Failed to save guest accesses');
      }
    } catch (e) {
      return StorageFailure<void>(
        'Error saving guest accesses: ${e.toString()}',
      );
    }
  }

  // Car Owner KAD
  static Future<String?> getCarOwnerKad() async {
    try {
      // Prefer secure storage for owner KAD
      final secureValue = await _secureStorage.read(key: _carOwnerKadKey);
      if (secureValue != null && secureValue.isNotEmpty) return secureValue;

      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_carOwnerKadKey);
    } catch (e) {
      return null;
    }
  }

  static Future<StorageResult<void>> setCarOwnerKad(String kadNumber) async {
    try {
      // Save owner KAD in secure storage first
      await _secureStorage.write(key: _carOwnerKadKey, value: kadNumber);
      // Also persist to SharedPreferences for compatibility
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.setString(_carOwnerKadKey, kadNumber);
      if (success) {
        return StorageSuccess<void>(null);
      } else {
        return StorageFailure<void>('Failed to save car owner KAD');
      }
    } catch (e) {
      return StorageFailure<void>(
        'Error setting car owner KAD: ${e.toString()}',
      );
    }
  }

  // Clear all data
  static Future<StorageResult<void>> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.clear();
      if (success) {
        return StorageSuccess<void>(null);
      } else {
        return StorageFailure<void>('Failed to clear all data');
      }
    } catch (e) {
      return StorageFailure<void>('Error clearing data: ${e.toString()}');
    }
  }

  /// Export all stored data as a JSON string for backup/export purposes.
  static Future<String> exportAllDataJson() async {
    final emergency = await loadEmergencyContacts();
    final kads = await loadRegisteredKads();
    final guests = await loadGuestAccesses();
    final owner = await getCarOwnerKad();

    final data = {
      _emergencyContactsKey: emergency.map((e) => e.toJson()).toList(),
      _registeredKadsKey: kads.map((k) => k.toJson()).toList(),
      _guestAccessesKey: guests.map((g) => g.toJson()).toList(),
      _carOwnerKadKey: owner,
    };

    return json.encode(data);
  }

  /// Import data from a JSON string. This will overwrite existing keys present
  /// in the payload. Returns StorageResult indicating success/failure.
  static Future<StorageResult<void>> importAllDataFromJson(
    String jsonString,
  ) async {
    try {
      final Map<String, dynamic> obj = json.decode(jsonString);

      // Emergency contacts
      if (obj.containsKey(_emergencyContactsKey)) {
        final List<dynamic> list = obj[_emergencyContactsKey] as List<dynamic>;
        final contacts = list.map((j) => EmergencyContact.fromJson(j)).toList();
        await saveEmergencyContacts(contacts);
      }

      // Registered KADs
      if (obj.containsKey(_registeredKadsKey)) {
        final List<dynamic> list = obj[_registeredKadsKey] as List<dynamic>;
        final kads = list.map((j) => RegisteredKad.fromJson(j)).toList();
        await saveRegisteredKads(kads);
      }

      // Guest accesses
      if (obj.containsKey(_guestAccessesKey)) {
        final List<dynamic> list = obj[_guestAccessesKey] as List<dynamic>;
        final accesses = list.map((j) => GuestAccess.fromJson(j)).toList();
        await saveGuestAccesses(accesses);
      }

      // Owner KAD (secure)
      if (obj.containsKey(_carOwnerKadKey)) {
        final owner = obj[_carOwnerKadKey] as String?;
        if (owner != null) {
          await setCarOwnerKad(owner);
        }
      }

      return StorageSuccess<void>(null);
    } on FormatException catch (e) {
      return StorageFailure<void>('Invalid JSON format: ${e.toString()}');
    } catch (e) {
      return StorageFailure<void>('Import failed: ${e.toString()}');
    }
  }

  /// Helper method to clear a specific key safely
  static Future<void> _clearKey(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    } catch (e) {
      // Ignore errors when clearing corrupted data
    }
  }
}
