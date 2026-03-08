import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/design/design_system.dart';
import '../../core/di/service_locator.dart';
import '../../core/router/app_routes.dart';
import '../../data/services/force_update_service.dart';
import '../widgets/splash/concrete_wall_painter.dart';
import '../widgets/splash/splash_logo_animation.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Entry: small → natural size, fades in
  late Animation<double> _entryScale;
  late Animation<double> _entryFade;

  // Exit: natural size → oversized, fades out (burst)
  late Animation<double> _exitScale;
  late Animation<double> _exitFade;

  static const _totalMs = 4500;

  // Force update check runs in parallel with the animation
  late final Future<ForceUpdateResult> _updateCheckFuture;

  @override
  void initState() {
    super.initState();

    // Kick off update check immediately — runs in parallel with the animation
    _updateCheckFuture = sl<ForceUpdateService>().fetchAndCheck();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _totalMs),
    );

    // 0–38%: logo scales in from 0.70 → 1.0 and fades in
    _entryScale = Tween<double>(begin: 0.70, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.38, curve: Curves.easeOutCubic),
      ),
    );

    _entryFade = Tween<double>(begin: 0.0, end: 0.55).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
      ),
    );

    // 62–100%: logo bursts toward viewer (1.0 → 1.6) and fades out
    _exitScale = Tween<double>(begin: 1.0, end: 1.6).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.62, 1.0, curve: Curves.easeIn),
      ),
    );

    _exitFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.62, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed && mounted) {
        final result = await _updateCheckFuture;
        if (!mounted) return;
        if (result.required) {
          context.go(AppRoutes.forceUpdate, extra: result.storeUrl);
        } else {
          context.go(AppRoutes.home);
        }
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
                // ── Concrete wall texture ──────────────────────────────────
                CustomPaint(
                  painter: ConcreteWallPainter(),
                  size: size,
                  isComplex: true,
                  willChange: false,
                ),

                // ── Radial vignette ────────────────────────────────────────
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

                // ── Logo (grow in → burst out) ─────────────────────────────
                Center(
                  child: SplashLogoAnimation(
                    entryFade: _entryFade.value,
                    exitFade: _exitFade.value,
                    entryScale: _entryScale.value,
                    exitScale: _exitScale.value,
                    logoSize: logoSize,
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
