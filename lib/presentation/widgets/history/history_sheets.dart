import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/design/design_system.dart';
import '../../../data/database/app_database.dart';
import '../../../l10n/app_localizations_extension.dart';
import '../../managers/history_bloc/bloc.dart';
import '../../managers/recent_videos_bloc/bloc.dart';

void showVideoOptionsSheet(BuildContext context, VideoHistoryData video) {
  final l10n = context.l10n;
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(borderRadius: AppRadius.topXl),
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.surfaceHighest,
                borderRadius: AppRadius.xsAll,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Share
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: AppRadius.smAll,
                ),
                child: const Icon(Icons.ios_share_outlined, color: AppColors.accent, size: 22),
              ),
              title: Text(l10n.share, style: AppTextStyles.historyCardTitle),
              subtitle: Text(l10n.shareSubtitle, style: AppTextStyles.historyCardDate),
              onTap: () async {
                Navigator.pop(sheetContext);
                try {
                  await Share.shareXFiles(
                    [XFile(video.videoPath)],
                    text: l10n.shareVideoText,
                  );
                } catch (_) {}
              },
            ),

            Divider(color: AppColors.surfaceElevated, height: AppSpacing.xl),

            // Save
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: AppRadius.smAll,
                ),
                child: const Icon(Icons.save_alt_outlined, color: AppColors.accent, size: 22),
              ),
              title: Text(l10n.saveToGallery, style: AppTextStyles.historyCardTitle),
              subtitle: Text(l10n.saveToGalleryDesc, style: AppTextStyles.historyCardDate),
              onTap: () async {
                Navigator.pop(sheetContext);
                final result = await SaverGallery.saveFile(
                  filePath: video.videoPath,
                  fileName: 'fisherman_video_${DateTime.now().millisecondsSinceEpoch}',
                  skipIfExists: true,
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        result.isSuccess
                            ? l10n.videoSavedSuccess
                            : l10n.error(result.errorMessage ?? ''),
                      ),
                      backgroundColor: result.isSuccess ? AppColors.accent : AppColors.error,
                    ),
                  );
                }
              },
            ),

            Divider(color: AppColors.surfaceElevated, height: AppSpacing.xl),

            // Delete
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.12),
                  borderRadius: AppRadius.smAll,
                ),
                child: const Icon(Icons.delete_outline, color: AppColors.error, size: 22),
              ),
              title: Text(
                l10n.deleteVideo,
                style: AppTextStyles.historyCardTitle.copyWith(color: AppColors.error),
              ),
              subtitle: Text(l10n.deleteConfirm, style: AppTextStyles.historyCardDate),
              onTap: () {
                Navigator.pop(sheetContext);
                showDeleteConfirmSheet(context, video.id);
              },
            ),

            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    ),
  );
}

void showDeleteConfirmSheet(BuildContext context, int videoId) {
  final l10n = context.l10n;
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(borderRadius: AppRadius.topXl),
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.surfaceHighest,
                borderRadius: AppRadius.xsAll,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(l10n.deleteVideo, style: AppTextStyles.appBarTitle),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.deleteConfirm,
              style: AppTextStyles.dialogContent,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(sheetContext),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.accentBorder),
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
                    ),
                    child: Text(l10n.cancel),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      context.read<HistoryBloc>().add(DeleteVideoEvent(videoId));
                      context.read<RecentVideosBloc>().add(LoadRecentVideosEvent());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: AppColors.textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
                    ),
                    child: Text(l10n.delete),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    ),
  );
}
