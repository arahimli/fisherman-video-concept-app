import 'package:flutter/material.dart';

import '../../../core/design/design_system.dart';
import '../../../l10n/app_localizations.dart';
import 'preview_action_button.dart';

class VideoPreviewActionBar extends StatelessWidget {
  final bool isSaving;
  final VoidCallback onSave;
  final VoidCallback onShare;

  const VideoPreviewActionBar({
    super.key,
    required this.isSaving,
    required this.onSave,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.md,
        AppSpacing.xl,
        AppSpacing.xl,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.accentBorderFaint, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: PreviewActionButton(
              icon: isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.background,
                      ),
                    )
                  : const Icon(Icons.save_alt_outlined, size: 20),
              label: isSaving ? l10n.saving : l10n.save,
              isAccent: true,
              onTap: isSaving ? null : onSave,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: PreviewActionButton(
              icon: const Icon(Icons.ios_share_outlined, size: 20),
              label: l10n.share,
              isAccent: false,
              onTap: onShare,
            ),
          ),
        ],
      ),
    );
  }
}
