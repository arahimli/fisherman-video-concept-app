import 'package:flutter/material.dart';

import '../../../core/design/design_system.dart';
import '../../../l10n/app_localizations_extension.dart';

class WatermarkPickImageButton extends StatelessWidget {
  final VoidCallback onTap;

  const WatermarkPickImageButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            borderRadius: AppRadius.mdAll,
            border: Border.all(color: AppColors.accentBorder),
            color: AppColors.surfaceElevated,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_photo_alternate_outlined, color: AppColors.accent, size: 22),
              const SizedBox(width: AppSpacing.sm),
              Text(l10n.watermarkSelectImage, style: const TextStyle(color: AppColors.accent, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}
