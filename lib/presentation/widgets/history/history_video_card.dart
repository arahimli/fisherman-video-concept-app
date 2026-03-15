import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/design/design_system.dart';
import '../../../data/database/app_database.dart';

class HistoryVideoCard extends StatelessWidget {
  final VideoHistoryData video;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onLongPress;

  const HistoryVideoCard({
    super.key,
    required this.video,
    required this.onTap,
    required this.onDelete,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: AppRadius.lgAll,
          border: Border.fromBorderSide(
            BorderSide(color: AppColors.accentBorder, width: 1),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.surfaceElevated, AppColors.surface],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  _buildThumbnail(),
                  Positioned(
                    top: AppSpacing.xs,
                    right: AppSpacing.xs,
                    child: GestureDetector(
                      onTap: onDelete,
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.xs),
                        decoration: const BoxDecoration(
                          color: AppColors.overlayDark,
                          shape: BoxShape.circle,
                        ),
                        child: const AppVectorIcon(
                          AppVectors.delete,
                          color: AppColors.textPrimary,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: AppTextStyles.historyCardTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    DateFormat('MMM dd, yyyy • HH:mm').format(video.createdAt),
                    style: AppTextStyles.historyCardDate,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    if (video.imagePath != null) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        child: Image.file(
          File(video.imagePath!),
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      );
    }
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceHighest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      child: const Center(
        child: AppVectorIcon(AppVectors.playCircle, color: AppColors.accent, size: 48),
      ),
    );
  }
}
