import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/car_provider.dart';

/// Vehicle Visualization Widget
/// Shows a top-down view of the car with door/window status
class VehicleVisualization extends StatelessWidget {
  const VehicleVisualization({super.key});

  @override
  Widget build(BuildContext context) {
    final car = Provider.of<CarProvider>(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.8,
          colors: [const Color(0xFF1a1a1a), const Color(0xFF0a0a0a)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: AspectRatio(
        aspectRatio: 1.2,
        child: CustomPaint(
          painter: CarPainter(
            doorFL: car.doorFL,
            doorFR: car.doorFR,
            doorRL: car.doorRL,
            doorRR: car.doorRR,
            windowFL: car.windowFL,
            windowFR: car.windowFR,
            windowRL: car.windowRL,
            windowRR: car.windowRR,
            trunkOpen: car.trunkOpen,
            frunkOpen: car.frunkOpen,
            sunroofPosition: car.sunroofPosition,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF64FFDA), Color(0xFF1E88E5)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF64FFDA).withOpacity(0.5),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.white, Colors.white70],
                    ).createShader(bounds),
                    child: const Text(
                      'AUTOFLUX',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom Painter for Car Visualization
class CarPainter extends CustomPainter {
  final bool doorFL, doorFR, doorRL, doorRR;
  final double windowFL, windowFR, windowRL, windowRR;
  final bool trunkOpen, frunkOpen;
  final double sunroofPosition;

  CarPainter({
    required this.doorFL,
    required this.doorFR,
    required this.doorRL,
    required this.doorRR,
    required this.windowFL,
    required this.windowFR,
    required this.windowRL,
    required this.windowRR,
    required this.trunkOpen,
    required this.frunkOpen,
    required this.sunroofPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final carWidth = size.width * 0.55;
    final carHeight = size.height * 0.75;

    // Draw shadows first
    _drawShadow(canvas, center, carWidth, carHeight);

    // Draw car body with gradient
    _drawCarBody(canvas, center, carWidth, carHeight);

    // Draw windshields
    _drawWindshields(canvas, center, carWidth, carHeight);

    // Draw doors and windows
    _drawDoorAndWindow(
      canvas,
      center,
      carWidth,
      carHeight,
      'FL',
      doorFL,
      windowFL,
    );
    _drawDoorAndWindow(
      canvas,
      center,
      carWidth,
      carHeight,
      'FR',
      doorFR,
      windowFR,
    );
    _drawDoorAndWindow(
      canvas,
      center,
      carWidth,
      carHeight,
      'RL',
      doorRL,
      windowRL,
    );
    _drawDoorAndWindow(
      canvas,
      center,
      carWidth,
      carHeight,
      'RR',
      doorRR,
      windowRR,
    );

    // Draw trunk and frunk
    _drawTrunkFrunk(canvas, center, carWidth, carHeight);

    // Draw sunroof
    if (sunroofPosition > 0) {
      _drawSunroof(canvas, center, carWidth, carHeight);
    }

    // Draw hood lines
    _drawBodyDetails(canvas, center, carWidth, carHeight);
  }

  void _drawShadow(Canvas canvas, Offset center, double width, double height) {
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    // Outer shadow
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy + 5),
          width: width * 1.15,
          height: height * 1.08,
        ),
        const Radius.circular(30),
      ),
      shadowPaint,
    );
  }

  void _drawCarBody(Canvas canvas, Offset center, double width, double height) {
    // Main body with metallic gradient
    final bodyGradient = Paint()
      ..shader =
          LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF3a3a3a),
              const Color(0xFF2a2a2a),
              const Color(0xFF1a1a1a),
              const Color(0xFF0a0a0a),
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ).createShader(
            Rect.fromCenter(center: center, width: width, height: height),
          );

    final bodyPath = Path();

    // Sleek sedan shape with curves
    bodyPath.moveTo(center.dx - width / 2 + 25, center.dy - height / 2);
    bodyPath.quadraticBezierTo(
      center.dx - width / 2 + 5,
      center.dy - height / 2 + 10,
      center.dx - width / 2,
      center.dy - height / 2 + 45,
    );
    bodyPath.lineTo(center.dx - width / 2, center.dy + height / 2 - 45);
    bodyPath.quadraticBezierTo(
      center.dx - width / 2 + 5,
      center.dy + height / 2 - 10,
      center.dx - width / 2 + 25,
      center.dy + height / 2,
    );
    bodyPath.lineTo(center.dx + width / 2 - 25, center.dy + height / 2);
    bodyPath.quadraticBezierTo(
      center.dx + width / 2 - 5,
      center.dy + height / 2 - 10,
      center.dx + width / 2,
      center.dy + height / 2 - 45,
    );
    bodyPath.lineTo(center.dx + width / 2, center.dy - height / 2 + 45);
    bodyPath.quadraticBezierTo(
      center.dx + width / 2 - 5,
      center.dy - height / 2 + 10,
      center.dx + width / 2 - 25,
      center.dy - height / 2,
    );
    bodyPath.close();

    canvas.drawPath(bodyPath, bodyGradient);

    // Body outline with glow
    final outlinePaint = Paint()
      ..color = const Color(0xFF64FFDA).withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 3);
    canvas.drawPath(bodyPath, outlinePaint);

    // Inner outline for depth
    final innerOutline = Paint()
      ..color = const Color(0xFF64FFDA).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawPath(bodyPath, innerOutline);

    // Metallic highlights
    final highlightPaint = Paint()
      ..shader =
          LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [Colors.white.withOpacity(0.2), Colors.transparent],
          ).createShader(
            Rect.fromLTWH(
              center.dx - width / 2 + 25,
              center.dy - height / 2,
              width - 50,
              height * 0.3,
            ),
          )
      ..style = PaintingStyle.fill;

    final highlightPath = Path();
    highlightPath.moveTo(
      center.dx - width / 2 + 30,
      center.dy - height / 2 + 5,
    );
    highlightPath.lineTo(
      center.dx + width / 2 - 30,
      center.dy - height / 2 + 5,
    );
    highlightPath.lineTo(
      center.dx + width / 2 - 35,
      center.dy - height / 2 + 40,
    );
    highlightPath.lineTo(
      center.dx - width / 2 + 35,
      center.dy - height / 2 + 40,
    );
    highlightPath.close();
    canvas.drawPath(highlightPath, highlightPaint);

    // Side contour lines
    final contourPaint = Paint()
      ..color = const Color(0xFF64FFDA).withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawLine(
      Offset(center.dx - width / 2 + 8, center.dy - height / 3),
      Offset(center.dx - width / 2 + 8, center.dy + height / 3),
      contourPaint,
    );

    canvas.drawLine(
      Offset(center.dx + width / 2 - 8, center.dy - height / 3),
      Offset(center.dx + width / 2 - 8, center.dy + height / 3),
      contourPaint,
    );
  }

  void _drawWindshields(
    Canvas canvas,
    Offset center,
    double width,
    double height,
  ) {
    // Enhanced windshield gradient
    final windshieldPaint = Paint()
      ..shader =
          LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF64FFDA).withOpacity(0.25),
              const Color(0xFF1E88E5).withOpacity(0.35),
              const Color(0xFF64FFDA).withOpacity(0.2),
            ],
            stops: const [0.0, 0.5, 1.0],
          ).createShader(
            Rect.fromCenter(
              center: center,
              width: width * 0.6,
              height: height * 0.25,
            ),
          );

    // Front windshield with better shape
    final frontWindshield = Path();
    frontWindshield.moveTo(center.dx - width * 0.25, center.dy - height * 0.25);
    frontWindshield.lineTo(center.dx + width * 0.25, center.dy - height * 0.25);
    frontWindshield.quadraticBezierTo(
      center.dx + width * 0.23,
      center.dy - height * 0.3,
      center.dx + width * 0.22,
      center.dy - height * 0.35,
    );
    frontWindshield.lineTo(center.dx - width * 0.22, center.dy - height * 0.35);
    frontWindshield.quadraticBezierTo(
      center.dx - width * 0.23,
      center.dy - height * 0.3,
      center.dx - width * 0.25,
      center.dy - height * 0.25,
    );
    frontWindshield.close();
    canvas.drawPath(frontWindshield, windshieldPaint);

    // Windshield outline
    final windshieldOutline = Paint()
      ..color = const Color(0xFF64FFDA).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(frontWindshield, windshieldOutline);

    // Rear windshield
    final rearWindshield = Path();
    rearWindshield.moveTo(center.dx - width * 0.25, center.dy + height * 0.25);
    rearWindshield.lineTo(center.dx + width * 0.25, center.dy + height * 0.25);
    rearWindshield.quadraticBezierTo(
      center.dx + width * 0.23,
      center.dy + height * 0.3,
      center.dx + width * 0.22,
      center.dy + height * 0.35,
    );
    rearWindshield.lineTo(center.dx - width * 0.22, center.dy + height * 0.35);
    rearWindshield.quadraticBezierTo(
      center.dx - width * 0.23,
      center.dy + height * 0.3,
      center.dx - width * 0.25,
      center.dy + height * 0.25,
    );
    rearWindshield.close();
    canvas.drawPath(rearWindshield, windshieldPaint);
    canvas.drawPath(rearWindshield, windshieldOutline);

    // Glass reflection effect
    final reflectionPaint = Paint()
      ..shader =
          LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.center,
            colors: [Colors.white.withOpacity(0.3), Colors.transparent],
          ).createShader(
            Rect.fromLTWH(
              center.dx - width * 0.25,
              center.dy - height * 0.35,
              width * 0.5,
              height * 0.1,
            ),
          );

    final reflectionPath = Path();
    reflectionPath.moveTo(center.dx - width * 0.22, center.dy - height * 0.35);
    reflectionPath.lineTo(center.dx + width * 0.22, center.dy - height * 0.35);
    reflectionPath.lineTo(center.dx + width * 0.2, center.dy - height * 0.3);
    reflectionPath.lineTo(center.dx - width * 0.2, center.dy - height * 0.3);
    reflectionPath.close();
    canvas.drawPath(reflectionPath, reflectionPaint);
  }

  void _drawDoorAndWindow(
    Canvas canvas,
    Offset center,
    double width,
    double height,
    String position,
    bool doorOpen,
    double windowOpen,
  ) {
    final isLeft = position.endsWith('L');
    final isFront = position.startsWith('F');

    final xOffset = isLeft ? -width * 0.32 : width * 0.32;
    final yOffset = isFront ? -height * 0.15 : height * 0.15;

    final doorCenter = Offset(center.dx + xOffset, center.dy + yOffset);
    final doorWidth = width * 0.15;
    final doorHeight = height * 0.22;

    // Door indicator with gradient when closed
    final doorPaint = Paint()..style = PaintingStyle.fill;

    if (doorOpen) {
      doorPaint.color = const Color(0xFF64FFDA);
    } else {
      doorPaint.shader =
          LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF3a3a3a),
              const Color(0xFF2a2a2a),
              const Color(0xFF1a1a1a),
            ],
          ).createShader(
            Rect.fromCenter(
              center: doorCenter,
              width: doorWidth,
              height: doorHeight,
            ),
          );
    }

    final doorOutline = Paint()
      ..color = doorOpen
          ? const Color(0xFF64FFDA)
          : const Color(0xFF64FFDA).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = doorOpen ? 3 : 1.8;

    final doorRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: doorCenter, width: doorWidth, height: doorHeight),
      const Radius.circular(8),
    );

    if (doorOpen) {
      // Enhanced glow effect when door is open
      final glowPaint = Paint()
        ..color = const Color(0xFF64FFDA).withOpacity(0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      canvas.drawRRect(doorRect, glowPaint);

      // Outer glow
      final outerGlowPaint = Paint()
        ..color = const Color(0xFF64FFDA).withOpacity(0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
      canvas.drawRRect(doorRect, outerGlowPaint);
    }

    canvas.drawRRect(doorRect, doorPaint);
    canvas.drawRRect(doorRect, doorOutline);

    // Window indicator inside door with enhanced gradient
    final windowOpacity = (100 - windowOpen) / 100;
    if (windowOpacity > 0.1) {
      final windowPaint = Paint()
        ..shader =
            LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF64FFDA).withOpacity(0.5 * windowOpacity),
                const Color(0xFF1E88E5).withOpacity(0.4 * windowOpacity),
                const Color(0xFF64FFDA).withOpacity(0.3 * windowOpacity),
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(
              Rect.fromCenter(
                center: doorCenter,
                width: doorWidth * 0.7,
                height: doorHeight * 0.6,
              ),
            );

      final windowRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: doorCenter,
          width: doorWidth * 0.7,
          height: doorHeight * 0.6,
        ),
        const Radius.circular(5),
      );

      canvas.drawRRect(windowRect, windowPaint);

      // Window outline
      final windowOutlinePaint = Paint()
        ..color = const Color(0xFF64FFDA).withOpacity(0.4 * windowOpacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawRRect(windowRect, windowOutlinePaint);
    }

    // Enhanced door handle indicator
    final handlePaint = Paint()
      ..color = doorOpen
          ? const Color(0xFF64FFDA)
          : Colors.white.withOpacity(0.5);

    final handleGlowPaint = Paint()
      ..color = (doorOpen ? const Color(0xFF64FFDA) : Colors.white).withOpacity(
        0.3,
      )
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final handleOffset = Offset(
      doorCenter.dx + (isLeft ? doorWidth * 0.3 : -doorWidth * 0.3),
      doorCenter.dy,
    );

    canvas.drawCircle(handleOffset, 4, handleGlowPaint);
    canvas.drawCircle(handleOffset, 3, handlePaint);

    // Door position label with enhanced styling
    final textPainter = TextPainter(
      text: TextSpan(
        text: position,
        style: TextStyle(
          color: doorOpen
              ? const Color(0xFF64FFDA)
              : Colors.white.withOpacity(0.6),
          fontSize: 11,
          fontWeight: FontWeight.bold,
          shadows: doorOpen
              ? [
                  Shadow(
                    color: const Color(0xFF64FFDA).withOpacity(0.5),
                    blurRadius: 4,
                  ),
                ]
              : null,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        doorCenter.dx - textPainter.width / 2,
        doorCenter.dy + doorHeight / 2 + 8,
      ),
    );
  }

  void _drawTrunkFrunk(
    Canvas canvas,
    Offset center,
    double width,
    double height,
  ) {
    final openPaint = Paint()
      ..color = const Color(0xFF64FFDA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    // Frunk indicator (front)
    if (frunkOpen) {
      final frunkPath = Path();
      frunkPath.moveTo(center.dx - width * 0.2, center.dy - height * 0.38);
      frunkPath.lineTo(center.dx + width * 0.2, center.dy - height * 0.38);
      canvas.drawPath(frunkPath, openPaint);

      // Glow effect
      final glowPaint = Paint()
        ..color = const Color(0xFF64FFDA).withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
      canvas.drawPath(frunkPath, glowPaint);
    }

    // Trunk indicator (rear)
    if (trunkOpen) {
      final trunkPath = Path();
      trunkPath.moveTo(center.dx - width * 0.2, center.dy + height * 0.38);
      trunkPath.lineTo(center.dx + width * 0.2, center.dy + height * 0.38);
      canvas.drawPath(trunkPath, openPaint);

      // Glow effect
      final glowPaint = Paint()
        ..color = const Color(0xFF64FFDA).withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
      canvas.drawPath(trunkPath, glowPaint);
    }
  }

  void _drawSunroof(Canvas canvas, Offset center, double width, double height) {
    // Enhanced sunroof with gradient
    final sunroofPaint = Paint()
      ..shader =
          RadialGradient(
            colors: [
              const Color(0xFF64FFDA).withOpacity(sunroofPosition / 100 * 0.7),
              const Color(0xFF1E88E5).withOpacity(sunroofPosition / 100 * 0.5),
              const Color(0xFF64FFDA).withOpacity(sunroofPosition / 100 * 0.3),
            ],
            stops: const [0.0, 0.5, 1.0],
          ).createShader(
            Rect.fromCenter(
              center: Offset(center.dx, center.dy - height * 0.05),
              width: width * 0.35,
              height: height * 0.2,
            ),
          );

    final sunroofRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy - height * 0.05),
        width: width * 0.35,
        height: height * 0.2,
      ),
      const Radius.circular(12),
    );

    // Glow effect
    if (sunroofPosition > 10) {
      final glowPaint = Paint()
        ..color = const Color(
          0xFF64FFDA,
        ).withOpacity(sunroofPosition / 100 * 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawRRect(sunroofRect, glowPaint);
    }

    canvas.drawRRect(sunroofRect, sunroofPaint);

    // Sunroof outline with glow
    final outlinePaint = Paint()
      ..color = const Color(0xFF64FFDA).withOpacity(sunroofPosition / 100 * 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.drawRRect(sunroofRect, outlinePaint);

    // Inner highlight
    if (sunroofPosition > 20) {
      final innerHighlight = Paint()
        ..shader =
            LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [
                Colors.white.withOpacity(sunroofPosition / 100 * 0.3),
                Colors.transparent,
              ],
            ).createShader(
              Rect.fromCenter(
                center: Offset(center.dx, center.dy - height * 0.08),
                width: width * 0.3,
                height: height * 0.08,
              ),
            );

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(center.dx, center.dy - height * 0.08),
            width: width * 0.3,
            height: height * 0.08,
          ),
          const Radius.circular(10),
        ),
        innerHighlight,
      );
    }
  }

  void _drawBodyDetails(
    Canvas canvas,
    Offset center,
    double width,
    double height,
  ) {
    final detailPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    // Hood line with gradient effect
    canvas.drawLine(
      Offset(center.dx - width * 0.3, center.dy - height * 0.1),
      Offset(center.dx + width * 0.3, center.dy - height * 0.1),
      detailPaint,
    );

    // Trunk line
    canvas.drawLine(
      Offset(center.dx - width * 0.3, center.dy + height * 0.1),
      Offset(center.dx + width * 0.3, center.dy + height * 0.1),
      detailPaint,
    );

    // Enhanced side accent lines
    final accentPaint = Paint()
      ..color = const Color(0xFF64FFDA).withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    // Left side
    canvas.drawLine(
      Offset(center.dx - width * 0.28, center.dy - height * 0.3),
      Offset(center.dx - width * 0.28, center.dy + height * 0.3),
      accentPaint,
    );

    // Right side
    canvas.drawLine(
      Offset(center.dx + width * 0.28, center.dy - height * 0.3),
      Offset(center.dx + width * 0.28, center.dy + height * 0.3),
      accentPaint,
    );
  }

  @override
  bool shouldRepaint(CarPainter oldDelegate) {
    return doorFL != oldDelegate.doorFL ||
        doorFR != oldDelegate.doorFR ||
        doorRL != oldDelegate.doorRL ||
        doorRR != oldDelegate.doorRR ||
        windowFL != oldDelegate.windowFL ||
        windowFR != oldDelegate.windowFR ||
        windowRL != oldDelegate.windowRL ||
        windowRR != oldDelegate.windowRR ||
        trunkOpen != oldDelegate.trunkOpen ||
        frunkOpen != oldDelegate.frunkOpen ||
        sunroofPosition != oldDelegate.sunroofPosition;
  }
}
