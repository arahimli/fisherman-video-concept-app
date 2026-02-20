import 'package:flutter/material.dart';

abstract class AppRadius {
  // ── Raw values ────────────────────────────────────────────────────────────
  static const double xs   = 4;
  static const double sm   = 8;
  static const double md   = 12;
  static const double lg   = 16;
  static const double xl   = 20;
  static const double pill = 50;

  // ── BorderRadius helpers ──────────────────────────────────────────────────
  static const BorderRadius xsAll   = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius smAll   = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll   = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll   = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlAll   = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius pillAll = BorderRadius.all(Radius.circular(pill));

  // ── Top-only helpers (for cards, sheets) ─────────────────────────────────
  static const BorderRadius topLg = BorderRadius.vertical(top: Radius.circular(lg));
  static const BorderRadius topXl = BorderRadius.vertical(top: Radius.circular(xl));
}
