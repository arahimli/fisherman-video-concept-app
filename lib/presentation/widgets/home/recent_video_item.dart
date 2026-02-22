import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/design/design_system.dart';
import '../../../data/database/app_database.dart';

class RecentVideoItem extends StatelessWidget {
  final VideoHistoryData video;
  final double screenWidth;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const RecentVideoItem({
    super.key,
    required this.video,
    required this.screenWidth,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: screenWidth * 0.35,
        decoration: const BoxDecoration(
          borderRadius: AppRadius.lgAll,
          border: Border.fromBorderSide(
            BorderSide(color: AppColors.accentBorderLight, width: 1),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.surfaceElevated, AppColors.surface],
          ),
        ),
        child: Stack(
          children: [
            if (video.imagePath != null)
              ClipRRect(
                borderRadius: AppRadius.lgAll,
                child: Image.file(
                  File(video.imagePath!),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.overlayDark,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.sm),
                  child: Icon(Icons.play_arrow, color: AppColors.textPrimary, size: 26),
                ),
              ),
            ),
            Positioned(
              bottom: AppSpacing.sm,
              left: AppSpacing.sm,
              right: AppSpacing.sm,
              child: ClipRRect(
                borderRadius: AppRadius.smAll,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.overlayMedium,
                      borderRadius: AppRadius.smAll,
                    ),
                    child: Text(
                      video.title,
                      style: AppTextStyles.recentVideoTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
