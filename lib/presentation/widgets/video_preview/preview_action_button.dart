import 'package:flutter/material.dart';

import '../../../core/design/design_system.dart';

class PreviewActionButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final bool isAccent;
  final VoidCallback? onTap;

  const PreviewActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.isAccent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isAccent ? AppColors.accent : AppColors.surface,
      borderRadius: AppRadius.mdAll,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mdAll,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          decoration: isAccent
              ? null
              : BoxDecoration(
                  borderRadius: AppRadius.mdAll,
                  border: Border.all(color: AppColors.accentBorder, width: 1),
                ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconTheme(
                data: IconThemeData(
                  color: isAccent ? AppColors.background : AppColors.accent,
                  size: 20,
                ),
                child: icon,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                label,
                style: AppTextStyles.actionButton.copyWith(
                  color: isAccent ? AppColors.background : AppColors.accent,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
