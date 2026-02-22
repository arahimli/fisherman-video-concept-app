import 'package:flutter/material.dart';

import '../../../core/design/design_system.dart';
import '../../../l10n/app_localizations.dart';

void showPreviewShareSheet(
  BuildContext context, {
  required VoidCallback onSave,
  required VoidCallback onShare,
}) {
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
            Text(l10n.shareSheet, style: AppTextStyles.appBarTitle),
            const SizedBox(height: AppSpacing.xl),
            _SheetTile(
              icon: Icons.save_alt_outlined,
              title: l10n.saveToGallery,
              subtitle: l10n.saveToGalleryDesc,
              onTap: () {
                Navigator.pop(sheetContext);
                onSave();
              },
            ),
            Divider(color: AppColors.surfaceElevated, height: AppSpacing.xl),
            _SheetTile(
              icon: Icons.ios_share_outlined,
              title: l10n.share,
              subtitle: l10n.shareSubtitle,
              onTap: () {
                Navigator.pop(sheetContext);
                onShare();
              },
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    ),
  );
}

class _SheetTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SheetTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: const BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: AppRadius.smAll,
        ),
        child: Icon(icon, color: AppColors.accent, size: 22),
      ),
      title: Text(title, style: AppTextStyles.historyCardTitle),
      subtitle: Text(subtitle, style: AppTextStyles.historyCardDate),
      onTap: onTap,
    );
  }
}
