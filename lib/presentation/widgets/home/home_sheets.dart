import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/design/design_system.dart';
import '../../../l10n/app_localizations.dart';
import '../../managers/video_bloc/bloc.dart';

void showImageSourceSheet(BuildContext context) {
  final l10n = AppLocalizations.of(context);
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
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: AppRadius.smAll,
                ),
                child: const Icon(Icons.photo_library_outlined, color: AppColors.accent, size: 22),
              ),
              title: Text(l10n.selectImage.replaceAll('\n', ' '), style: AppTextStyles.historyCardTitle),
              subtitle: Text(l10n.selectFromGallery, style: AppTextStyles.historyCardDate),
              onTap: () {
                Navigator.pop(sheetContext);
                context.read<VideoBloc>().add(PickImageEvent(source: ImageSource.gallery));
              },
            ),
            const Divider(color: AppColors.surfaceElevated),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: AppRadius.smAll,
                ),
                child: const Icon(Icons.camera_alt_outlined, color: AppColors.accent, size: 22),
              ),
              title: Text(l10n.takePhoto, style: AppTextStyles.historyCardTitle),
              subtitle: Text(l10n.takePhotoDesc, style: AppTextStyles.historyCardDate),
              onTap: () {
                Navigator.pop(sheetContext);
                context.read<VideoBloc>().add(PickImageEvent(source: ImageSource.camera));
              },
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    ),
  );
}

void showResetConfirmSheet(BuildContext context) {
  final l10n = AppLocalizations.of(context);
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
            Text(l10n.resetConfirmTitle, style: AppTextStyles.appBarTitle),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.resetConfirmMessage,
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
                    child: Text(l10n.no),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      context.read<VideoBloc>().add(ResetEvent());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.background,
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
                    ),
                    child: Text(l10n.yes),
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
