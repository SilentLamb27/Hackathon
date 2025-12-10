import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/emergency_contact.dart';
import '../models/guest_access.dart';
import '../models/registered_kad.dart';
import '../services/storage_service.dart';
import '../services/location_service.dart';
import '../services/qr_service.dart';

enum AccessType { owner, guest, none }

class CarProvider extends ChangeNotifier {
  // Car Lock & Access
  bool _isLocked = true;
  bool _isAuthenticated = false;
  AccessType _accessType = AccessType.none;
  DateTime? _accessExpiry;
  String? _currentUserKad;

  // Emergency
  bool _isEmergencyMode = false;
  String? _emergencyStatus;
  List<EmergencyContact> _emergencyContacts = [];

  // GPS
  Position? _currentLocation;
  bool _isTrackingLocation = false;

  // Registered MyKADs
  List<RegisteredKad> _registeredKads = [];
  String? _ownerKadNumber;

  // Guest Access
  List<GuestAccess> _guestAccesses = [];

  // Car Status Mock Data
  final double _batteryLevel = 0.85; // 85%
  final int _rangeKm = 420;
  final double _chargingRate = 50; // kW

  // Car Controls - Basic
  bool _acOn = false;
  double _temperature = 22.0; // Celsius
  bool _trunkOpen = false;
  bool _windowsOpen = false;
  bool _lightsOn = false;

  // Individual Doors (true = open, false = closed)
  bool _doorFL = false; // Front Left
  bool _doorFR = false; // Front Right
  bool _doorRL = false; // Rear Left
  bool _doorRR = false; // Rear Right

  // Individual Windows (0-100% open)
  double _windowFL = 0.0;
  double _windowFR = 0.0;
  double _windowRL = 0.0;
  double _windowRR = 0.0;

  // Sunroof & Frunk
  double _sunroofPosition = 0.0; // 0-100%
  bool _sunroofTilted = false;
  bool _frunkOpen = false;

  // Climate - Advanced
  int _fanSpeed = 0; // 0-7
  int _seatHeatingDriver = 0; // 0-3 (off, low, medium, high)
  int _seatHeatingPassenger = 0;
  int _seatCoolingDriver = 0; // 0-3
  int _seatCoolingPassenger = 0;
  double _temperaturePassenger = 22.0; // Zone control
  bool _autoClimate = false;

  // Lights - Advanced
  bool _headlightsOn = false;
  bool _fogLightsOn = false;
  bool _interiorLightsOn = false;
  bool _hazardsOn = false;

  // Tire Pressure (PSI)
  double _tirePressureFL = 35.0;
  double _tirePressureFR = 35.0;
  double _tirePressureRL = 35.0;
  double _tirePressureRR = 35.0;

  // Charging
  bool _isCharging = false;
  int _chargeLimit = 80; // Percentage
  int _odometer = 12543; // km

  // Getters - Basic
  bool get isLocked => _isLocked;
  bool get isAuthenticated => _isAuthenticated;
  AccessType get accessType => _accessType;
  DateTime? get accessExpiry => _accessExpiry;
  String? get currentUserKad => _currentUserKad;

  // Getters - Emergency
  bool get isEmergencyMode => _isEmergencyMode;
  String? get emergencyStatus => _emergencyStatus;
  List<EmergencyContact> get emergencyContacts => _emergencyContacts;

  // Getters - GPS
  Position? get currentLocation => _currentLocation;
  bool get isTrackingLocation => _isTrackingLocation;

  // Getters - Car Stats
  double get batteryLevel => _batteryLevel;
  int get rangeKm => _rangeKm;
  double get chargingRate => _chargingRate;

  // Getters - Registered KADs
  List<RegisteredKad> get registeredKads => _registeredKads;
  String? get ownerKadNumber => _ownerKadNumber;

  // Getters - Guest Access
  List<GuestAccess> get guestAccesses =>
      _guestAccesses.where((a) => a.isActive).toList();

  List<GuestAccess> get activeGuestAccesses =>
      _guestAccesses.where((a) => a.isActive && !a.isExpired).toList();

  List<GuestAccess> get guestAccessHistory => _guestAccesses;

  // Getters - Car Controls - Basic
  bool get acOn => _acOn;
  double get temperature => _temperature;
  bool get trunkOpen => _trunkOpen;
  bool get windowsOpen => _windowsOpen;
  bool get lightsOn => _lightsOn;

  // Getters - Individual Doors
  bool get doorFL => _doorFL;
  bool get doorFR => _doorFR;
  bool get doorRL => _doorRL;
  bool get doorRR => _doorRR;

  // Getters - Individual Windows
  double get windowFL => _windowFL;
  double get windowFR => _windowFR;
  double get windowRL => _windowRL;
  double get windowRR => _windowRR;

  // Getters - Sunroof & Frunk
  double get sunroofPosition => _sunroofPosition;
  bool get sunroofTilted => _sunroofTilted;
  bool get frunkOpen => _frunkOpen;

  // Getters - Advanced Climate
  int get fanSpeed => _fanSpeed;
  int get seatHeatingDriver => _seatHeatingDriver;
  int get seatHeatingPassenger => _seatHeatingPassenger;
  int get seatCoolingDriver => _seatCoolingDriver;
  int get seatCoolingPassenger => _seatCoolingPassenger;
  double get temperaturePassenger => _temperaturePassenger;
  bool get autoClimate => _autoClimate;

  // Getters - Advanced Lights
  bool get headlightsOn => _headlightsOn;
  bool get fogLightsOn => _fogLightsOn;
  bool get interiorLightsOn => _interiorLightsOn;
  bool get hazardsOn => _hazardsOn;

  // Getters - Tire Pressure
  double get tirePressureFL => _tirePressureFL;
  double get tirePressureFR => _tirePressureFR;
  double get tirePressureRL => _tirePressureRL;
  double get tirePressureRR => _tirePressureRR;

  // Getters - Charging
  bool get isCharging => _isCharging;
  int get chargeLimit => _chargeLimit;
  int get odometer => _odometer;

  // Initialize provider - load saved data
  Future<void> initialize() async {
    _emergencyContacts = await StorageService.loadEmergencyContacts();
    _registeredKads = await StorageService.loadRegisteredKads();
    _guestAccesses = await StorageService.loadGuestAccesses();
    _ownerKadNumber = await StorageService.getCarOwnerKad();

    // Start location tracking
    await _updateLocation();

    notifyListeners();
  }

  // ========== MyKAD SCANNING & REGISTRATION ==========

  /// Scan MyKAD and authenticate
  /// Returns true if scan successful, false otherwise
  Future<bool> scanMyKad({String? mockKadNumber, String? mockName}) async {
    // Simulate scanning network/hardware delay
    await Future.delayed(const Duration(seconds: 2));

    // In a real app, we would validate NFC data here
    // For demo, use mock data
    final kadNumber = mockKadNumber ?? '950123-01-5678';

    _currentUserKad = kadNumber;

    // Check if this KAD is registered
    final existingKad = _registeredKads.firstWhere(
      (kad) => kad.kadNumber == kadNumber,
      orElse: () => RegisteredKad(
        kadNumber: '',
        ownerName: '',
        firstRegistered: DateTime.now(),
        lastAccessed: DateTime.now(),
        isOwner: false,
      ),
    );

    if (existingKad.kadNumber.isEmpty) {
      // First time scanning this KAD - needs registration
      return false; // Caller should handle registration flow
    }

    // Update last accessed
    final updatedKad = existingKad.copyWith(
      lastAccessed: DateTime.now(),
      accessCount: existingKad.accessCount + 1,
    );

    _registeredKads = _registeredKads
        .map((k) => k.kadNumber == kadNumber ? updatedKad : k)
        .toList();

    await StorageService.saveRegisteredKads(_registeredKads);

    _isAuthenticated = true;
    notifyListeners();
    return true;
  }

  /// Register a new MyKAD with the car
  Future<void> registerKad({
    required String kadNumber,
    required String name,
    required bool isOwner,
  }) async {
    final kad = RegisteredKad(
      kadNumber: kadNumber,
      ownerName: name,
      firstRegistered: DateTime.now(),
      lastAccessed: DateTime.now(),
      isOwner: isOwner,
    );

    _registeredKads.add(kad);
    await StorageService.saveRegisteredKads(_registeredKads);

    // If this is the owner, save as car owner
    if (isOwner && _ownerKadNumber == null) {
      _ownerKadNumber = kadNumber;
      await StorageService.setCarOwnerKad(kadNumber);
    }

    _isAuthenticated = true;
    _currentUserKad = kadNumber;
    notifyListeners();
  }

  /// Check if a KAD is registered
  bool isKadRegistered(String kadNumber) {
    return _registeredKads.any((kad) => kad.kadNumber == kadNumber);
  }

  /// Check if a KAD is the owner
  bool isKadOwner(String kadNumber) {
    return kadNumber == _ownerKadNumber;
  }

  // ========== ACCESS CONTROL ==========

  void grantOwnerAccess() {
    _accessType = AccessType.owner;
    _accessExpiry = null; // No expiry for owner
    _isLocked = false;
    notifyListeners();
  }

  void grantGuestAccess(int days) {
    _accessType = AccessType.guest;
    _accessExpiry = DateTime.now().add(Duration(days: days));
    _isLocked = false;
    notifyListeners();
  }

  /// Generate QR code for guest access
  Future<GuestAccess> createGuestAccess({
    required String guestName,
    required int durationDays,
    List<String>? allowedFeatures,
  }) async {
    final expiryTime = DateTime.now().add(Duration(days: durationDays));
    final qrData = QrService.generateGuestAccessQr(
      guestName: guestName,
      expiryTime: expiryTime,
      allowedFeatures: allowedFeatures ?? QrService.getAllFeatures(),
    );

    final access = QrService.validateQrCode(qrData);
    if (access != null) {
      _guestAccesses.add(access);
      await StorageService.saveGuestAccesses(_guestAccesses);
      notifyListeners();
      return access;
    }

    throw Exception('Failed to create guest access');
  }

  /// Validate and authenticate using QR code
  Future<bool> authenticateWithQr(String qrData) async {
    final access = QrService.validateQrCode(qrData);
    if (access == null || access.isExpired) {
      return false;
    }

    // Check if access exists in our list
    final exists = _guestAccesses.any((a) => a.id == access.id);
    if (!exists) {
      _guestAccesses.add(access);
      await StorageService.saveGuestAccesses(_guestAccesses);
    }

    _isAuthenticated = true;
    _accessType = AccessType.guest;
    _accessExpiry = access.expiryTime;
    _currentUserKad = access.guestName;
    notifyListeners();

    return true;
  }

  /// Revoke guest access
  Future<void> revokeGuestAccess(String accessId) async {
    _guestAccesses.removeWhere((a) => a.id == accessId);
    await StorageService.saveGuestAccesses(_guestAccesses);
    notifyListeners();
  }

  void toggleLock() {
    if (_isAuthenticated) {
      _isLocked = !_isLocked;
      notifyListeners();
    }
  }

  // ========== EMERGENCY FEATURES ==========

  /// Add emergency contact
  Future<void> addEmergencyContact(EmergencyContact contact) async {
    _emergencyContacts.add(contact);
    await StorageService.saveEmergencyContacts(_emergencyContacts);
    notifyListeners();
  }

  /// Update emergency contact
  Future<void> updateEmergencyContact(EmergencyContact contact) async {
    _emergencyContacts = _emergencyContacts
        .map((c) => c.id == contact.id ? contact : c)
        .toList();
    await StorageService.saveEmergencyContacts(_emergencyContacts);
    notifyListeners();
  }

  /// Delete emergency contact
  Future<void> deleteEmergencyContact(String contactId) async {
    _emergencyContacts.removeWhere((c) => c.id == contactId);
    await StorageService.saveEmergencyContacts(_emergencyContacts);
    notifyListeners();
  }

  /// Trigger accident/emergency mode
  void triggerAccident() {
    _isEmergencyMode = true;
    _emergencyStatus = "Detecting Impact...";
    notifyListeners();

    _simulateEmergencySequence();
  }

  void _simulateEmergencySequence() async {
    await Future.delayed(const Duration(seconds: 2));
    _emergencyStatus = "Contacting Police (999)...";
    notifyListeners();

    await Future.delayed(const Duration(seconds: 3));
    _emergencyStatus = "Dispatching Ambulance...";
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));
    _emergencyStatus = "Notifying Emergency Contacts...";
    notifyListeners();

    // Notify each contact
    for (var contact in _emergencyContacts) {
      await Future.delayed(const Duration(seconds: 1));
      _emergencyStatus = "Called ${contact.name} (${contact.relationship})";
      notifyListeners();
    }

    await Future.delayed(const Duration(seconds: 2));
    final location = await LocationService.getCurrentLocation();
    if (location != null) {
      _currentLocation = location;
      _emergencyStatus =
          "GPS Shared: ${LocationService.formatCoordinates(location)}";
    } else {
      _emergencyStatus = "GPS Location Shared";
    }
    notifyListeners();
  }

  void cancelEmergency() {
    _isEmergencyMode = false;
    _emergencyStatus = null;
    notifyListeners();
  }

  // ========== GPS & LOCATION ==========

  Future<void> _updateLocation() async {
    _currentLocation = await LocationService.getCurrentLocation();
    notifyListeners();
  }

  Future<void> startLocationTracking() async {
    _isTrackingLocation = true;
    await LocationService.startTracking();
    await _updateLocation();
    notifyListeners();
  }

  void stopLocationTracking() {
    _isTrackingLocation = false;
    LocationService.stopTracking();
    notifyListeners();
  }

  Future<void> refreshLocation() async {
    await _updateLocation();
  }

  // ========== CAR CONTROLS ==========

  void toggleAC() {
    _acOn = !_acOn;
    notifyListeners();
  }

  void setTemperature(double temp) {
    _temperature = temp.clamp(16.0, 30.0);
    notifyListeners();
  }

  void increaseTemperature() {
    setTemperature(_temperature + 0.5);
  }

  void decreaseTemperature() {
    setTemperature(_temperature - 0.5);
  }

  void toggleTrunk() {
    if (_isAuthenticated && !_isLocked) {
      _trunkOpen = !_trunkOpen;
      notifyListeners();
    }
  }

  void toggleWindows() {
    if (_isAuthenticated && !_isLocked) {
      _windowsOpen = !_windowsOpen;
      notifyListeners();
    }
  }

  void toggleLights() {
    if (_isAuthenticated) {
      _lightsOn = !_lightsOn;
      notifyListeners();
    }
  }

  void honkHorn() {
    // Simulate horn (in real app would trigger sound)
    // Visual feedback will be handled in UI
  }

  // ========== GRANULAR CONTROLS ==========

  // Individual Door Controls
  void toggleDoor(String position) {
    if (!_isAuthenticated || _isLocked) return;

    switch (position) {
      case 'FL':
        _doorFL = !_doorFL;
        break;
      case 'FR':
        _doorFR = !_doorFR;
        break;
      case 'RL':
        _doorRL = !_doorRL;
        break;
      case 'RR':
        _doorRR = !_doorRR;
        break;
    }
    notifyListeners();
  }

  void closeAllDoors() {
    if (!_isAuthenticated) return;
    _doorFL = _doorFR = _doorRL = _doorRR = false;
    notifyListeners();
  }

  // Individual Window Controls
  void setWindowPosition(String position, double percentage) {
    if (!_isAuthenticated || _isLocked) return;

    final value = percentage.clamp(0.0, 100.0);
    switch (position) {
      case 'FL':
        _windowFL = value;
        break;
      case 'FR':
        _windowFR = value;
        break;
      case 'RL':
        _windowRL = value;
        break;
      case 'RR':
        _windowRR = value;
        break;
    }
    notifyListeners();
  }

  void closeAllWindows() {
    if (!_isAuthenticated) return;
    _windowFL = _windowFR = _windowRL = _windowRR = 0.0;
    _windowsOpen = false;
    notifyListeners();
  }

  void openAllWindows() {
    if (!_isAuthenticated || _isLocked) return;
    _windowFL = _windowFR = _windowRL = _windowRR = 100.0;
    _windowsOpen = true;
    notifyListeners();
  }

  // Sunroof Controls
  void setSunroofPosition(double percentage) {
    if (!_isAuthenticated || _isLocked) return;
    _sunroofPosition = percentage.clamp(0.0, 100.0);
    notifyListeners();
  }

  void toggleSunroofTilt() {
    if (!_isAuthenticated || _isLocked) return;
    _sunroofTilted = !_sunroofTilted;
    if (_sunroofTilted) {
      _sunroofPosition = 0; // Can't slide when tilted
    }
    notifyListeners();
  }

  // Frunk Control
  void toggleFrunk() {
    if (!_isAuthenticated || _isLocked) return;
    _frunkOpen = !_frunkOpen;
    notifyListeners();
  }

  // Advanced Climate Controls
  void setFanSpeed(int speed) {
    _fanSpeed = speed.clamp(0, 7);
    if (_fanSpeed > 0 && !_acOn) {
      _acOn = true;
    }
    notifyListeners();
  }

  void setSeatHeating(String seat, int level) {
    final value = level.clamp(0, 3);
    if (seat == 'driver') {
      _seatHeatingDriver = value;
      if (value > 0) _seatCoolingDriver = 0; // Can't heat and cool
    } else {
      _seatHeatingPassenger = value;
      if (value > 0) _seatCoolingPassenger = 0;
    }
    notifyListeners();
  }

  void setSeatCooling(String seat, int level) {
    final value = level.clamp(0, 3);
    if (seat == 'driver') {
      _seatCoolingDriver = value;
      if (value > 0) _seatHeatingDriver = 0; // Can't heat and cool
    } else {
      _seatCoolingPassenger = value;
      if (value > 0) _seatHeatingPassenger = 0;
    }
    notifyListeners();
  }

  void setPassengerTemperature(double temp) {
    _temperaturePassenger = temp.clamp(16.0, 30.0);
    notifyListeners();
  }

  void toggleAutoClimate() {
    _autoClimate = !_autoClimate;
    if (_autoClimate) {
      // Auto mode sets optimal settings
      _acOn = true;
      _fanSpeed = 3;
      _temperature = 22.0;
      _temperaturePassenger = 22.0;
    }
    notifyListeners();
  }

  // Advanced Lights Controls
  void toggleHeadlights() {
    if (_isAuthenticated) {
      _headlightsOn = !_headlightsOn;
      _lightsOn = _headlightsOn; // Keep compatibility
      notifyListeners();
    }
  }

  void toggleFogLights() {
    if (_isAuthenticated) {
      _fogLightsOn = !_fogLightsOn;
      notifyListeners();
    }
  }

  void toggleInteriorLights() {
    if (_isAuthenticated) {
      _interiorLightsOn = !_interiorLightsOn;
      notifyListeners();
    }
  }

  void toggleHazards() {
    _hazardsOn = !_hazardsOn;
    notifyListeners();
  }

  // Charging Controls
  void toggleCharging() {
    _isCharging = !_isCharging;
    notifyListeners();
  }

  void setChargeLimit(int percentage) {
    _chargeLimit = percentage.clamp(50, 100);
    notifyListeners();
  }

  // ========== UTILITY ==========

  void logout() {
    _isAuthenticated = false;
    _isLocked = true;
    _accessType = AccessType.none;
    _accessExpiry = null;
    _currentUserKad = null;
    notifyListeners();
  }
}
