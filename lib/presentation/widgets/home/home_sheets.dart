import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/design/design_system.dart';
import '../../../data/services/video_service.dart' show VideoLanguage;
import '../../../l10n/app_localizations_extension.dart';
import '../../managers/video_bloc/bloc.dart';

void showVideoLanguageSheet(BuildContext context) {
  final l10n = context.l10n;
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surface,
    isScrollControlled: true,
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
            Text(l10n.selectVideoLanguage, style: AppTextStyles.appBarTitle),
            const SizedBox(height: AppSpacing.xl),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(sheetContext).size.height * 0.6,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: const BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: AppRadius.smAll,
                        ),
                        child: const Text('🇬🇧', style: TextStyle(fontSize: 22)),
                      ),
                      title: Text(l10n.englishVoice, style: AppTextStyles.historyCardTitle),
                      subtitle: Text(l10n.englishVoiceDesc, style: AppTextStyles.historyCardDate),
                      onTap: () {
                        Navigator.pop(sheetContext);
                        context.read<VideoBloc>().add(GenerateVideoEvent(
                              processingMessage: l10n.imageProcessing,
                              generatingMessage: l10n.videoGenerating,
                              language: VideoLanguage.en,
                            ));
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
                        child: const Text('🇹🇷', style: TextStyle(fontSize: 22)),
                      ),
                      title: Text(l10n.turkishVoice, style: AppTextStyles.historyCardTitle),
                      subtitle: Text(l10n.turkishVoiceDesc, style: AppTextStyles.historyCardDate),
                      onTap: () {
                        Navigator.pop(sheetContext);
                        context.read<VideoBloc>().add(GenerateVideoEvent(
                              processingMessage: l10n.imageProcessing,
                              generatingMessage: l10n.videoGenerating,
                              language: VideoLanguage.tr,
                            ));
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
                        child: const Text('🇷🇺', style: TextStyle(fontSize: 22)),
                      ),
                      title: Text(l10n.russianVoice, style: AppTextStyles.historyCardTitle),
                      subtitle: Text(l10n.russianVoiceDesc, style: AppTextStyles.historyCardDate),
                      onTap: () {
                        Navigator.pop(sheetContext);
                        context.read<VideoBloc>().add(GenerateVideoEvent(
                              processingMessage: l10n.imageProcessing,
                              generatingMessage: l10n.videoGenerating,
                              language: VideoLanguage.ru,
                            ));
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
                        child: const Text('🇫🇷', style: TextStyle(fontSize: 22)),
                      ),
                      title: Text(l10n.frenchVoice, style: AppTextStyles.historyCardTitle),
                      subtitle: Text(l10n.frenchVoiceDesc, style: AppTextStyles.historyCardDate),
                      onTap: () {
                        Navigator.pop(sheetContext);
                        context.read<VideoBloc>().add(GenerateVideoEvent(
                              processingMessage: l10n.imageProcessing,
                              generatingMessage: l10n.videoGenerating,
                              language: VideoLanguage.fr,
                            ));
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
                        child: const Text('🇸🇦', style: TextStyle(fontSize: 22)),
                      ),
                      title: Text(l10n.arabicVoice, style: AppTextStyles.historyCardTitle),
                      subtitle: Text(l10n.arabicVoiceDesc, style: AppTextStyles.historyCardDate),
                      onTap: () {
                        Navigator.pop(sheetContext);
                        context.read<VideoBloc>().add(GenerateVideoEvent(
                              processingMessage: l10n.imageProcessing,
                              generatingMessage: l10n.videoGenerating,
                              language: VideoLanguage.ar,
                            ));
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
                        child: const Text('🇨🇳', style: TextStyle(fontSize: 22)),
                      ),
                      title: Text(l10n.chineseVoice, style: AppTextStyles.historyCardTitle),
                      subtitle: Text(l10n.chineseVoiceDesc, style: AppTextStyles.historyCardDate),
                      onTap: () {
                        Navigator.pop(sheetContext);
                        context.read<VideoBloc>().add(GenerateVideoEvent(
                              processingMessage: l10n.imageProcessing,
                              generatingMessage: l10n.videoGenerating,
                              language: VideoLanguage.zh,
                            ));
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
                        child: const Text('🇪🇸', style: TextStyle(fontSize: 22)),
                      ),
                      title: Text(l10n.spanishVoice, style: AppTextStyles.historyCardTitle),
                      subtitle: Text(l10n.spanishVoiceDesc, style: AppTextStyles.historyCardDate),
                      onTap: () {
                        Navigator.pop(sheetContext);
                        context.read<VideoBloc>().add(GenerateVideoEvent(
                              processingMessage: l10n.imageProcessing,
                              generatingMessage: l10n.videoGenerating,
                              language: VideoLanguage.es,
                            ));
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
                        child: const Text('🇮🇳', style: TextStyle(fontSize: 22)),
                      ),
                      title: Text(l10n.hindiVoice, style: AppTextStyles.historyCardTitle),
                      subtitle: Text(l10n.hindiVoiceDesc, style: AppTextStyles.historyCardDate),
                      onTap: () {
                        Navigator.pop(sheetContext);
                        context.read<VideoBloc>().add(GenerateVideoEvent(
                              processingMessage: l10n.imageProcessing,
                              generatingMessage: l10n.videoGenerating,
                              language: VideoLanguage.hi,
                            ));
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    ),
  );
}

void showImageSourceSheet(BuildContext context) {
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
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: const BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: AppRadius.smAll,
                ),
                child: const AppVectorIcon(AppVectors.image, color: AppColors.accent, size: 22),
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
                child: const AppVectorIcon(AppVectors.camera, color: AppColors.accent, size: 22),
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

void showBackToSelectImageSheet(BuildContext context) {
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
            Text(l10n.backToSelectImageTitle, style: AppTextStyles.appBarTitle),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.backToSelectImageMessage,
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

void showResetConfirmSheet(BuildContext context) {
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
