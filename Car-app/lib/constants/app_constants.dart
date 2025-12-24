/// App Constants
/// Centralized constants for the AUTOFLUX car app
/// 
/// This file contains all magic numbers and strings used throughout the app
/// to improve maintainability and reduce errors.
class AppConstants {
  // Authentication & Access
  static const int minDrivingAge = 18; // Malaysia legal driving age
  static const int maxGuestAccessDays = 30;
  static const int minGuestAccessDays = 1;

  // Climate Controls
  static const double minTemperature = 16.0; // Celsius
  static const double maxTemperature = 30.0; // Celsius
  static const double defaultTemperature = 22.0; // Celsius
  static const int minFanSpeed = 0;
  static const int maxFanSpeed = 7;
  static const int minSeatHeatingLevel = 0;
  static const int maxSeatHeatingLevel = 3;

  // Charging
  static const double minBatteryLevel = 0.0; // 0%
  static const double maxBatteryLevel = 1.0; // 100%
  static const int minChargeLimit = 50; // Percentage
  static const int maxChargeLimit = 100; // Percentage
  static const int defaultChargeLimit = 80; // Percentage

  // Car Controls
  static const double minWindowPosition = 0.0; // 0%
  static const double maxWindowPosition = 100.0; // 100%
  static const double minSunroofPosition = 0.0; // 0%
  static const double maxSunroofPosition = 100.0; // 100%

  // Media
  static const double minVolume = 0.0; // 0%
  static const double maxVolume = 100.0; // 100%
  static const double defaultVolume = 50.0; // 50%

  // Predictive Maintenance
  static const double minEngineTemp = 0.0; // Celsius
  static const double maxEngineTemp = 120.0; // Celsius
  static const double normalEngineTemp = 90.0; // Celsius
  static const double minBatteryHealth = 0.0; // Percentage
  static const double maxBatteryHealth = 100.0; // Percentage
  static const double minTirePressure = 25.0; // PSI
  static const double maxTirePressure = 45.0; // PSI
  static const double normalTirePressure = 35.0; // PSI

  // Timing & Delays
  static const Duration scanDelay = Duration(seconds: 2);
  static const Duration emergencyCallDelay = Duration(seconds: 3);
  static const Duration emergencyContactDelay = Duration(seconds: 1);
  static const Duration snackbarDuration = Duration(seconds: 2);
  static const Duration longSnackbarDuration = Duration(seconds: 4);

  // Location
  static const double defaultLocationAccuracy = 0.000001; // 6 decimal places
  static const Duration locationUpdateInterval = Duration(seconds: 30);

  // UI
  static const double defaultBorderRadius = 16.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 24.0;
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  // Validation
  static const int minMyKadLength = 12; // YYMMDD-PP-NNNN format
  static const int maxMyKadLength = 14; // With dashes
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int minPhoneLength = 10;
  static const int maxPhoneLength = 15;

  // Error Messages
  static const String errorInvalidMyKad = 'Invalid MyKAD number format';
  static const String errorUnderage = 'Must be 18 years or older to drive';
  static const String errorStorageFailure = 'Failed to save data';
  static const String errorNetworkFailure = 'Network connection failed';
  static const String errorLocationPermission = 'Location permission denied';
  static const String errorLocationService = 'Location services disabled';

  // Success Messages
  static const String successRegistration = 'Registration successful';
  static const String successGuestAccessCreated = 'Guest access created';
  static const String successDataSaved = 'Data saved successfully';

  // App Info
  static const String appName = 'AUTOFLUX';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
}

