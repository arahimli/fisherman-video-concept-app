import 'dart:math';

import 'package:flutter/material.dart';

class SolarPlanet {
  final double angleOffset;
  final double radius;
  final Color color;
  final bool glowing;

  const SolarPlanet({
    required this.angleOffset,
    required this.radius,
    required this.color,
    this.glowing = false,
  });
}

class SolarSystemPainter extends CustomPainter {
  final double progress;

  SolarSystemPainter(this.progress);

  static const _tau = 2 * pi;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final w = size.width;

    // ── Ring 1 — inner, 3 full rotations/cycle, clockwise ───────────────────
    _drawRing(
      canvas, center,
      radius: w * 0.20,
      baseAngle: progress * _tau * 3,
      strokeWidth: 0.8,
      ringColor: const Color(0x4DB8956A),
      planets: const [
        SolarPlanet(angleOffset: 0, radius: 3.5, color: Color(0xFFB8956A), glowing: true),
      ],
    );

    // ── Ring 2 — middle, 2 full rotations/cycle, counter-clockwise ──────────
    _drawRing(
      canvas, center,
      radius: w * 0.31,
      baseAngle: -progress * _tau * 2,
      strokeWidth: 0.6,
      ringColor: const Color(0x33B8956A),
      planets: const [
        SolarPlanet(angleOffset: 0,          radius: 2.8, color: Color(0x99FFFFFF)),
        SolarPlanet(angleOffset: pi * 0.75,  radius: 3.2, color: Color(0x99B8956A)),
      ],
    );

    // ── Ring 3 — outer, 1 full rotation/cycle, clockwise ────────────────────
    _drawRing(
      canvas, center,
      radius: w * 0.43,
      baseAngle: progress * _tau * 1,
      strokeWidth: 0.5,
      ringColor: const Color(0x26B8956A),
      planets: const [
        SolarPlanet(angleOffset: 0,         radius: 2.2, color: Color(0x66FFFFFF)),
        SolarPlanet(angleOffset: pi * 1.3,  radius: 2.6, color: Color(0x55B8956A)),
        SolarPlanet(angleOffset: pi * 0.45, radius: 1.8, color: Color(0x44FFFFFF)),
      ],
    );
  }

  void _drawRing(
    Canvas canvas,
    Offset center, {
    required double radius,
    required double baseAngle,
    required double strokeWidth,
    required Color ringColor,
    required List<SolarPlanet> planets,
  }) {
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = ringColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    for (final planet in planets) {
      final angle = baseAngle + planet.angleOffset;
      final pos = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );

      if (planet.glowing) {
        canvas.drawCircle(
          pos,
          planet.radius + 3.5,
          Paint()
            ..color = planet.color.withAlpha(50)
            ..style = PaintingStyle.fill
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
        );
      }

      canvas.drawCircle(
        pos,
        planet.radius,
        Paint()
          ..color = planet.color
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(SolarSystemPainter old) => old.progress != progress;
}
