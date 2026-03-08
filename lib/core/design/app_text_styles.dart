import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract class AppTextStyles {
  // ── Navigation / App bar ──────────────────────────────────────────────────
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 18,
    fontStyle: FontStyle.italic,
    letterSpacing: 2,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w300,
  );

  // ── Dialogs ───────────────────────────────────────────────────────────────
  static const TextStyle dialogTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle dialogContent = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  // ── Home page ─────────────────────────────────────────────────────────────
  static const TextStyle loadingMessage = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
    letterSpacing: 1.5,
  );

  static const TextStyle createLabel = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 11,
    letterSpacing: 3,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle videoReadyTitle = TextStyle(
    fontSize: 13,
    letterSpacing: 2.5,
    fontWeight: FontWeight.w300,
    color: AppColors.textPrimary,
  );

  static const TextStyle previewButtonLabel = TextStyle(
    fontSize: 11,
    letterSpacing: 2,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle actionButton = TextStyle(
    fontSize: 11,
    fontStyle: FontStyle.italic,
    letterSpacing: 1.5,
    fontWeight: FontWeight.w300,
    height: 1.6,
  );

  // ── Section labels ────────────────────────────────────────────────────────
  static const TextStyle sectionLabel = TextStyle(
    fontSize: 11,
    letterSpacing: 2,
    fontWeight: FontWeight.w300,
    color: AppColors.textSubtle,
  );

  static const TextStyle sectionAction = TextStyle(
    fontSize: 11,
    letterSpacing: 1.5,
    color: AppColors.accent,
  );

  // ── Cards / lists ─────────────────────────────────────────────────────────
  static const TextStyle recentVideoTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 9,
    letterSpacing: 0.8,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle historyCardTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  static const TextStyle historyCardDate = TextStyle(
    color: AppColors.textTertiary,
    fontSize: 10,
  );

  // ── Filter chips ──────────────────────────────────────────────────────────
  static const TextStyle filterChip = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  // ── Empty / error states ──────────────────────────────────────────────────
  static const TextStyle emptyStateTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle emptyStateBody = TextStyle(
    color: AppColors.textTertiary,
    fontSize: 13,
  );

  static const TextStyle noContentText = TextStyle(
    color: AppColors.textDisabled,
    fontSize: 12,
  );
}
