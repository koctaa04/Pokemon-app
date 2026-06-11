import 'dart:math' as math;

import 'package:flutter/material.dart';

class AnimatedPokeball extends StatelessWidget {
  const AnimatedPokeball({
    super.key,
    required this.size,
    this.rotationTurns = 0,
    this.opacity = 1,
    this.scale = 1,
  });

  final double size;
  final double rotationTurns;
  final double opacity;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: rotationTurns * math.pi * 2,
        child: Transform.scale(
          scale: scale,
          child: SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: _PokeballPainter(),
            ),
          ),
        ),
      ),
    );
  }
}

class _PokeballPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final outerRect = Rect.fromCircle(center: center, radius: radius);
    final strokeWidth = size.width * 0.075;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.16)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
    canvas.drawCircle(center.translate(0, 12), radius * 0.95, shadowPaint);

    final whitePaint = Paint()..color = Colors.white.withOpacity(0.92);
    canvas.drawCircle(center, radius, whitePaint);

    canvas.save();
    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height / 2));
    final redPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFF6A5F), Color(0xFFE53935)],
      ).createShader(outerRect);
    canvas.drawCircle(center, radius, redPaint);
    canvas.restore();

    final rimPaint = Paint()
      ..color = const Color(0xFF1F1F1F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius - strokeWidth / 2, rimPaint);

    final dividerPaint = Paint()
      ..color = const Color(0xFF1F1F1F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 0.72;
    canvas.drawLine(
      Offset(radius * 0.08, center.dy),
      Offset(size.width - radius * 0.08, center.dy),
      dividerPaint,
    );

    final outerButtonPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius * 0.22, outerButtonPaint);

    final buttonRingPaint = Paint()
      ..color = const Color(0xFF1F1F1F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 0.78;
    canvas.drawCircle(center, radius * 0.22, buttonRingPaint);

    final buttonCorePaint = Paint()..color = const Color(0xFFF3F4F6);
    canvas.drawCircle(center, radius * 0.10, buttonCorePaint);

    final highlightPaint = Paint()..color = Colors.white.withOpacity(0.14);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.34, size.height * 0.28),
        width: size.width * 0.32,
        height: size.height * 0.16,
      ),
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}