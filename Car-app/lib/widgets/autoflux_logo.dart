import 'package:flutter/material.dart';

/// AUTOFLUX Logo Widget
/// Custom painted logo with car and sun design
class AutofluxLogo extends StatelessWidget {
  final double size;
  final bool showText;

  const AutofluxLogo({super.key, this.size = 200, this.showText = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: showText ? size * 1.2 : size * 0.85,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo graphic
          CustomPaint(
            size: Size(size, size * 0.75),
            painter: _AutofluxLogoPainter(),
          ),
          if (showText) ...[
            SizedBox(height: size * 0.08),
            // AUTOFLUX text
            Flexible(
              child: Text(
                'AUTOFLUX',
                style: TextStyle(
                  fontSize: size * 0.16,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      color: const Color(0xFF64FFDA).withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AutofluxLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Orange sun
    paint.color = const Color(0xFFF5A962);
    canvas.drawCircle(
      Offset(size.width * 0.65, size.height * 0.25),
      size.width * 0.28,
      paint,
    );

    // White speed lines on sun
    paint
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02
      ..strokeCap = StrokeCap.round;

    final path1 = Path();
    path1.moveTo(size.width * 0.35, size.height * 0.18);
    path1.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.15,
      size.width * 0.85,
      size.height * 0.22,
    );
    canvas.drawPath(path1, paint);

    final path2 = Path();
    path2.moveTo(size.width * 0.28, size.height * 0.28);
    path2.quadraticBezierTo(
      size.width * 0.43,
      size.height * 0.26,
      size.width * 0.78,
      size.height * 0.32,
    );
    canvas.drawPath(path2, paint);

    // Car body shadow
    paint
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    final shadowOval = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.57),
        width: size.width * 0.7,
        height: size.height * 0.25,
      ),
      Radius.circular(size.width * 0.35),
    );
    canvas.drawRRect(shadowOval, paint);

    // Main car body (black)
    paint.color = Colors.black;
    final carBody = Path();
    carBody.moveTo(size.width * 0.15, size.height * 0.52);
    carBody.quadraticBezierTo(
      size.width * 0.18,
      size.height * 0.45,
      size.width * 0.28,
      size.height * 0.43,
    );
    carBody.lineTo(size.width * 0.45, size.height * 0.42);
    carBody.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.4,
      size.width * 0.5,
      size.height * 0.4,
    );
    carBody.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.4,
      size.width * 0.55,
      size.height * 0.42,
    );
    carBody.lineTo(size.width * 0.72, size.height * 0.43);
    carBody.quadraticBezierTo(
      size.width * 0.82,
      size.height * 0.45,
      size.width * 0.85,
      size.height * 0.52,
    );
    carBody.lineTo(size.width * 0.88, size.height * 0.58);
    carBody.quadraticBezierTo(
      size.width * 0.87,
      size.height * 0.63,
      size.width * 0.82,
      size.height * 0.64,
    );
    carBody.lineTo(size.width * 0.18, size.height * 0.64);
    carBody.quadraticBezierTo(
      size.width * 0.13,
      size.height * 0.63,
      size.width * 0.12,
      size.height * 0.58,
    );
    carBody.close();
    canvas.drawPath(carBody, paint);

    // Car roof/cabin
    final carRoof = Path();
    carRoof.moveTo(size.width * 0.32, size.height * 0.43);
    carRoof.quadraticBezierTo(
      size.width * 0.35,
      size.height * 0.35,
      size.width * 0.43,
      size.height * 0.33,
    );
    carRoof.lineTo(size.width * 0.57, size.height * 0.33);
    carRoof.quadraticBezierTo(
      size.width * 0.65,
      size.height * 0.35,
      size.width * 0.68,
      size.height * 0.43,
    );
    canvas.drawPath(carRoof, paint);

    // White outlines
    paint
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.008;
    canvas.drawPath(carBody, paint);
    canvas.drawPath(carRoof, paint);

    // Windshield highlight
    paint
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = size.width * 0.006;
    final windshield = Path();
    windshield.moveTo(size.width * 0.43, size.height * 0.36);
    windshield.quadraticBezierTo(
      size.width * 0.45,
      size.height * 0.37,
      size.width * 0.5,
      size.height * 0.37,
    );
    windshield.quadraticBezierTo(
      size.width * 0.55,
      size.height * 0.37,
      size.width * 0.57,
      size.height * 0.36,
    );
    canvas.drawPath(windshield, paint);

    // Hood lines
    paint
      ..color = Colors.white
      ..strokeWidth = size.width * 0.012
      ..strokeCap = StrokeCap.round;
    final hoodLine1 = Path();
    hoodLine1.moveTo(size.width * 0.15, size.height * 0.535);
    hoodLine1.quadraticBezierTo(
      size.width * 0.35,
      size.height * 0.51,
      size.width * 0.5,
      size.height * 0.508,
    );
    hoodLine1.quadraticBezierTo(
      size.width * 0.65,
      size.height * 0.51,
      size.width * 0.85,
      size.height * 0.535,
    );
    canvas.drawPath(hoodLine1, paint);

    paint.strokeWidth = size.width * 0.008;
    final hoodLine2 = Path();
    hoodLine2.moveTo(size.width * 0.18, size.height * 0.58);
    hoodLine2.quadraticBezierTo(
      size.width * 0.37,
      size.height * 0.56,
      size.width * 0.5,
      size.height * 0.558,
    );
    hoodLine2.quadraticBezierTo(
      size.width * 0.63,
      size.height * 0.56,
      size.width * 0.82,
      size.height * 0.58,
    );
    canvas.drawPath(hoodLine2, paint);

    // Front wheel
    _drawWheel(canvas, size, Offset(size.width * 0.28, size.height * 0.64));

    // Rear wheel
    _drawWheel(canvas, size, Offset(size.width * 0.72, size.height * 0.64));
  }

  void _drawWheel(Canvas canvas, Size size, Offset center) {
    final paint = Paint()..style = PaintingStyle.fill;

    final wheelRadius = size.width * 0.08;

    // Outer tire
    paint.color = Colors.black;
    canvas.drawCircle(center, wheelRadius, paint);

    // White rim
    paint
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.012;
    canvas.drawCircle(center, wheelRadius, paint);

    // Inner white circle
    paint
      ..style = PaintingStyle.fill
      ..color = Colors.white;
    canvas.drawCircle(center, wheelRadius * 0.62, paint);

    // Center hub
    paint.color = Colors.black;
    canvas.drawCircle(center, wheelRadius * 0.31, paint);

    // Teal glow effect
    paint
      ..color = const Color(0xFF64FFDA).withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(center, wheelRadius * 0.62, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
