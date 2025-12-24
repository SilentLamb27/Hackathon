import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/car_provider.dart';
import '../services/location_service.dart';
import '../utils/app_design_system.dart';
import 'car_controls_screen.dart';
import 'charging_screen.dart';
import 'climate_screen.dart';
import 'summon_screen.dart';
import 'software_update_screen.dart';
import 'media_screen.dart';
import 'energy_screen.dart';
import 'gps_tracking_screen.dart';
import 'emergency_screen.dart';
import 'rfid_toll_screen.dart';

import '../models/predictive_maintenance.dart';
import '../widgets/predictive_maintenance_widget.dart';

import '../widgets/voice_assistant_widget.dart';

/// Tesla-Style Dashboard
/// Minimalist dark interface with car focus
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final car = Provider.of<CarProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          car.accessType == AccessType.owner ? 'MY MODEL S' : 'GUEST ACCESS',
          style: AppTextStyles.heading3.copyWith(letterSpacing: 2),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, size: 24),
            color: AppColors.teal,
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Car Visualization
            _buildCarVisualization(car),

            const SizedBox(height: 16),

            // Status Text
            _buildStatusText(car),

            // Predictive Maintenance Widget
            PredictiveMaintenanceWidget(
              data: PredictiveMaintenanceModel(
                engineTemp: car.engineTemp ?? 90,
                batteryHealth: car.batteryHealth ?? 100,
                tirePressure: car.tirePressure ?? 32,
                mileage: car.mileage ?? 0,
                lastServiceDate:
                    car.lastServiceDate ??
                    DateTime.now().subtract(const Duration(days: 100)),
              ),
            ),
            const SizedBox(height: 16),

            // Voice Assistant Widget
            VoiceAssistantWidget(
              onCommandRecognized: (command) {
                // Example: handle recognized commands
                if (command.toLowerCase().contains('climate')) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ClimateScreen()),
                  );
                }
                // Add more command handling as needed
              },
            ),
            const SizedBox(height: 16),

            const SizedBox(height: 24),

            // Main Control Icons
            _buildMainControls(context, car),

            const SizedBox(height: 32),

            // Menu List
            _buildMenuList(context, car),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCarVisualization(CarProvider car) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow effect
          if (!car.isLocked)
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.danger.withValues(alpha: 0.4),
                    blurRadius: 60,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),

          // Car icon (large)
          Icon(
            Icons.directions_car_filled,
            size: 180,
            color: car.isLocked ? AppColors.textTertiary : AppColors.danger,
          ).animate().scale(duration: 600.ms, curve: Curves.easeOut),

          // Seat heating indicators
          if (car.seatHeatingDriver > 0)
            Positioned(
              right: 80,
              bottom: 60,
              child:
                  Icon(
                        Icons.local_fire_department,
                        color: AppColors.warning,
                        size: 24,
                      )
                      .animate(onPlay: (c) => c.repeat())
                      .fadeIn(duration: 500.ms)
                      .then()
                      .fadeOut(duration: 500.ms),
            ),
          if (car.seatHeatingPassenger > 0)
            Positioned(
              right: 80,
              bottom: 60,
              child:
                  Icon(
                        Icons.local_fire_department,
                        color: AppColors.warning,
                        size: 24,
                      )
                      .animate(onPlay: (c) => c.repeat())
                      .fadeIn(duration: 500.ms)
                      .then()
                      .fadeOut(duration: 500.ms),
            ),

          // Climate active indicator
          if (car.acOn)
            Positioned(
              top: 40,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.info,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Climate On - ${car.temperature.toInt()}°C',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2000.ms),
            ),

          // Charging indicator
          if (car.isCharging)
            Positioned(
              bottom: 40,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bolt, color: Colors.black, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Charging - ${car.chargingRate.toInt()} kW',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusText(CarProvider car) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Text(
        car.isLocked
            ? '${car.rangeKm} km · PARKED'
            : '${car.rangeKm} km · READY TO DRIVE',
        style: AppTextStyles.caption.copyWith(
          color: car.isLocked ? AppColors.textSecondary : AppColors.teal,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildMainControls(BuildContext context, CarProvider car) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildControlIcon(
            car.isLocked ? Icons.lock : Icons.lock_open,
            car.isLocked ? 'Lock' : 'Unlock',
            car.isLocked ? AppColors.danger : AppColors.success,
            () => car.toggleLock(),
          ),
          _buildControlIcon(
            Icons.ac_unit,
            'Climate',
            car.acOn ? AppColors.info : AppColors.textTertiary,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ClimateScreen()),
              );
            },
          ),
          _buildControlIcon(
            Icons.electric_bolt,
            'Charge',
            car.isCharging ? AppColors.success : AppColors.textTertiary,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChargingScreen()),
              );
            },
          ),
          _buildControlIcon(
            Icons.settings_remote,
            'Controls',
            AppColors.textSecondary,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CarControlsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildControlIcon(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
          onTap: onTap,
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color.withValues(alpha: 0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.2),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: 200.ms)
        .scale(duration: 300.ms, curve: Curves.easeOut);
  }

  Widget _buildMenuList(BuildContext context, CarProvider car) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildMenuItem(
            context,
            Icons.settings_remote,
            'Controls',
            'Doors, windows, trunk, locks & more',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CarControlsScreen()),
            ),
          ),
          _buildDivider(),
          _buildMenuItem(
            context,
            Icons.ac_unit,
            'Climate',
            car.acOn
                ? 'Active - ${car.temperature.toInt()}°C'
                : 'Temperature & ventilation controls',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ClimateScreen()),
            ),
          ),
          _buildDivider(),
          _buildMenuItem(
            context,
            Icons.toll,
            'RFID & Toll',
            'Highway & parking access via MyKAD',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RfidTollScreen()),
            ),
          ),
          _buildDivider(),
          _buildMenuItem(
            context,
            Icons.location_on,
            'Location',
            car.currentLocation != null
                ? LocationService.formatCoordinates(car.currentLocation!)
                : 'Unknown',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GpsTrackingScreen()),
            ),
          ),
          _buildDivider(),
          _buildMenuItem(
            context,
            Icons.open_in_full,
            'Summon',
            'Press and hold controls to move vehicle',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SummonScreen()),
            ),
          ),
          _buildDivider(),
          _buildMenuItem(
            context,
            Icons.electric_bolt,
            'Charging',
            '${(car.batteryLevel * 100).toInt()}% - ${car.rangeKm} km range',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChargingScreen()),
            ),
          ),
          _buildDivider(),
          _buildMenuItem(
            context,
            Icons.system_update,
            'Software Update',
            'Version 2025.1.0 - Up to date',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SoftwareUpdateScreen()),
            ),
          ),
          _buildDivider(),
          _buildMenuItem(
            context,
            Icons.music_note,
            'Media',
            'Control vehicle audio',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MediaScreen()),
            ),
          ),
          _buildDivider(),
          _buildMenuItem(
            context,
            Icons.bar_chart,
            'Energy',
            'Monitor usage and efficiency',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EnergyScreen()),
            ),
          ),
          _buildDivider(),
          _buildMenuItem(
            context,
            Icons.warning_amber,
            'Emergency',
            'Simulate accident detection',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EmergencyScreen()),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary, size: 24),
      title: Text(title, style: AppTextStyles.body1),
      subtitle: Text(subtitle, style: AppTextStyles.caption),
      trailing: Icon(Icons.chevron_right, color: AppColors.textTertiary),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: AppColors.divider,
      height: 1,
      indent: 16,
      endIndent: 16,
    );
  }
}
