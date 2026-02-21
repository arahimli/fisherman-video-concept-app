import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/design/design_system.dart';
import '../../core/router/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Logo: fade + scale (Uber style)
  late Animation<double> _logoFade;
  late Animation<double> _logoScale;

  // Exit
  late Animation<double> _exitFade;

  static const _totalMs = 3200;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _totalMs),
    );

    // 0–35%: logo fades in
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
      ),
    );

    // 0–40%: logo scales from slightly small to natural size
    _logoScale = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.40, curve: Curves.easeOutCubic),
      ),
    );

    // 78–100%: everything fades out
    _exitFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.78, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        context.go(AppRoutes.home);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final logoSize = size.width * 0.68;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return FadeTransition(
            opacity: _exitFade,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // ── Concrete wall texture ─────────────────────────────────
                CustomPaint(
                  painter: _ConcreteWallPainter(),
                  size: size,
                  isComplex: true,
                  willChange: false,
                ),

                // ── Radial vignette (darker edges, lighter center) ────────
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.1,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.65),
                      ],
                    ),
                  ),
                ),

                // ── Logo ─────────────────────────────────────────────────
                Center(
                  child: Opacity(
                    opacity: _logoFade.value,
                    child: Transform.scale(
                      scale: _logoScale.value,
                      child: Image.asset(
                        'assets/images/logo_main.png',
                        width: logoSize,
                        height: logoSize,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Concrete Wall Painter ──────────────────────────────────────────────────────

class _ConcreteWallPainter extends CustomPainter {
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
  bool shouldRepaint(_ConcreteWallPainter oldDelegate) => false;
}
