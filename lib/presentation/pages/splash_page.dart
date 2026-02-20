import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/design/design_system.dart';
import '../../core/router/app_routes.dart';
import '../../l10n/app_localizations.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Image: fades in over first 1.4s
  late Animation<double> _imageFade;

  // Slow Ken Burns zoom over the full duration
  late Animation<double> _imageScale;

  // Title fades in starting at 1.2s
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;

  // Subtitle fades in at 1.8s
  late Animation<double> _subtitleFade;

  // Entire screen fades out at the end
  late Animation<double> _exitFade;

  static const _totalMs = 4200;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _totalMs),
    );

    _imageFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.35, curve: Curves.easeIn),
    );

    _imageScale = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.85, curve: Curves.easeInOut),
      ),
    );

    _titleFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.28, 0.55, curve: Curves.easeOut),
    );

    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.28, 0.55, curve: Curves.easeOut),
    ));

    _subtitleFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.40, 0.62, curve: Curves.easeOut),
    );

    _exitFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.85, 1.0, curve: Curves.easeIn),
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
    final l10n = AppLocalizations.of(context);

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
                // ── Painting ──────────────────────────────────────────────
                FadeTransition(
                  opacity: _imageFade,
                  child: Transform.scale(
                    scale: _imageScale.value,
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/old_fisherman.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // ── Top vignette ──────────────────────────────────────────
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                      colors: [AppColors.background, Colors.transparent],
                    ),
                  ),
                ),

                // ── Bottom gradient overlay ────────────────────────────────
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: [AppColors.background, Colors.transparent],
                      ),
                    ),
                    child: SizedBox(height: 260),
                  ),
                ),

                // ── Text block ────────────────────────────────────────────
                Positioned(
                  left: AppSpacing.xl,
                  right: AppSpacing.xl,
                  bottom: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // App title
                      SlideTransition(
                        position: _titleSlide,
                        child: FadeTransition(
                          opacity: _titleFade,
                          child: Text(
                            l10n.appTitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 36,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 6,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // Painting credit
                      FadeTransition(
                        opacity: _subtitleFade,
                        child: ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: const BoxDecoration(
                                color: AppColors.overlayMedium,
                                borderRadius: AppRadius.pillAll,
                                border: Border.fromBorderSide(
                                  BorderSide(
                                    color: AppColors.accentBorderFaint,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Tivadar Csontváry Kosztka — Old Fisherman, 1902',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                  letterSpacing: 1.2,
                                  fontWeight: FontWeight.w300,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
