import 'package:flutter/material.dart';

abstract class AppColors {
  // ── Backgrounds ──────────────────────────────────────────────────────────
  static const Color background     = Color(0xFF0A0A0A);
  static const Color surface        = Color(0xFF1A1A1A);
  static const Color surfaceElevated = Color(0xFF2A2A2A);
  static const Color surfaceHighest  = Color(0xFF3A3A3A);

  // ── Accent ───────────────────────────────────────────────────────────────
  static const Color accent       = Color(0xFFB8956A);
  static const Color accentStrong = Color(0xFFE6B84D);

  // ── Accent with opacity (pre-computed hex for const usage) ───────────────
  static const Color accentBorder      = Color(0x4DB8956A); // 30 %
  static const Color accentBorderLight = Color(0x33B8956A); // 20 %
  static const Color accentBorderFaint = Color(0x26B8956A); // 15 %
  static const Color accentOverlay     = Color(0x1AB8956A); // 10 %

  // ── Text ─────────────────────────────────────────────────────────────────
  static const Color textPrimary   = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color textTertiary  = Colors.white54;
  static const Color textDisabled  = Colors.white38;
  static const Color textHint      = Colors.white24;
  static const Color textSubtle    = Color(0x80FFFFFF); // white 50 %

  // ── Semantic ─────────────────────────────────────────────────────────────
  static const Color error   = Colors.red;
  static const Color success = Colors.green;
  static const Color info    = Colors.blue;

  // ── Overlays ─────────────────────────────────────────────────────────────
  static const Color overlayDark   = Color(0x80000000); // black 50 %
  static const Color overlayMedium = Color(0x4D000000); // black 30 %
}
