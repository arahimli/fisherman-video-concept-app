import 'package:flutter/material.dart';

class SplashLogoAnimation extends StatelessWidget {
  final double entryFade;
  final double exitFade;
  final double entryScale;
  final double exitScale;
  final double logoSize;

  const SplashLogoAnimation({
    super.key,
    required this.entryFade,
    required this.exitFade,
    required this.entryScale,
    required this.exitScale,
    required this.logoSize,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: (entryFade * exitFade).clamp(0.0, 1.0),
      child: Transform.scale(
        scale: entryScale * exitScale,
        child: Image.asset(
          'assets/images/logo_main.png',
          width: logoSize,
          height: logoSize,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
