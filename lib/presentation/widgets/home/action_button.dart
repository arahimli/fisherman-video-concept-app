import 'package:flutter/material.dart';

import '../../../core/design/design_system.dart';

class HomeActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isAccent;
  final VoidCallback? onTap;

  const HomeActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.isAccent = false,
    required this.onTap,
  });

  bool get _isDisabled => onTap == null;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _isDisabled ? 0.38 : 1.0,
      child: Material(
        color: isAccent ? AppColors.accentStrong : AppColors.surface,
        borderRadius: AppRadius.mdAll,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.mdAll,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isAccent ? AppColors.surface : AppColors.accent,
                  size: 26,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.actionButton.copyWith(
                    color: isAccent ? AppColors.surface : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
