import 'dart:math';

import 'package:flutter/material.dart';

class ConcreteWallPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(42); // fixed seed — same texture every time

    // 1. Base coat — dark warm concrete
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFF1C1917),
    );

    // 2. Coarse tonal patches
    final patchPaint = Paint()..blendMode = BlendMode.srcOver;
    for (int i = 0; i < 140; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final w = 50.0 + rng.nextDouble() * 130;
      final h = 35.0 + rng.nextDouble() * 100;
      final bright = rng.nextBool();
      patchPaint.color = bright
          ? Color.fromRGBO(38, 32, 26, rng.nextDouble() * 0.18)
          : Color.fromRGBO(6, 5, 4, rng.nextDouble() * 0.20);
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y), width: w, height: h),
        patchPaint,
      );
    }

    // 3. Medium grain — sand and aggregate
    final grainPaint = Paint();
    for (int i = 0; i < 5000; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final s = 1.0 + rng.nextDouble() * 2.5;
      final bright = rng.nextBool();
      grainPaint.color = bright
          ? Color.fromRGBO(255, 240, 215, rng.nextDouble() * 0.07)
          : Color.fromRGBO(0, 0, 0, rng.nextDouble() * 0.13);
      canvas.drawRect(Rect.fromLTWH(x, y, s, s), grainPaint);
    }

    // 4. Fine noise — micro surface texture
    final noisePaint = Paint();
    for (int i = 0; i < 10000; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      noisePaint.color = Color.fromRGBO(
        195 + rng.nextInt(60),
        175 + rng.nextInt(45),
        145 + rng.nextInt(35),
        rng.nextDouble() * 0.04,
      );
      canvas.drawRect(Rect.fromLTWH(x, y, 1, 1), noisePaint);
    }

    // 5. Vertical formwork streaks — faint lines from concrete mold
    final streakPaint = Paint()
      ..strokeWidth = 0.6
      ..style = PaintingStyle.stroke;
    for (int i = 0; i < 18; i++) {
      final x = rng.nextDouble() * size.width;
      final drift = rng.nextDouble() * 12 - 6;
      streakPaint.color =
          Color.fromRGBO(255, 255, 255, rng.nextDouble() * 0.025);
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + drift, size.height),
        streakPaint,
      );
    }
  }

  @override
  bool shouldRepaint(ConcreteWallPainter oldDelegate) => false;
}
