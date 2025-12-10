import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/car_provider.dart';
import '../utils/app_design_system.dart';

/// Climate Screen — refreshed to use the app design system
class ClimateScreen extends StatelessWidget {
  const ClimateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final car = Provider.of<CarProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Climate Control', style: AppTextStyles.heading3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            // AC Status
            TeslaCard(
              child: Column(
                children: [
                  Icon(
                    car.acOn ? Icons.ac_unit : Icons.power_settings_new,
                    size: 56,
                    color: car.acOn
                        ? AppColors.textPrimary
                        : AppColors.textTertiary,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    car.acOn ? 'CLIMATE ON' : 'CLIMATE OFF',
                    style: AppTextStyles.heading3.copyWith(letterSpacing: 1.5),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TeslaButton(
                    label: car.acOn ? 'TURN OFF' : 'TURN ON',
                    onPressed: () => car.toggleAC(),
                    backgroundColor: car.acOn
                        ? AppColors.danger
                        : AppColors.success,
                    textColor: Colors.black,
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 350.ms),

            const SizedBox(height: AppSpacing.lg),

            // Temperature card
            TeslaCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: AppColors.info.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.thermostat, color: AppColors.info),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        'Temperature'.toUpperCase(),
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  Center(
                    child: Text(
                      '${car.temperature.toStringAsFixed(1)}°C',
                      style: AppTextStyles.heading1.copyWith(
                        color: AppColors.teal,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _TempBtn(
                        icon: Icons.remove,
                        enabled: car.temperature > 16,
                        onTap: () => car.setTemperature(car.temperature - 0.5),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '16°C - 30°C',
                          style: AppTextStyles.caption,
                        ),
                      ),
                      _TempBtn(
                        icon: Icons.add,
                        enabled: car.temperature < 30,
                        onTap: () => car.setTemperature(car.temperature + 0.5),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 80.ms, duration: 300.ms),

            const SizedBox(height: AppSpacing.lg),

            // Seat heating
            TeslaCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.airline_seat_recline_normal,
                          color: AppColors.warning,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        'Seat Heating'.toUpperCase(),
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: _SeatControl(
                          label: 'Driver',
                          level: car.seatHeatingDriver,
                          onChange: (v) => car.setSeatHeating('driver', v),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _SeatControl(
                          label: 'Passenger',
                          level: car.seatHeatingPassenger,
                          onChange: (v) => car.setSeatHeating('passenger', v),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Fan speed
            TeslaCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: AppColors.teal.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.air, color: AppColors.teal),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        'Fan Speed'.toUpperCase(),
                        style: AppTextStyles.caption,
                      ),
                      const Spacer(),
                      Text('${car.fanSpeed}/7', style: AppTextStyles.numbers),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),
                  TeslaSlider(
                    value: car.fanSpeed.toDouble(),
                    min: 0,
                    max: 7,
                    divisions: 7,
                    activeColor: AppColors.teal,
                    onChanged: (v) => car.setFanSpeed(v.toInt()),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Quick actions
            TeslaCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions'.toUpperCase(),
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _ActionTile(
                    icon: Icons.air,
                    title: 'Max Cool',
                    subtitle: 'Set to 16°C, Fan 7',
                    onTap: () {
                      car.setTemperature(16);
                      car.setFanSpeed(7);
                      if (!car.acOn) car.toggleAC();
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _ActionTile(
                    icon: Icons.local_fire_department,
                    title: 'Max Heat',
                    subtitle: 'Set to 30°C, Fan 7',
                    onTap: () {
                      car.setTemperature(30);
                      car.setFanSpeed(7);
                      if (!car.acOn) car.toggleAC();
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _ActionTile(
                    icon: Icons.eco,
                    title: 'Eco Mode',
                    subtitle: 'Set to 22°C, Fan 3',
                    onTap: () {
                      car.setTemperature(22);
                      car.setFanSpeed(3);
                      if (!car.acOn) car.toggleAC();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TempBtn extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _TempBtn({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: enabled
              ? AppColors.teal.withOpacity(0.14)
              : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: enabled ? AppColors.teal : AppColors.divider,
          ),
        ),
        child: Icon(
          icon,
          color: enabled ? AppColors.teal : AppColors.textTertiary,
          size: 28,
        ),
      ),
    );
  }
}

class _SeatControl extends StatelessWidget {
  final String label;
  final int level;
  final ValueChanged<int> onChange;

  const _SeatControl({
    required this.label,
    required this.level,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final isActive = index < level;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: GestureDetector(
                onTap: () => onChange(index + 1),
                child: Container(
                  width: 14,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.warning
                        : AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isActive ? AppColors.warning : AppColors.divider,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextButton(
          onPressed: () => onChange(0),
          child: Text(
            'OFF',
            style: AppTextStyles.caption.copyWith(
              color: level == 0 ? AppColors.teal : AppColors.textTertiary,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.teal, size: 22),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.body1),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
