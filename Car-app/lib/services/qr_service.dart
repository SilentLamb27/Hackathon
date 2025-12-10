import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../models/guest_access.dart';

/// QR Service
/// Handles QR code generation and validation for guest access
class QrService {
  static const _uuid = Uuid();

  /// Generate a guest access QR code
  static String generateGuestAccessQr({
    required String guestName,
    required DateTime expiryTime,
    required List<String> allowedFeatures,
  }) {
    final id = _uuid.v4();
    final now = DateTime.now();

    final data = {
      'id': id,
      'guestName': guestName,
      'createdAt': now.toIso8601String(),
      'expiryTime': expiryTime.toIso8601String(),
      'allowedFeatures': allowedFeatures,
      'type': 'guest_access',
    };

    // Convert to JSON string for QR code
    return json.encode(data);
  }

  /// Validate and parse QR code data
  static GuestAccess? validateQrCode(String qrData) {
    try {
      final Map<String, dynamic> data = json.decode(qrData);

      // Validate QR code type
      if (data['type'] != 'guest_access') {
        print('Invalid QR code type');
        return null;
      }

      // Parse the data
      final access = GuestAccess(
        id: data['id'] as String,
        guestName: data['guestName'] as String,
        createdAt: DateTime.parse(data['createdAt'] as String),
        expiryTime: DateTime.parse(data['expiryTime'] as String),
        allowedFeatures: List<String>.from(data['allowedFeatures'] as List),
        qrCode: qrData,
        isActive: true,
      );

      // Check if expired
      if (access.isExpired) {
        print('Guest access has expired');
        return null;
      }

      return access;
    } catch (e) {
      print('Error validating QR code: $e');
      return null;
    }
  }

  /// Generate a shareable guest access link
  static String generateShareableLink(GuestAccess access) {
    // In a real app, this would be a deep link to your app
    return 'carapp://guest?id=${access.id}&name=${Uri.encodeComponent(access.guestName)}';
  }

  /// Check if guest access has specific feature permission
  static bool hasFeaturePermission(GuestAccess access, String featureName) {
    return access.allowedFeatures.contains(featureName);
  }

  /// Get all available features for guest access
  static List<String> getAllFeatures() {
    return [
      'unlock',
      'lock',
      'climate',
      'horn',
      'lights',
      'trunk',
      'charging',
      'location',
    ];
  }

  /// Get feature display name
  static String getFeatureDisplayName(String feature) {
    switch (feature) {
      case 'unlock':
        return 'Unlock Doors';
      case 'lock':
        return 'Lock Doors';
      case 'climate':
        return 'Climate Control';
      case 'horn':
        return 'Horn & Flash';
      case 'lights':
        return 'Lights';
      case 'trunk':
        return 'Trunk Access';
      case 'charging':
        return 'Charging Control';
      case 'location':
        return 'GPS Location';
      default:
        return feature;
    }
  }
}
