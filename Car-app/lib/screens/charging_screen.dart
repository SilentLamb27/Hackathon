import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/car_provider.dart';
import '../utils/app_design_system.dart';

/// Charging Screen - Tesla Style
/// Real-time charging progress and controls
class ChargingScreen extends StatelessWidget {
  const ChargingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final car = Provider.of<CarProvider>(context);
    final batteryPercent = (car.batteryLevel * 100).toInt();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'CHARGING',
          style: AppTextStyles.heading3.copyWith(letterSpacing: 2),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),

            // Circular Progress Indicator
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: car.isCharging
                        ? AppColors.success.withValues(alpha: 0.3)
                        : AppColors.info.withValues(alpha: 0.2),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background circle
                  SizedBox(
                    width: 250,
                    height: 250,
                    child: CircularProgressIndicator(
                      value: car.batteryLevel,
                      strokeWidth: 18,
                      backgroundColor: AppColors.cardBackground,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        car.isCharging ? AppColors.success : AppColors.info,
                      ),
                    ),
                  ),

                  // Center content
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('$batteryPercent%', style: AppTextStyles.heading1),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: car.isCharging
                              ? AppColors.success.withValues(alpha: 0.2)
                              : AppColors.info.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          car.isCharging ? 'CHARGING' : 'READY',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.bold,
                            color: car.isCharging
                                ? AppColors.success
                                : AppColors.info,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().scale(duration: 600.ms, curve: Curves.easeOut),

            const SizedBox(height: 40),

            // Charging Stats
            if (car.isCharging) ...[
              _buildStatRow(
                'Charging Rate',
                '${car.chargingRate.toInt()} kW',
                Icons.bolt,
              ),
              const SizedBox(height: 12),
              _buildStatRow(
                'Time to Full',
                _calculateTimeToFull(car),
                Icons.access_time,
              ),
              const SizedBox(height: 12),
              _buildStatRow(
                'Range Gained',
                '+${_calculateRangeGained(car)} km/hr',
                Icons.trending_up,
              ),
            ] else ...[
              _buildStatRow('Range', '${car.rangeKm} km', Icons.speed),
              const SizedBox(height: 12),
              _buildStatRow(
                'Battery',
                '$batteryPercent%',
                Icons.battery_charging_full,
              ),
            ],

            const SizedBox(height: 40),

            // Charge Limit
            TeslaCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Charge Limit',
                        style: AppTextStyles.body1.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${car.chargeLimit}%',
                        style: AppTextStyles.heading3.copyWith(
                          color: AppColors.info,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TeslaSlider(
                    value: car.chargeLimit.toDouble(),
                    min: 50,
                    max: 100,
                    divisions: 10,
                    activeColor: AppColors.info,
                    onChanged: (value) => car.setChargeLimit(value.toInt()),
                  ),
                  Text(
                    'Set charging limit to preserve battery health',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Start/Stop Charging Button
            TeslaButton(
              label: car.isCharging ? 'STOP CHARGING' : 'START CHARGING',
              onPressed: () => car.toggleCharging(),
              backgroundColor: car.isCharging
                  ? AppColors.danger
                  : AppColors.success,
              textColor: Colors.black,
            ),

            const SizedBox(height: 16),

            // Schedule Charging
            SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Scheduled charging coming soon!',
                        style: AppTextStyles.body2,
                      ),
                      backgroundColor: AppColors.cardBackground,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.teal,
                  side: BorderSide(color: AppColors.divider, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.schedule, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'SCHEDULE CHARGING',
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a1a),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2a2a2a)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF64FFDA).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.teal, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(label, style: AppTextStyles.body2)),
          Text(value, style: AppTextStyles.heading3),
        ],
      ),
    );
  }

  String _calculateTimeToFull(CarProvider car) {
    final remaining = (100 - car.batteryLevel * 100) / 100;
    final hours =
        (remaining * 75) / car.chargingRate; // Assuming 75 kWh battery
    if (hours < 1) {
      return '${(hours * 60).toInt()} min';
    }
    return '${hours.toStringAsFixed(1)} hr';
  }

  int _calculateRangeGained(CarProvider car) {
    // Simplified: 1 kW for 1 hour = ~5 km range
    return (car.chargingRate * 5).toInt();
  }
}
