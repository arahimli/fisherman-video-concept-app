import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/design/design_system.dart';
import '../../../l10n/app_localizations_extension.dart';
import 'action_button.dart';
import 'home_sheets.dart';
import 'recent_videos_widget.dart';

class ImagePreviewModeWidget extends StatelessWidget {
  final File imageFile;

  const ImagePreviewModeWidget({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final l10n = context.l10n;

    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: AppRadius.lgAll,
                border: Border.all(color: AppColors.accentBorder, width: 2),
                boxShadow: AppShadows.accentSubtle,
              ),
              child: ClipRRect(
                borderRadius: AppRadius.lgAll,
                child: Image.file(imageFile, width: double.infinity, fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Row(
            children: [
              Expanded(
                child: HomeActionButton(
                  icon: AppVectorIcon(AppVectors.image, color: AppColors.accent, size: 26),
                  label: l10n.changeImage,
                  onTap: () => showImageSourceSheet(context),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: HomeActionButton(
                  icon: AppVectorIcon(AppVectors.video, color: AppColors.surface, size: 26),
                  label: l10n.generateVideo,
                  isAccent: true,
                  onTap: () => showVideoLanguageSheet(context),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const Expanded(flex: 3, child: RecentVideosWidget()),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
