import 'package:flutter_test/flutter_test.dart';
import 'package:car_app/providers/car_provider.dart';
import 'package:car_app/models/registered_kad.dart';
import 'package:car_app/models/emergency_contact.dart';
import 'package:car_app/constants/app_constants.dart';

void main() {
  group('CarProvider Tests', () {
    late CarProvider provider;

    setUp(() {
      provider = CarProvider();
    });

    test('initializes with locked and unauthenticated state', () {
      expect(provider.isLocked, true);
      expect(provider.isAuthenticated, false);
      expect(provider.accessType, AccessType.none);
    });

    test('grantOwnerAccess unlocks car and sets owner access', () {
      provider.grantOwnerAccess();
      
      expect(provider.isLocked, false);
      expect(provider.accessType, AccessType.owner);
      expect(provider.accessExpiry, isNull);
    });

    test('grantGuestAccess unlocks car and sets guest access with expiry', () {
      provider.grantGuestAccess(7);
      
      expect(provider.isLocked, false);
      expect(provider.accessType, AccessType.guest);
      expect(provider.accessExpiry, isNotNull);
    });

    test('toggleLock requires authentication', () {
      // Should not unlock if not authenticated
      provider.toggleLock();
      expect(provider.isLocked, true);
      
      // After authentication, should work
      provider.grantOwnerAccess();
      final wasLocked = provider.isLocked;
      provider.toggleLock();
      expect(provider.isLocked, !wasLocked);
    });

    test('setTemperature clamps values to valid range', () {
      provider.grantOwnerAccess();
      
      // Test below minimum
      provider.setTemperature(10.0);
      expect(provider.temperature, AppConstants.minTemperature);
      
      // Test above maximum
      provider.setTemperature(40.0);
      expect(provider.temperature, AppConstants.maxTemperature);
      
      // Test valid value
      provider.setTemperature(25.0);
      expect(provider.temperature, 25.0);
    });

    test('setFanSpeed clamps values to valid range', () {
      provider.grantOwnerAccess();
      
      // Test below minimum
      provider.setFanSpeed(-5);
      expect(provider.fanSpeed, AppConstants.minFanSpeed);
      
      // Test above maximum
      provider.setFanSpeed(10);
      expect(provider.fanSpeed, AppConstants.maxFanSpeed);
      
      // Test valid value
      provider.setFanSpeed(5);
      expect(provider.fanSpeed, 5);
    });

    test('setChargeLimit clamps values to valid range', () {
      provider.grantOwnerAccess();
      
      // Test below minimum
      provider.setChargeLimit(30);
      expect(provider.chargeLimit, AppConstants.minChargeLimit);
      
      // Test above maximum
      provider.setChargeLimit(150);
      expect(provider.chargeLimit, AppConstants.maxChargeLimit);
      
      // Test valid value
      provider.setChargeLimit(85);
      expect(provider.chargeLimit, 85);
    });

    test('setVolume clamps values to valid range', () {
      provider.grantOwnerAccess();
      
      // Test below minimum
      provider.setVolume(-10.0);
      expect(provider.volume, AppConstants.minVolume);
      
      // Test above maximum
      provider.setVolume(150.0);
      expect(provider.volume, AppConstants.maxVolume);
      
      // Test valid value
      provider.setVolume(75.0);
      expect(provider.volume, 75.0);
    });

    test('setWindowPosition clamps values and requires authentication', () {
      // Should not work without authentication
      provider.setWindowPosition('FL', 50.0);
      expect(provider.windowFL, AppConstants.minWindowPosition);
      
      provider.grantOwnerAccess();
      
      // Test valid value
      provider.setWindowPosition('FL', 50.0);
      expect(provider.windowFL, 50.0);
      
      // Test clamping
      provider.setWindowPosition('FL', 150.0);
      expect(provider.windowFL, AppConstants.maxWindowPosition);
      
      provider.setWindowPosition('FL', -10.0);
      expect(provider.windowFL, AppConstants.minWindowPosition);
    });

    test('closeAllWindows sets all windows to minimum', () {
      provider.grantOwnerAccess();
      
      // Open all windows first
      provider.openAllWindows();
      expect(provider.windowFL, AppConstants.maxWindowPosition);
      
      // Close all
      provider.closeAllWindows();
      expect(provider.windowFL, AppConstants.minWindowPosition);
      expect(provider.windowFR, AppConstants.minWindowPosition);
      expect(provider.windowRL, AppConstants.minWindowPosition);
      expect(provider.windowRR, AppConstants.minWindowPosition);
      expect(provider.windowsOpen, false);
    });

    test('toggleAutoClimate sets optimal climate settings', () {
      provider.grantOwnerAccess();
      
      provider.toggleAutoClimate();
      
      expect(provider.autoClimate, true);
      expect(provider.acOn, true);
      expect(provider.temperature, AppConstants.defaultTemperature);
      expect(provider.temperaturePassenger, AppConstants.defaultTemperature);
      expect(provider.fanSpeed, 3);
    });

    test('setSeatHeating and setSeatCooling are mutually exclusive', () {
      provider.grantOwnerAccess();
      
      // Set heating
      provider.setSeatHeating('driver', 2);
      expect(provider.seatHeatingDriver, 2);
      expect(provider.seatCoolingDriver, AppConstants.minSeatHeatingLevel);
      
      // Set cooling should turn off heating
      provider.setSeatCooling('driver', 2);
      expect(provider.seatCoolingDriver, 2);
      expect(provider.seatHeatingDriver, AppConstants.minSeatHeatingLevel);
    });

    test('nextTrack and previousTrack cycle through tracks', () {
      provider.grantOwnerAccess();
      
      final initialIndex = provider.currentTrackIndex;
      
      provider.nextTrack();
      expect(provider.currentTrackIndex, (initialIndex + 1) % provider.tracks.length);
      
      provider.previousTrack();
      expect(provider.currentTrackIndex, initialIndex);
    });

    test('nextRadioStation and previousRadioStation cycle through stations', () {
      provider.grantOwnerAccess();
      
      final initialIndex = provider.currentRadioStationIndex;
      
      provider.nextRadioStation();
      expect(
        provider.currentRadioStationIndex,
        (initialIndex + 1) % provider.radioStations.length,
      );
      
      provider.previousRadioStation();
      expect(provider.currentRadioStationIndex, initialIndex);
    });

    test('logout resets authentication state', () {
      provider.grantOwnerAccess();
      expect(provider.isAuthenticated, true);
      
      provider.logout();
      
      expect(provider.isAuthenticated, false);
      expect(provider.isLocked, true);
      expect(provider.accessType, AccessType.none);
      expect(provider.accessExpiry, isNull);
      expect(provider.currentUserKad, isNull);
    });
  });
}

