import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design/design_system.dart';
import '../../../core/router/app_routes.dart';
import '../../../l10n/app_localizations_extension.dart';
import '../../managers/video_bloc/bloc.dart';
import 'home_sheets.dart';

class VideoReadyModeWidget extends StatelessWidget {
  final File imageFile;
  final String videoPath;

  const VideoReadyModeWidget({
    super.key,
    required this.imageFile,
    required this.videoPath,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        // ── Image with play overlay ──────────────────────────────────────
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.lg,
            ),
            child: GestureDetector(
              onTap: () => context.push(AppRoutes.videoPreview, extra: videoPath),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: AppRadius.lgAll,
                  border: Border.all(color: AppColors.accentBorder, width: 2),
                  boxShadow: AppShadows.accentSubtle,
                ),
                child: ClipRRect(
                  borderRadius: AppRadius.lgAll,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(imageFile, fit: BoxFit.cover),
                      const ColoredBox(color: Color(0x55000000)),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.xl),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.92),
                            shape: BoxShape.circle,
                            boxShadow: AppShadows.accentGlow,
                          ),
                          child: const AppVectorIcon(
                            AppVectors.play,
                            color: AppColors.background,
                            size: 72,
                          ),
                        ),
                      ),
                      Positioned(
                        top: AppSpacing.md,
                        right: AppSpacing.md,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: AppRadius.pillAll,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const AppVectorIcon(AppVectors.checkCircle, color: AppColors.background, size: 13),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                l10n.videoReady,
                                style: const TextStyle(
                                  color: AppColors.background,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // ── Preview button ───────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.push(AppRoutes.videoPreview, extra: videoPath),
              icon: const AppVectorIcon(AppVectors.playCircle, color: AppColors.background, size: 22),
              label: Text(l10n.previewVideo,
                  style: AppTextStyles.previewButtonLabel.copyWith(fontSize: 13)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.background,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
                elevation: 0,
              ),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // ── Change image + Home ──────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => showImageSourceSheet(context),
                  icon: const AppVectorIcon(AppVectors.image, color: AppColors.textPrimary, size: 20),
                  label: Text(l10n.changeImage.replaceAll('\n', ' ')),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.accentBorder),
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.read<VideoBloc>().add(ResetEvent()),
                  icon: const AppVectorIcon(AppVectors.home, color: AppColors.textPrimary, size: 20),
                  label: Text(context.l10n.home),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.accentBorder),
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
