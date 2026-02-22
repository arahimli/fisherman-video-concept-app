import 'package:flutter/material.dart';

import '../../../core/design/design_system.dart';
import '../../../l10n/app_localizations.dart';

class HistoryEmptyState extends StatelessWidget {
  const HistoryEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.video_library_outlined, size: 72, color: AppColors.textHint),
          const SizedBox(height: AppSpacing.xl),
          Text(l10n.noVideos, style: AppTextStyles.emptyStateTitle),
          const SizedBox(height: AppSpacing.sm),
          Text(l10n.noVideosDesc, style: AppTextStyles.emptyStateBody),
        ],
      ),
    );
  }
}
