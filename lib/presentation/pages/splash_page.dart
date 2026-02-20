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

  // Phase 1 — zoom in: small → natural size
  late Animation<double> _entryScale;
  late Animation<double> _entryFade;

  // Phase 3 — burst out: natural size → oversized, fades out
  late Animation<double> _exitScale;
  late Animation<double> _exitFade;

  // Total: ~2600ms
  static const _totalMs = 2600;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _totalMs),
    );

    // 0% – 40%: logo zooms in from 0.68 → 1.0 and fades in
    _entryScale = Tween<double>(begin: 0.68, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.40, curve: Curves.easeOutCubic),
      ),
    );

    _entryFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.32, curve: Curves.easeOut),
    );

    // 68% – 100%: logo bursts toward viewer (1.0 → 1.55) and fades out
    _exitScale = Tween<double>(begin: 1.0, end: 1.55).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.68, 1.0, curve: Curves.easeIn),
      ),
    );

    _exitFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.68, 1.0, curve: Curves.easeIn),
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
    final logoSize = MediaQuery.sizeOf(context).width * 0.72;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          // Combine entry + exit transforms
          final scale = _entryScale.value * _exitScale.value;
          final opacity = _entryFade.value * _exitFade.value;

          return Center(
            child: Opacity(
              opacity: opacity.clamp(0.0, 1.0),
              child: Transform.scale(
                scale: scale,
                child: Image.asset(
                  'assets/images/logo_main.png',
                  width: logoSize,
                  height: logoSize,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
