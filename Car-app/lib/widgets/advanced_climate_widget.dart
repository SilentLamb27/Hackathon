import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/car_provider.dart';
import '../utils/app_design_system.dart';

/// Redesigned Advanced Climate Control Widget
class AdvancedClimateWidget extends StatelessWidget {
  const AdvancedClimateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final car = Provider.of<CarProvider>(context);

    return TeslaCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Climate Control', style: AppTextStyles.heading3),
              Row(
                children: [
                  Text(
                    'Auto',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Switch.adaptive(
                    value: car.autoClimate,
                    activeColor: AppColors.teal,
                    onChanged: (v) => car.toggleAutoClimate(),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Main controls: temperature + fan
          Row(
            children: [
              // Big temperature display (driver)
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    _BigTempControl(
                      label: 'Driver',
                      temperature: car.temperature,
                      onIncrease: () =>
                          car.setTemperature(car.temperature + 0.5),
                      onDecrease: () =>
                          car.setTemperature(car.temperature - 0.5),
                    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05),
                    const SizedBox(height: AppSpacing.md),
                    _BigTempControl(
                      label: 'Passenger',
                      temperature: car.temperaturePassenger,
                      onIncrease: () => car.setPassengerTemperature(
                        car.temperaturePassenger + 0.5,
                      ),
                      onDecrease: () => car.setPassengerTemperature(
                        car.temperaturePassenger - 0.5,
                      ),
                    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05),
                  ],
                ),
              ),

              const SizedBox(width: AppSpacing.lg),

              // Fan and quick actions
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TeslaSectionHeader(title: 'Fan'),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TeslaSlider(
                              value: car.fanSpeed.toDouble(),
                              min: 0,
                              max: 7,
                              divisions: 7,
                              activeColor: AppColors.teal,
                              onChanged: (v) => car.setFanSpeed(v.toInt()),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            '${car.fanSpeed}/7',
                            style: AppTextStyles.numbers,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.md),
                    TeslaSectionHeader(title: 'Quick'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _QuickAction(
                          icon: Icons.ac_unit,
                          label: 'AC',
                          active: car.acOn,
                          onTap: () => car.toggleAC(),
                        ),
                        _QuickAction(
                          icon: Icons.wb_sunny,
                          label: 'Max',
                          active: car.autoClimate,
                          onTap: () => car.toggleAutoClimate(),
                        ),
                        _QuickAction(
                          icon: Icons.air,
                          label: 'Recir',
                          active: false,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Seat climate
          TeslaSectionHeader(title: 'Seat Climate'),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _SeatClimateControl(
                  label: 'Driver Heat',
                  level: car.seatHeatingDriver,
                  onChanged: (l) => car.setSeatHeating('driver', l),
                  isHeating: true,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _SeatClimateControl(
                  label: 'Passenger Heat',
                  level: car.seatHeatingPassenger,
                  onChanged: (l) => car.setSeatHeating('passenger', l),
                  isHeating: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BigTempControl extends StatelessWidget {
  final String label;
  final double temperature;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const _BigTempControl({
    required this.label,
    required this.temperature,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
        horizontal: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption),
              const SizedBox(height: 8),
              Text(
                '${temperature.toStringAsFixed(1)}°',
                style: AppTextStyles.heading2,
              ),
            ],
          ),
          const Spacer(),
          Column(
            children: [
              IconButton(
                onPressed: onIncrease,
                icon: const Icon(Icons.add_circle_outline),
                color: AppColors.teal,
                iconSize: 28,
              ),
              const SizedBox(height: 8),
              IconButton(
                onPressed: onDecrease,
                icon: const Icon(Icons.remove_circle_outline),
                color: AppColors.teal,
                iconSize: 28,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: active ? AppColors.teal : AppColors.cardBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: active ? Colors.black : AppColors.textPrimary,
              size: 20,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

class _SeatClimateControl extends StatelessWidget {
  final String label;
  final int level;
  final Function(int) onChanged;
  final bool isHeating;

  const _SeatClimateControl({
    required this.label,
    required this.level,
    required this.onChanged,
    required this.isHeating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isHeating ? Icons.whatshot : Icons.ac_unit,
                color: isHeating ? AppColors.warning : AppColors.info,
                size: 16,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(child: Text(label, style: AppTextStyles.body2)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: List.generate(4, (index) {
              final isActive = index < level;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(isActive ? index : index + 1),
                  child: Container(
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isActive
                          ? (isHeating ? AppColors.warning : AppColors.info)
                          : AppColors.overlay,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
