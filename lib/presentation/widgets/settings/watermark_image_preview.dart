import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/design/design_system.dart';
import '../../../l10n/app_localizations.dart';

class WatermarkImagePreview extends StatelessWidget {
  final String path;
  final VoidCallback onChange;
  final VoidCallback onRemove;

  const WatermarkImagePreview({
    super.key,
    required this.path,
    required this.onChange,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: AppRadius.smAll,
            child: Image.file(
              File(path),
              width: 64,
              height: 64,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: onChange,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.accent,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(l10n.watermarkChangeImage, style: const TextStyle(fontSize: 13)),
                ),
                const SizedBox(height: 4),
                TextButton(
                  onPressed: onRemove,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.error,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(l10n.watermarkRemove, style: const TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
