import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/car_provider.dart';
import '../utils/app_design_system.dart';

/// Energy Dashboard - Tesla Style
class EnergyScreen extends StatelessWidget {
  const EnergyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final car = Provider.of<CarProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'ENERGY',
          style: AppTextStyles.heading3.copyWith(letterSpacing: 2),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daily Usage Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1a1a1a),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s Energy',
                    style: AppTextStyles.heading2.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Energy Graph
                  SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: _generateEnergyData(),
                            isCurved: true,
                            color: Colors.blue[400],
                            barWidth: 3,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.blue[400]!.withOpacity(0.2),
                            ),
                          ),
                        ],
                        minY: 0,
                        maxY: 100,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildEnergyStatSmall(
                        'Used',
                        '12.5 kWh',
                        Icons.battery_charging_full,
                      ),
                      _buildEnergyStatSmall(
                        'Efficiency',
                        '156 Wh/km',
                        Icons.eco,
                      ),
                      _buildEnergyStatSmall('Regen', '2.1 kWh', Icons.refresh),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Energy Breakdown
            Text(
              'Energy Distribution',
              style: AppTextStyles.heading2.copyWith(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            _buildEnergyBreakdownItem('Driving', 65, Colors.blue[400]!),
            const SizedBox(height: 12),
            _buildEnergyBreakdownItem('Climate', 20, Colors.orange[400]!),
            const SizedBox(height: 12),
            _buildEnergyBreakdownItem(
              'Battery Conditioning',
              10,
              Colors.green[400]!,
            ),
            const SizedBox(height: 12),
            _buildEnergyBreakdownItem('Other Systems', 5, Colors.purple[400]!),

            const SizedBox(height: 24),

            // Weekly Summary
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1a1a1a),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This Week',
                    style: AppTextStyles.body1.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildWeeklyStat(
                    'Total Distance',
                    '${car.odometer - 12400} km',
                  ),
                  const SizedBox(height: 12),
                  _buildWeeklyStat('Total Energy', '87.5 kWh'),
                  const SizedBox(height: 12),
                  _buildWeeklyStat('Avg Efficiency', '158 Wh/km'),
                  const SizedBox(height: 12),
                  _buildWeeklyStat('Charging Sessions', '3'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _generateEnergyData() {
    // Generate sample energy usage data for the day
    return [
      const FlSpot(0, 10),
      const FlSpot(1, 15),
      const FlSpot(2, 20),
      const FlSpot(3, 45),
      const FlSpot(4, 60),
      const FlSpot(5, 75),
      const FlSpot(6, 70),
      const FlSpot(7, 50),
      const FlSpot(8, 40),
      const FlSpot(9, 55),
      const FlSpot(10, 65),
      FlSpot(11, 80),
    ];
  }

  Widget _buildEnergyStatSmall(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue[400], size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.numbers.copyWith(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildEnergyBreakdownItem(String label, int percentage, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: AppTextStyles.body2.copyWith(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentage / 100,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 40,
          child: Text(
            '$percentage%',
            style: AppTextStyles.numbers.copyWith(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyStat(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.body2.copyWith(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.body1.copyWith(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
