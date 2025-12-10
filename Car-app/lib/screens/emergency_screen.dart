import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/car_provider.dart';
import '../services/location_service.dart';
import '../utils/app_design_system.dart';

/// Advanced Emergency & Crash Detection Screen
/// Real-time emergency response with comprehensive visualization,
/// traffic routing, emergency messaging, and direct calling
class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final List<EmergencyEvent> _events = [];
  int _secondsElapsed = 0;
  bool _driverConscious = true;
  bool _trafficReroutingActive = false;
  late final CarProvider _carProvider;

  @override
  void initState() {
    super.initState();
    _simulateEmergencySequence();
    _startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _carProvider = Provider.of<CarProvider>(context, listen: false);
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _secondsElapsed++);
        _startTimer();
      }
    });
  }

  void _simulateEmergencySequence() async {
    _addEvent('IMPACT DETECTED - Severe crash detected', EventType.critical);
    await Future.delayed(const Duration(milliseconds: 500));

    _addEvent('Analyzing crash severity...', EventType.system);
    await Future.delayed(const Duration(milliseconds: 1000));

    _addEvent('G-Force: 4.2G - SEVERE IMPACT', EventType.critical);
    await Future.delayed(const Duration(milliseconds: 800));

    _addEvent(
      'Airbags deployed: Front driver, Front passenger',
      EventType.system,
    );
    await Future.delayed(const Duration(milliseconds: 600));

    _addEvent('Seatbelt pre-tensioners activated', EventType.system);
    await Future.delayed(const Duration(milliseconds: 600));

    _addEvent('Unlocking all doors automatically', EventType.info);
    await Future.delayed(const Duration(milliseconds: 500));

    _addEvent('Activating hazard lights', EventType.info);
    await Future.delayed(const Duration(milliseconds: 500));

    _addEvent('Acquiring GPS location...', EventType.info);
    await Future.delayed(const Duration(milliseconds: 1200));

    _addEvent('✓ Location acquired: 3.1587°N, 101.7123°E', EventType.success);
    await Future.delayed(const Duration(milliseconds: 800));

    // NEW: Traffic Rerouting Feature
    _addEvent(
      '🚦 Broadcasting accident location to navigation apps...',
      EventType.info,
    );
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() => _trafficReroutingActive = true);
    _addEvent(
      '✓ Traffic alert sent - Nearby vehicles rerouting',
      EventType.success,
    );
    await Future.delayed(const Duration(milliseconds: 1000));

    _addEvent('Calling emergency services (999)...', EventType.critical);
    await Future.delayed(const Duration(milliseconds: 1500));

    _addEvent(
      '✓ Connected to 999 Emergency Dispatch Center',
      EventType.success,
    );
    await Future.delayed(const Duration(milliseconds: 1000));

    _addEvent('Transmitting crash data to emergency services', EventType.info);
    await Future.delayed(const Duration(milliseconds: 1000));

    _addEvent('Ambulance dispatched - ETA: 6 minutes', EventType.critical);
    await Future.delayed(const Duration(milliseconds: 1200));

    _addEvent('Police unit dispatched - ETA: 4 minutes', EventType.info);
    await Future.delayed(const Duration(milliseconds: 1000));

    _addEvent('Notifying emergency contacts...', EventType.info);
    await Future.delayed(const Duration(milliseconds: 800));

    for (var contact in _carProvider.emergencyContacts) {
      _addEvent(
        '📞 Calling ${contact.name} (${contact.relationship})',
        EventType.info,
      );
      await Future.delayed(const Duration(milliseconds: 1000));
      _addEvent(
        '✓ SMS sent to ${contact.name} with location & status',
        EventType.success,
      );
      await Future.delayed(const Duration(milliseconds: 600));
    }

    _addEvent(
      'Recording dashcam footage (30s before + 60s after)',
      EventType.system,
    );
    await Future.delayed(const Duration(milliseconds: 1000));

    _addEvent('Saving black box data...', EventType.system);
    await Future.delayed(const Duration(milliseconds: 800));

    _addEvent('Generating incident report...', EventType.system);
    await Future.delayed(const Duration(milliseconds: 1000));

    _addEvent('✓ All emergency protocols activated', EventType.success);
  }

  void _addEvent(String message, EventType type) {
    if (mounted) {
      setState(() {
        _events.add(
          EmergencyEvent(
            message: message,
            timestamp: DateTime.now(),
            type: type,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final car = Provider.of<CarProvider>(context);

    // Auto-close logic removed to allow simulation to run

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF3a0000), // Dark red
              Colors.black,
              const Color(0xFF1a0000),
            ],
          ),
          border: Border.all(color: const Color(0xFFEF4444), width: 4),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Emergency Header
              _buildEmergencyHeader(),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      // Crash Impact Visualization
                      _buildCrashVisualization(),

                      const SizedBox(height: AppSpacing.lg),

                      // Emergency Services Status
                      _buildEmergencyServices(),

                      const SizedBox(height: AppSpacing.lg),

                      // Vital Information
                      _buildVitalInfo(car),

                      const SizedBox(height: AppSpacing.lg),

                      // Live Event Feed
                      _buildEventFeed(),

                      const SizedBox(height: AppSpacing.lg),

                      // Driver Consciousness Check
                      _buildConsciousnessCheck(),

                      const SizedBox(height: AppSpacing.lg),

                      // NEW: Emergency Action Buttons
                      _buildEmergencyActions(car),

                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyHeader() {
    return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          color: AppColors.danger.withOpacity(0.3),
          child: Row(
            children: [
              Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.danger,
                    size: 32,
                  )
                  .animate(onPlay: (c) => c.repeat())
                  .fadeIn(duration: 500.ms)
                  .then()
                  .fadeOut(duration: 500.ms),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EMERGENCY ACTIVE',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.danger,
                      ),
                    ),
                    Text(
                      'Emergency services have been contacted',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              Text(
                '${_secondsElapsed}s',
                style: AppTextStyles.numbers.copyWith(color: AppColors.danger),
              ),
            ],
          ),
        )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(duration: 2000.ms, color: AppColors.danger.withOpacity(0.2));
  }

  Widget _buildCrashVisualization() {
    return TeslaCard(
      borderColor: AppColors.danger.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TeslaSectionHeader(title: 'CRASH DATA', color: AppColors.danger),

          // G-Force Meter
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Impact Force', style: AppTextStyles.caption),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Text(
                          '4.2',
                          style: AppTextStyles.heading1.copyWith(
                            color: AppColors.danger,
                          ),
                        ),
                        Text(
                          'G',
                          style: AppTextStyles.heading3.copyWith(
                            color: AppColors.danger,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'SEVERE',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.danger,
                      ),
                    ),
                  ],
                ),
              ),

              // Impact visualization
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.directions_car,
                      size: 60,
                      color: AppColors.textSecondary,
                    ),
                    Positioned(
                      top: 10,
                      child:
                          Icon(
                                Icons.arrow_downward,
                                color: AppColors.danger,
                                size: 24,
                              )
                              .animate(onPlay: (c) => c.repeat())
                              .moveY(begin: 0, end: 20, duration: 500.ms)
                              .then()
                              .moveY(begin: 20, end: 0, duration: 500.ms),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Safety Systems Status
          _buildSafetyStatus(
            'Airbags',
            'Deployed (Front x2)',
            Icons.security,
            AppColors.success,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildSafetyStatus(
            'Seatbelts',
            'Pre-tensioned',
            Icons.safety_check,
            AppColors.success,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildSafetyStatus(
            'Doors',
            'Unlocked',
            Icons.lock_open,
            AppColors.info,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildSafetyStatus(
            'Hazard Lights',
            'Active',
            Icons.warning,
            AppColors.warning,
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyStatus(
    String label,
    String status,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Text(label, style: AppTextStyles.body2)),
        Text(status, style: AppTextStyles.caption.copyWith(color: color)),
      ],
    );
  }

  Widget _buildEmergencyServices() {
    return TeslaCard(
      borderColor: AppColors.success.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TeslaSectionHeader(
            title: 'EMERGENCY SERVICES',
            color: AppColors.success,
          ),

          // 999 Connection
          Row(
            children: [
              Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  )
                  .animate(onPlay: (c) => c.repeat())
                  .fadeOut(duration: 500.ms)
                  .then()
                  .fadeIn(duration: 500.ms),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('999 Emergency Dispatch', style: AppTextStyles.body1),
                    Text(
                      'Connected - Call active',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${_secondsElapsed}s',
                style: AppTextStyles.numbers.copyWith(color: AppColors.success),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // First Responders
          _buildResponder(
            'Ambulance',
            '6 min',
            Icons.local_hospital,
            AppColors.danger,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildResponder(
            'Police',
            '4 min',
            Icons.local_police,
            AppColors.info,
          ),
        ],
      ),
    );
  }

  Widget _buildResponder(String type, String eta, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(type, style: AppTextStyles.body1)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('ETA', style: AppTextStyles.caption),
              Text(eta, style: AppTextStyles.numbers.copyWith(color: color)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVitalInfo(CarProvider car) {
    return TeslaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TeslaSectionHeader(title: 'VITAL INFORMATION'),

          _buildVitalRow(
            'Location',
            car.currentLocation != null
                ? LocationService.formatCoordinates(car.currentLocation!)
                : 'Acquiring...',
            Icons.location_on,
          ),
          _buildVitalRow('Passengers', '2 detected', Icons.people),
          _buildVitalRow(
            'Battery',
            '${(car.batteryLevel * 100).toInt()}%',
            Icons.battery_full,
          ),
          _buildVitalRow('Temperature', 'Normal', Icons.thermostat),
        ],
      ),
    );
  }

  Widget _buildVitalRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(label, style: AppTextStyles.body2)),
          Text(value, style: AppTextStyles.caption),
        ],
      ),
    );
  }

  Widget _buildEventFeed() {
    return TeslaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TeslaSectionHeader(title: 'LIVE EVENT LOG'),

          SizedBox(
            height: 200,
            child: ListView.builder(
              reverse: true,
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final event = _events[_events.length - 1 - index];
                return _buildEventItem(event);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem(EmergencyEvent event) {
    Color eventColor;
    switch (event.type) {
      case EventType.critical:
        eventColor = AppColors.danger;
        break;
      case EventType.success:
        eventColor = AppColors.success;
        break;
      case EventType.info:
        eventColor = AppColors.info;
        break;
      case EventType.system:
        eventColor = AppColors.warning;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_formatTime(event.timestamp), style: AppTextStyles.caption),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              event.message,
              style: AppTextStyles.body2.copyWith(color: eventColor),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 200.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildConsciousnessCheck() {
    return TeslaCard(
      color: _driverConscious
          ? AppColors.cardBackground
          : const Color(0xFF3a0000),
      borderColor: _driverConscious ? AppColors.success : AppColors.danger,
      child: Column(
        children: [
          Icon(
            _driverConscious ? Icons.check_circle : Icons.error,
            color: _driverConscious ? AppColors.success : AppColors.danger,
            size: 48,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            _driverConscious ? 'Driver Conscious' : 'Driver Needs Assistance',
            style: AppTextStyles.heading3.copyWith(
              color: _driverConscious ? AppColors.success : AppColors.danger,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),

          TeslaButton(
            label: _driverConscious ? 'I\'M OK' : 'HELP NEEDED',
            onPressed: () {
              setState(() => _driverConscious = !_driverConscious);
            },
            backgroundColor: _driverConscious
                ? AppColors.success
                : AppColors.danger,
            icon: _driverConscious ? Icons.check_circle : Icons.error,
          ),

          const SizedBox(height: AppSpacing.md),

          TeslaButton(
            label: 'CANCEL EMERGENCY',
            onPressed: () => _showCancelDialog(),
            isOutlined: true,
            textColor: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  // NEW: Emergency Action Buttons
  Widget _buildEmergencyActions(CarProvider car) {
    return TeslaCard(
      borderColor: const Color(0xFFEF4444),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emergency, color: Color(0xFFEF4444), size: 24),
              const SizedBox(width: 12),
              Text(
                'EMERGENCY ACTIONS',
                style: GoogleFonts.orbitron(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFEF4444),
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Traffic Rerouting Status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _trafficReroutingActive
                  ? const Color(0xFF10B981).withOpacity(0.1)
                  : const Color(0xFF1a1a1a),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _trafficReroutingActive
                    ? const Color(0xFF10B981)
                    : const Color(0xFF2a2a2a),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _trafficReroutingActive ? Icons.check_circle : Icons.traffic,
                  color: _trafficReroutingActive
                      ? const Color(0xFF10B981)
                      : const Color(0xFF6B7280),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Traffic Rerouting',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _trafficReroutingActive
                            ? 'Active - Vehicles being redirected'
                            : 'Broadcasting accident location',
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF9CA3AF),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Call Police Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _callEmergencyService('999', 'Police'),
              icon: const Icon(Icons.local_police, size: 20),
              label: Text(
                'CALL POLICE (999)',
                style: GoogleFonts.orbitron(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Call Ambulance Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _callEmergencyService('999', 'Ambulance'),
              icon: const Icon(Icons.local_hospital, size: 20),
              label: Text(
                'CALL AMBULANCE (999)',
                style: GoogleFonts.orbitron(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          const Divider(color: Color(0xFF2a2a2a)),

          const SizedBox(height: 16),

          // Message Emergency Contacts
          Text(
            'EMERGENCY CONTACTS',
            style: GoogleFonts.orbitron(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF6B7280),
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(height: 12),

          if (car.emergencyContacts.isEmpty)
            Text(
              'No emergency contacts configured',
              style: GoogleFonts.outfit(
                color: const Color(0xFF6B7280),
                fontSize: 13,
              ),
            )
          else
            ...car.emergencyContacts.take(3).map((contact) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            _callContact(contact.phoneNumber, contact.name),
                        icon: const Icon(Icons.phone, size: 18),
                        label: Text(
                          '${contact.name} (${contact.relationship})',
                          style: GoogleFonts.outfit(fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF64FFDA),
                          side: const BorderSide(color: Color(0xFF2a2a2a)),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () =>
                          _sendSMS(contact.phoneNumber, contact.name),
                      icon: const Icon(Icons.message, size: 20),
                      color: const Color(0xFF64FFDA),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFF1a1a1a),
                        side: const BorderSide(color: Color(0xFF2a2a2a)),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  // Helper methods for calling and messaging
  Future<void> _callEmergencyService(String number, String service) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: number);

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
      _addEvent('📞 Calling $service...', EventType.critical);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Unable to make call. Emergency: $number',
              style: GoogleFonts.outfit(),
            ),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  Future<void> _callContact(String phoneNumber, String name) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
      _addEvent('📞 Calling $name...', EventType.info);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to call $name', style: GoogleFonts.outfit()),
            backgroundColor: const Color(0xFF1a1a1a),
          ),
        );
      }
    }
  }

  Future<void> _sendSMS(String phoneNumber, String name) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: {
        'body':
            'EMERGENCY: I\'ve been in an accident at location: 3.1587°N, 101.7123°E. Please check on me!',
      },
    );

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
      _addEvent('💬 SMS to $name sent', EventType.success);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Unable to send SMS to $name',
              style: GoogleFonts.outfit(),
            ),
            backgroundColor: const Color(0xFF1a1a1a),
          ),
        );
      }
    }
  }

  Widget _buildConsciousnessCheck_OLD() {
    return TeslaCard(
      borderColor: _driverConscious
          ? AppColors.success.withOpacity(0.3)
          : AppColors.danger.withOpacity(0.3),
      child: Column(
        children: [
          Text(
            'ARE YOU OK?',
            style: AppTextStyles.heading2.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Tap button every 30 seconds to confirm you are conscious',
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),

          TeslaButton(
            label: _driverConscious ? 'I\'M OK' : 'HELP NEEDED',
            onPressed: () {
              setState(() => _driverConscious = !_driverConscious);
            },
            backgroundColor: _driverConscious
                ? AppColors.success
                : AppColors.danger,
            icon: _driverConscious ? Icons.check_circle : Icons.error,
          ),

          const SizedBox(height: AppSpacing.md),

          TeslaButton(
            label: 'CANCEL EMERGENCY',
            onPressed: () => _showCancelDialog(),
            isOutlined: true,
            textColor: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text('Cancel Emergency?', style: AppTextStyles.heading3),
        content: Text(
          'Emergency services have been contacted. Are you sure you want to cancel?',
          style: AppTextStyles.body2,
        ),
        actions: [
          TeslaButton(
            label: 'NO, KEEP ACTIVE',
            onPressed: () => Navigator.pop(context),
            backgroundColor: AppColors.danger,
          ),
          TeslaButton(
            label: 'YES, I\'M SAFE',
            onPressed: () {
              final car = Provider.of<CarProvider>(context, listen: false);
              car.cancelEmergency();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            backgroundColor: AppColors.success,
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }
}

class EmergencyEvent {
  final String message;
  final DateTime timestamp;
  final EventType type;

  EmergencyEvent({
    required this.message,
    required this.timestamp,
    required this.type,
  });
}

enum EventType { critical, success, info, system }
