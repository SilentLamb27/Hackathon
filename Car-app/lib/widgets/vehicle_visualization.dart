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
                Text(
                  'SU7',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.3),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
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
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final fillPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final openPaint = Paint()
      ..color = const Color(0xFF64FFDA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final windowPaint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final carWidth = size.width * 0.6;
    final carHeight = size.height * 0.8;

    // Car body
    final carRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: carWidth, height: carHeight),
      const Radius.circular(20),
    );
    canvas.drawRRect(carRect, fillPaint);
    canvas.drawRRect(carRect, paint);

    // Doors
    final doorWidth = carWidth * 0.4;
    final doorHeight = carHeight * 0.35;
    final doorOffset = carWidth * 0.05;

    // Front Left Door
    _drawDoor(
      canvas,
      Offset(center.dx - carWidth / 2 + doorOffset, center.dy - carHeight / 4),
      doorWidth,
      doorHeight,
      doorFL,
      paint,
      openPaint,
      true,
    );

    // Front Right Door
    _drawDoor(
      canvas,
      Offset(
        center.dx + carWidth / 2 - doorOffset - doorWidth,
        center.dy - carHeight / 4,
      ),
      doorWidth,
      doorHeight,
      doorFR,
      paint,
      openPaint,
      false,
    );

    // Rear Left Door
    _drawDoor(
      canvas,
      Offset(center.dx - carWidth / 2 + doorOffset, center.dy + carHeight / 4),
      doorWidth,
      doorHeight,
      doorRL,
      paint,
      openPaint,
      true,
    );

    // Rear Right Door
    _drawDoor(
      canvas,
      Offset(
        center.dx + carWidth / 2 - doorOffset - doorWidth,
        center.dy + carHeight / 4,
      ),
      doorWidth,
      doorHeight,
      doorRR,
      paint,
      openPaint,
      false,
    );

    // Windows with opacity based on openness
    _drawWindow(
      canvas,
      center.dx - carWidth / 4,
      center.dy - carHeight / 4,
      windowFL,
      windowPaint,
    );
    _drawWindow(
      canvas,
      center.dx + carWidth / 4,
      center.dy - carHeight / 4,
      windowFR,
      windowPaint,
    );
    _drawWindow(
      canvas,
      center.dx - carWidth / 4,
      center.dy + carHeight / 4,
      windowRL,
      windowPaint,
    );
    _drawWindow(
      canvas,
      center.dx + carWidth / 4,
      center.dy + carHeight / 4,
      windowRR,
      windowPaint,
    );

    // Frunk (front trunk)
    if (frunkOpen) {
      canvas.drawLine(
        Offset(center.dx - carWidth / 4, center.dy - carHeight / 2),
        Offset(center.dx + carWidth / 4, center.dy - carHeight / 2),
        openPaint,
      );
    }

    // Trunk (rear)
    if (trunkOpen) {
      canvas.drawLine(
        Offset(center.dx - carWidth / 4, center.dy + carHeight / 2),
        Offset(center.dx + carWidth / 4, center.dy + carHeight / 2),
        openPaint,
      );
    }

    // Sunroof
    if (sunroofPosition > 0) {
      final sunroofPaint = Paint()
        ..color = const Color(0xFF64FFDA).withOpacity(sunroofPosition / 100)
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: center,
            width: carWidth * 0.4,
            height: carHeight * 0.2,
          ),
          const Radius.circular(10),
        ),
        sunroofPaint,
      );
    }
  }

  void _drawDoor(
    Canvas canvas,
    Offset position,
    double width,
    double height,
    bool isOpen,
    Paint normalPaint,
    Paint openPaint,
    bool isLeft,
  ) {
    final rect = Rect.fromLTWH(position.dx, position.dy, width, height);
    canvas.drawRect(rect, isOpen ? openPaint : normalPaint);
  }

  void _drawWindow(
    Canvas canvas,
    double x,
    double y,
    double openness,
    Paint paint,
  ) {
    final windowSize = 30.0;
    final adjustedPaint = Paint()
      ..color = paint.color.withOpacity((100 - openness) / 100 * 0.3)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(x, y),
          width: windowSize,
          height: windowSize,
        ),
        const Radius.circular(5),
      ),
      adjustedPaint,
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
