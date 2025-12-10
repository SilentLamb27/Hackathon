import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/car_provider.dart';
import '../utils/app_design_system.dart';
import '../widgets/vehicle_visualization.dart';
import '../widgets/advanced_climate_widget.dart';

/// Comprehensive Car Controls Screen with Tabs
/// Xiaomi-style granular remote control
class CarControlsScreen extends StatefulWidget {
  const CarControlsScreen({super.key});

  @override
  State<CarControlsScreen> createState() => _CarControlsScreenState();
}

class _CarControlsScreenState extends State<CarControlsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'VEHICLE CONTROLS',
          style: AppTextStyles.heading3.copyWith(letterSpacing: 2),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.teal,
          labelColor: AppColors.teal,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
          tabs: const [
            Tab(text: 'QUICK', icon: Icon(Icons.flash_on, size: 20)),
            Tab(text: 'DOORS', icon: Icon(Icons.door_front_door, size: 20)),
            Tab(text: 'CLIMATE', icon: Icon(Icons.ac_unit, size: 20)),
            Tab(text: 'LIGHTS', icon: Icon(Icons.lightbulb, size: 20)),
          ],
        ),
      ),
      body: Container(
        color: AppColors.background,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildQuickControlsTab(),
            _buildDoorsTab(),
            _buildClimateTab(),
            _buildLightsTab(),
          ],
        ),
      ),
    );
  }

  // TAB 1: Quick Controls
  Widget _buildQuickControlsTab() {
    final car = Provider.of<CarProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Vehicle Visualization
          Card(
            color: const Color(0xFF1a1a1a),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Color(0xFF2a2a2a)),
            ),
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: VehicleVisualization(),
            ),
          ).animate().fadeIn(duration: 400.ms).scale(),

          const SizedBox(height: 20),

          // Quick Action Buttons
          _buildSectionHeader('QUICK ACTIONS'),
          const SizedBox(height: 12),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: [
              _buildQuickActionCard(
                'All Windows',
                car.windowFL > 0 || car.windowFR > 0 ? 'Close' : 'Open',
                car.windowFL > 0 || car.windowFR > 0
                    ? Icons.close
                    : Icons.open_in_full,
                car.windowFL > 0 || car.windowFR > 0
                    ? Colors.blue
                    : Colors.grey,
                () {
                  if (car.windowFL > 0 || car.windowFR > 0) {
                    car.closeAllWindows();
                  } else {
                    car.openAllWindows();
                  }
                },
              ),
              _buildQuickActionCard(
                'All Doors',
                'Close',
                Icons.lock,
                Colors.red,
                () => car.closeAllDoors(),
              ),
              _buildQuickActionCard(
                'Sunroof',
                car.sunroofPosition > 0 || car.sunroofTilted ? 'Close' : 'Tilt',
                car.sunroofPosition > 0 || car.sunroofTilted
                    ? Icons.close
                    : Icons.arrow_upward,
                car.sunroofPosition > 0 || car.sunroofTilted
                    ? Colors.blue
                    : Colors.grey,
                () {
                  if (car.sunroofPosition > 0) {
                    car.setSunroofPosition(0);
                  } else if (car.sunroofTilted) {
                    car.toggleSunroofTilt();
                  } else {
                    car.toggleSunroofTilt();
                  }
                },
              ),
              _buildQuickActionCard(
                'Horn',
                'Honk',
                Icons.volume_up,
                Colors.orange,
                () {
                  car.honkHorn();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'BEEP BEEP! 🚗',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: Colors.red[700],
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Vehicle Stats
          _buildVehicleStats(car),
        ],
      ),
    );
  }

  // TAB 2: Doors & Windows
  Widget _buildDoorsTab() {
    final car = Provider.of<CarProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Individual Doors
          _buildSectionHeader('INDIVIDUAL DOORS'),
          const SizedBox(height: 12),

          _buildDoorControl(car, 'Front Left', 'FL'),
          const SizedBox(height: 8),
          _buildDoorControl(car, 'Front Right', 'FR'),
          const SizedBox(height: 8),
          _buildDoorControl(car, 'Rear Left', 'RL'),
          const SizedBox(height: 8),
          _buildDoorControl(car, 'Rear Right', 'RR'),

          const SizedBox(height: 24),

          // Individual Windows
          _buildSectionHeader('INDIVIDUAL WINDOWS'),
          const SizedBox(height: 12),

          _buildWindowControl(car, 'Front Left', 'FL'),
          const SizedBox(height: 12),
          _buildWindowControl(car, 'Front Right', 'FR'),
          const SizedBox(height: 12),
          _buildWindowControl(car, 'Rear Left', 'RL'),
          const SizedBox(height: 12),
          _buildWindowControl(car, 'Rear Right', 'RR'),

          const SizedBox(height: 24),

          // Sunroof
          _buildSectionHeader('SUNROOF'),
          const SizedBox(height: 12),
          _buildSunroofControl(car),
        ],
      ),
    );
  }

  // TAB 3: Climate
  Widget _buildClimateTab() {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: AdvancedClimateWidget(),
    );
  }

  // TAB 4: Lights & Sound
  Widget _buildLightsTab() {
    final car = Provider.of<CarProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('EXTERIOR LIGHTS'),
          const SizedBox(height: 12),

          _buildLightSwitch(
            'Headlights',
            car.headlightsOn,
            Icons.light_mode,
            () => car.toggleHeadlights(),
          ),
          const SizedBox(height: 8),
          _buildLightSwitch(
            'Fog Lights',
            car.fogLightsOn,
            Icons.foggy,
            () => car.toggleFogLights(),
          ),
          const SizedBox(height: 8),
          _buildLightSwitch(
            'Hazard Lights',
            car.hazardsOn,
            Icons.warning_amber,
            () => car.toggleHazards(),
          ),

          const SizedBox(height: 24),

          _buildSectionHeader('INTERIOR LIGHTS'),
          const SizedBox(height: 12),

          _buildLightSwitch(
            'Interior Lights',
            car.interiorLightsOn,
            Icons.light,
            () => car.toggleInteriorLights(),
          ),

          const SizedBox(height: 24),

          _buildSectionHeader('SOUND'),
          const SizedBox(height: 12),

          _buildHornButton(car),
        ],
      ),
    );
  }

  // HELPER WIDGETS

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.orbitron(
        color: Colors.tealAccent,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 255, 255, 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.outfit(color: Colors.white70, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildDoorControl(CarProvider car, String label, String position) {
    final isOpen = position == 'FL'
        ? car.doorFL
        : position == 'FR'
        ? car.doorFR
        : position == 'RL'
        ? car.doorRL
        : car.doorRR;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOpen ? Colors.red[400]! : Colors.green[700]!,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                isOpen ? Icons.door_front_door : Icons.door_front_door_outlined,
                color: isOpen ? Colors.red[400] : Colors.green[600],
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    isOpen ? 'OPEN' : 'CLOSED',
                    style: GoogleFonts.robotoMono(
                      color: isOpen ? Colors.red[300] : Colors.green[400],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () => car.toggleDoor(position),
            style: ElevatedButton.styleFrom(
              backgroundColor: isOpen ? Colors.green[700] : Colors.red[700],
            ),
            child: Text(isOpen ? 'Close' : 'Open'),
          ),
        ],
      ),
    );
  }

  Widget _buildWindowControl(CarProvider car, String label, String position) {
    final percentage = position == 'FL'
        ? car.windowFL
        : position == 'FR'
        ? car.windowFR
        : position == 'RL'
        ? car.windowRL
        : car.windowRR;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.outfit(color: Colors.white, fontSize: 14),
              ),
              Text(
                '${percentage.toInt()}%',
                style: GoogleFonts.orbitron(
                  color: Colors.tealAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: Colors.blue[400],
              inactiveTrackColor: Colors.grey[800],
              thumbColor: Colors.blue,
              trackHeight: 4,
            ),
            child: Slider(
              value: percentage,
              min: 0,
              max: 100,
              onChanged: (value) => car.setWindowPosition(position, value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSunroofControl(CarProvider car) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Position',
                style: GoogleFonts.outfit(color: Colors.white, fontSize: 14),
              ),
              Text(
                car.sunroofTilted
                    ? 'TILTED'
                    : '${car.sunroofPosition.toInt()}%',
                style: GoogleFonts.orbitron(
                  color: Colors.blue[300],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => car.toggleSunroofTilt(),
                  icon: const Icon(Icons.arrow_upward),
                  label: Text(car.sunroofTilted ? 'Untilt' : 'Tilt'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: car.sunroofTilted
                        ? Colors.blue[700]
                        : Colors.grey[800],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () =>
                      car.setSunroofPosition(car.sunroofPosition > 0 ? 0 : 50),
                  icon: const Icon(Icons.open_in_full),
                  label: Text(car.sunroofPosition > 0 ? 'Close' : 'Open'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: car.sunroofPosition > 0
                        ? Colors.blue[700]
                        : Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLightSwitch(
    String label,
    bool isOn,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isOn ? Colors.yellow[700]! : Colors.white12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: isOn ? Colors.yellow : Colors.grey),
              const SizedBox(width: 12),
              Text(
                label,
                style: GoogleFonts.outfit(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          Switch(
            value: isOn,
            onChanged: (_) => onTap(),
            activeColor: Colors.yellow,
          ),
        ],
      ),
    );
  }

  Widget _buildHornButton(CarProvider car) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          car.honkHorn();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.volume_up, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    'BEEP BEEP! 🚗',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              backgroundColor: Colors.red[700],
              duration: const Duration(seconds: 1),
            ),
          );
        },
        icon: const Icon(Icons.campaign, size: 28),
        label: Text(
          'HONK HORN',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[700],
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildVehicleStats(CarProvider car) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('VEHICLE STATUS'),
        const SizedBox(height: 12),

        _buildStatRow(
          'Battery',
          '${(car.batteryLevel * 100).toInt()}%',
          Icons.battery_charging_full,
          Colors.green,
        ),
        const SizedBox(height: 8),
        _buildStatRow('Range', '${car.rangeKm} km', Icons.speed, Colors.blue),
        const SizedBox(height: 8),
        _buildStatRow(
          'Charging',
          car.isCharging ? 'Active' : 'Inactive',
          Icons.electric_bolt,
          Colors.yellow,
        ),
        const SizedBox(height: 8),
        _buildStatRow(
          'Odometer',
          '${car.odometer} km',
          Icons.speed_outlined,
          Colors.grey,
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.outfit(color: Colors.grey, fontSize: 13),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
