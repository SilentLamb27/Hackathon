import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/car_provider.dart';
import '../services/location_service.dart';
import '../utils/app_design_system.dart';
import '../utils/error_handler.dart';
import '../utils/haptic_feedback_service.dart';

/// GPS Tracking Screen
/// Shows current location and map integration
class GpsTrackingScreen extends StatefulWidget {
  const GpsTrackingScreen({super.key});

  @override
  State<GpsTrackingScreen> createState() => _GpsTrackingScreenState();
}

class _GpsTrackingScreenState extends State<GpsTrackingScreen> {
  bool _mapError = false;
  bool _isRefreshing = false;

  Future<T?> _runWithLoading<T>({
    required String message,
    required Future<T> Function() operation,
    String? errorMessage,
  }) async {
    setState(() => _isRefreshing = true);
    final result = await ErrorHandler.handleAsync(
      context,
      operation,
      errorMessage: errorMessage ?? 'Failed to perform action',
    );
    setState(() => _isRefreshing = false);
    return result;
  }

  @override
  void initState() {
    super.initState();
    _refreshLocation();
  }

  Future<void> _refreshLocation() async {
    final car = Provider.of<CarProvider>(context, listen: false);
    await _runWithLoading<void>(
      message: 'Refreshing location...',
      operation: () => car.refreshLocation(),
      errorMessage: 'Failed to refresh location',
    );
  }

  Future<void> _openInMaps(Position position) async {
    HapticFeedbackService.selection();
    final url = LocationService.getGoogleMapsUrl(position);
    final uri = Uri.parse(url);
    final launched = await _runWithLoading<bool>(
      message: 'Opening maps...',
      operation: () async {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
          return true;
        }
        return false;
      },
      errorMessage: 'Unable to open maps link',
    );
    if (launched == false && mounted) {
      ErrorHandler.showError(context, 'Could not open map link');
    }
  }

  @override
  Widget build(BuildContext context) {
    final car = Provider.of<CarProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'GPS TRACKING',
          style: AppTextStyles.heading3.copyWith(letterSpacing: 2),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshLocation,
            tooltip: 'Refresh Location',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isRefreshing)
                const LinearProgressIndicator(
                  minHeight: 2,
                  color: Colors.tealAccent,
                  backgroundColor: Colors.transparent,
                ),
              const SizedBox(height: 12),
              // Location Status
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1a1a1a),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF2a2a2a),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.teal.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.tealAccent,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CURRENT LOCATION',
                            style: AppTextStyles.heading3.copyWith(
                              color: Colors.tealAccent,
                              fontSize: 12,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (car.currentLocation != null)
                            Text(
                              LocationService.formatCoordinates(
                                car.currentLocation!,
                              ),
                              style: AppTextStyles.body1.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          else
                            Text(
                              'Acquiring location...',
                              style: AppTextStyles.body2.copyWith(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Location Details
              if (car.currentLocation != null) ...[
                _buildInfoTile(
                  'Latitude',
                  car.currentLocation!.latitude.toStringAsFixed(6),
                  Icons.explore,
                ),
                _buildInfoTile(
                  'Longitude',
                  car.currentLocation!.longitude.toStringAsFixed(6),
                  Icons.explore_outlined,
                ),
                _buildInfoTile(
                  'Accuracy',
                  '±${car.currentLocation!.accuracy.toStringAsFixed(1)}m',
                  Icons.my_location,
                ),
                _buildInfoTile(
                  'Altitude',
                  '${car.currentLocation!.altitude.toStringAsFixed(1)}m',
                  Icons.landscape,
                ),
              ],

              const SizedBox(height: 24),

              // Map View (with fallback if Google Maps unavailable)
              if (car.currentLocation != null)
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1a1a1a),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF2a2a2a),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Stack(
                      children: [
                        // Styled map background
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF0a0a0a), Color(0xFF1a1a1a)],
                            ),
                          ),
                          child: CustomPaint(
                            painter: _MapGridPainter(),
                            size: Size.infinite,
                          ),
                        ),

                        // Center location marker
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF64FFDA,
                                  ).withOpacity(0.2),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF64FFDA),
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF64FFDA,
                                      ).withOpacity(0.5),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.location_on,
                                  size: 40,
                                  color: Color(0xFF64FFDA),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF1a1a1a,
                                  ).withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(0xFF64FFDA),
                                  ),
                                ),
                                child: Text(
                                  'VEHICLE HERE',
                                  style: AppTextStyles.heading3.copyWith(
                                    color: const Color(0xFF64FFDA),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Coordinates overlay
                        Positioned(
                          top: 16,
                          left: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1a1a1a).withOpacity(0.95),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF64FFDA).withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              LocationService.formatCoordinates(
                                car.currentLocation!,
                              ),
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // Action Buttons
              if (car.currentLocation != null)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _openInMaps(car.currentLocation!),
                        icon: const Icon(Icons.map, color: Colors.black),
                        label: Text(
                          'Open in Maps',
                          style: AppTextStyles.body1.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF64FFDA),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Share location
                          final url = LocationService.getGoogleMapsUrl(
                            car.currentLocation!,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Location: $url',
                                style: AppTextStyles.body2,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.share, color: Color(0xFF64FFDA)),
                        label: Text(
                          'Share',
                          style: AppTextStyles.body1.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF64FFDA),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF64FFDA),
                          side: const BorderSide(
                            color: Color(0xFF64FFDA),
                            width: 2,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.tealAccent, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.body2.copyWith(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.numbers.copyWith(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for map grid background
class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Main grid lines
    final mainGridPaint = Paint()
      ..color = const Color(0xFF2a2a2a)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += 50) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), mainGridPaint);
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += 50) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), mainGridPaint);
    }

    // Accent lines
    final accentPaint = Paint()
      ..color = const Color(0xFF64FFDA).withOpacity(0.15)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Diagonal accents
    for (double i = -size.height; i < size.width; i += 100) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        accentPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
