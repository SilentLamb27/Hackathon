import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/emergency_contact.dart';
import '../models/guest_access.dart';
import '../models/registered_kad.dart';

/// Storage Service
/// Handles persistent data storage using SharedPreferences
class StorageService {
  static const String _emergencyContactsKey = 'emergency_contacts';
  static const String _registeredKadsKey = 'registered_kads';
  static const String _guestAccessesKey = 'guest_accesses';
  static const String _carOwnerKadKey = 'car_owner_kad';

  // Emergency Contacts
  static Future<List<EmergencyContact>> loadEmergencyContacts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_emergencyContactsKey);
      if (jsonString == null) return [];

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => EmergencyContact.fromJson(json)).toList();
    } catch (e) {
      print('Error loading emergency contacts: $e');
      return [];
    }
  }

  static Future<void> saveEmergencyContacts(
    List<EmergencyContact> contacts,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(contacts.map((c) => c.toJson()).toList());
      await prefs.setString(_emergencyContactsKey, jsonString);
    } catch (e) {
      print('Error saving emergency contacts: $e');
    }
  }

  // Registered MyKADs
  static Future<List<RegisteredKad>> loadRegisteredKads() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_registeredKadsKey);
      if (jsonString == null) return [];

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => RegisteredKad.fromJson(json)).toList();
    } catch (e) {
      print('Error loading registered KADs: $e');
      return [];
    }
  }

  static Future<void> saveRegisteredKads(List<RegisteredKad> kads) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(kads.map((k) => k.toJson()).toList());
      await prefs.setString(_registeredKadsKey, jsonString);
    } catch (e) {
      print('Error saving registered KADs: $e');
    }
  }

  // Guest Accesses
  static Future<List<GuestAccess>> loadGuestAccesses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_guestAccessesKey);
      if (jsonString == null) return [];

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => GuestAccess.fromJson(json)).toList();
    } catch (e) {
      print('Error loading guest accesses: $e');
      return [];
    }
  }

  static Future<void> saveGuestAccesses(List<GuestAccess> accesses) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(accesses.map((a) => a.toJson()).toList());
      await prefs.setString(_guestAccessesKey, jsonString);
    } catch (e) {
      print('Error saving guest accesses: $e');
    }
  }

  // Car Owner KAD
  static Future<String?> getCarOwnerKad() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_carOwnerKadKey);
    } catch (e) {
      print('Error getting car owner KAD: $e');
      return null;
    }
  }

  static Future<void> setCarOwnerKad(String kadNumber) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_carOwnerKadKey, kadNumber);
    } catch (e) {
      print('Error setting car owner KAD: $e');
    }
  }

  // Clear all data
  static Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      print('Error clearing data: $e');
    }
  }
}
