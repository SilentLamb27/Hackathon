import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/car_provider.dart';
import '../utils/app_design_system.dart';

/// Summon Screen - Tesla Style
/// Press and hold to move vehicle with interactive map view
class SummonScreen extends StatefulWidget {
  const SummonScreen({super.key});

  @override
  State<SummonScreen> createState() => _SummonScreenState();
}

class _SummonScreenState extends State<SummonScreen>
    with SingleTickerProviderStateMixin {
  bool _isMovingForward = false;
  bool _isMovingBackward = false;
  double _carVerticalPosition = 0.0; // Position offset from center
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 100),
        )..addListener(() {
          setState(() {
            if (_isMovingForward) {
              _carVerticalPosition -= 2.0; // Move up
              _carVerticalPosition = _carVerticalPosition.clamp(-150.0, 150.0);
            } else if (_isMovingBackward) {
              _carVerticalPosition += 2.0; // Move down
              _carVerticalPosition = _carVerticalPosition.clamp(-150.0, 150.0);
            }
          });
          if (_isMovingForward || _isMovingBackward) {
            _animationController.forward(from: 0);
          }
        });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startMoving(bool forward) {
    setState(() {
      if (forward) {
        _isMovingForward = true;
      } else {
        _isMovingBackward = true;
      }
    });
    _animationController.repeat();
  }

  void _stopMoving() {
    setState(() {
      _isMovingForward = false;
      _isMovingBackward = false;
    });
    _animationController.stop();
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
          'SUMMON',
          style: AppTextStyles.heading3.copyWith(letterSpacing: 2),
        ),
      ),
      body: Column(
        children: [
          // Map View with Styled Background
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1a1a1a),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF2a2a2a), width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  children: [
                    // Styled map background
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF0a0a0a),
                            Color(0xFF1a1a1a),
                            Color(0xFF0a0a0a),
                          ],
                        ),
                      ),
                      child: CustomPaint(
                        painter: _SummonMapPainter(),
                        size: Size.infinite,
                      ),
                    ),

                    // Location Info Overlay
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
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Color(0xFFE82127),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'VEHICLE LOCATION',
                                    style: AppTextStyles.heading3.copyWith(
                                      color: const Color(0xFF64FFDA),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '3.1390°N, 101.6869°E',
                                    style: AppTextStyles.caption.copyWith(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Car Icon - Now Animated
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 100),
                      top:
                          (MediaQuery.of(context).size.height * 0.4) +
                          _carVerticalPosition,
                      left: 0,
                      right: 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE82127).withOpacity(0.2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFE82127),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFE82127,
                                  ).withOpacity(0.5),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.directions_car,
                              size: 40,
                              color: const Color(0xFFE82127),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1a1a1a).withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF2a2a2a),
                              ),
                            ),
                            child: Text(
                              (_isMovingForward || _isMovingBackward)
                                  ? 'MOVING...'
                                  : 'READY TO SUMMON',
                              style: AppTextStyles.heading3.copyWith(
                                color: (_isMovingForward || _isMovingBackward)
                                    ? const Color(0xFFFF9800)
                                    : const Color(0xFF64FFDA),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Distance Indicator
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1a1a1a).withOpacity(0.95),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF2a2a2a)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.straighten,
                              color: Color(0xFF64FFDA),
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '12m range',
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Instructions
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1a1a1a),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF3B82F6).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.info_outline,
                          color: Color(0xFF3B82F6),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Press and hold controls to move vehicle',
                          style: AppTextStyles.caption.copyWith(
                            color: const Color(0xFF9CA3AF),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Control Buttons
                Row(
                  children: [
                    // Forward Button
                    Expanded(
                      child: GestureDetector(
                        onLongPressStart: (_) {
                          _startMoving(true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Moving Forward...',
                                style: AppTextStyles.body1.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: const Color(0xFF64FFDA),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        onLongPressEnd: (_) {
                          _stopMoving();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Stopped',
                                style: AppTextStyles.body1.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: Colors.grey[700],
                              duration: const Duration(milliseconds: 500),
                            ),
                          );
                        },
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: _isMovingForward
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFF64FFDA),
                                      Color(0xFF14B8A6),
                                    ],
                                  )
                                : null,
                            color: _isMovingForward
                                ? null
                                : const Color(0xFF1a1a1a),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _isMovingForward
                                  ? const Color(0xFF64FFDA)
                                  : const Color(0xFF2a2a2a),
                              width: 2,
                            ),
                            boxShadow: _isMovingForward
                                ? [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF64FFDA,
                                      ).withOpacity(0.5),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_upward,
                                size: 40,
                                color: _isMovingForward
                                    ? Colors.white
                                    : Colors.grey[600],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'FORWARD',
                                style: AppTextStyles.body2.copyWith(
                                  color: _isMovingForward
                                      ? Colors.white
                                      : Colors.grey[600],
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Backward Button
                    Expanded(
                      child: GestureDetector(
                        onLongPressStart: (_) {
                          _startMoving(false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Moving Backward...',
                                style: AppTextStyles.body1.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: const Color(0xFFFF9800),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        onLongPressEnd: (_) {
                          _stopMoving();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Stopped',
                                style: AppTextStyles.body1.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: Colors.grey[700],
                              duration: const Duration(milliseconds: 500),
                            ),
                          );
                        },
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: _isMovingBackward
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFFFF9800),
                                      Color(0xFFF57C00),
                                    ],
                                  )
                                : null,
                            color: _isMovingBackward
                                ? null
                                : const Color(0xFF1a1a1a),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _isMovingBackward
                                  ? const Color(0xFFFF9800)
                                  : const Color(0xFF2a2a2a),
                              width: 2,
                            ),
                            boxShadow: _isMovingBackward
                                ? [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFFF9800,
                                      ).withOpacity(0.5),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_downward,
                                size: 40,
                                color: _isMovingBackward
                                    ? Colors.white
                                    : Colors.grey[600],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'BACKWARD',
                                style: AppTextStyles.body2.copyWith(
                                  color: _isMovingBackward
                                      ? Colors.white
                                      : Colors.grey[600],
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for summon map background
class _SummonMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Main street grid
    final streetPaint = Paint()
      ..color = const Color(0xFF2a2a2a)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Minor streets
    final minorStreetPaint = Paint()
      ..color = const Color(0xFF1a1a1a)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw main vertical streets
    for (double x = 0; x < size.width; x += 80) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), streetPaint);
    }

    // Draw main horizontal streets
    for (double y = 0; y < size.height; y += 80) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), streetPaint);
    }

    // Draw minor streets
    for (double x = 40; x < size.width; x += 80) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), minorStreetPaint);
    }
    for (double y = 40; y < size.height; y += 80) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), minorStreetPaint);
    }

    // Draw route path
    final routePaint = Paint()
      ..color = const Color(0xFF64FFDA).withOpacity(0.3)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width * 0.5, size.height * 0.85);
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.65,
      size.width * 0.5,
      size.height * 0.5,
    );
    canvas.drawPath(path, routePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
