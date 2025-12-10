import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

/// Location Service
/// Handles GPS location tracking and permissions
class LocationService {
  static Position? _lastKnownPosition;

  /// Request location permissions
  static Future<bool> requestLocationPermission() async {
    try {
      final status = await Permission.location.request();
      return status.isGranted;
    } catch (e) {
      print('Error requesting location permission: $e');
      return false;
    }
  }

  /// Check if location services are enabled
  static Future<bool> isLocationEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      print('Error checking location service: $e');
      return false;
    }
  }

  /// Get current location
  static Future<Position?> getCurrentLocation() async {
    try {
      // Check if location service is enabled
      bool serviceEnabled = await isLocationEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled');
        return null;
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied');
        return null;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _lastKnownPosition = position;
      return position;
    } catch (e) {
      print('Error getting current location: $e');
      return _lastKnownPosition;
    }
  }

  /// Start location tracking
  static Future<void> startTracking() async {
    try {
      // This would start continuous location updates
      // For now, we just get the current location
      await getCurrentLocation();
    } catch (e) {
      print('Error starting location tracking: $e');
    }
  }

  /// Stop location tracking
  static void stopTracking() {
    // Stop any active location streams
    print('Location tracking stopped');
  }

  /// Format coordinates for display
  static String formatCoordinates(Position position) {
    return '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
  }

  /// Get Google Maps URL for location
  static String getGoogleMapsUrl(Position position) {
    return 'https://www.google.com/maps?q=${position.latitude},${position.longitude}';
  }

  /// Calculate distance between two positions (in meters)
  static double calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }
}
