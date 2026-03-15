import 'package:flutter/material.dart';

import '../../../core/design/design_system.dart';
import '../../../data/services/settings_service.dart';
import '../../../l10n/app_localizations_extension.dart';

class WatermarkPositionSelector extends StatelessWidget {
  final WatermarkPosition selected;
  final ValueChanged<WatermarkPosition> onChanged;

  const WatermarkPositionSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        Row(
          children: [
            _PosTile(
              label: l10n.positionTopLeft,
              dotAlignment: Alignment.topLeft,
              selected: selected == WatermarkPosition.topLeft,
              onTap: () => onChanged(WatermarkPosition.topLeft),
            ),
            const SizedBox(width: AppSpacing.sm),
            _PosTile(
              label: l10n.positionTopRight,
              dotAlignment: Alignment.topRight,
              selected: selected == WatermarkPosition.topRight,
              onTap: () => onChanged(WatermarkPosition.topRight),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            _PosTile(
              label: l10n.positionBottomLeft,
              dotAlignment: Alignment.bottomLeft,
              selected: selected == WatermarkPosition.bottomLeft,
              onTap: () => onChanged(WatermarkPosition.bottomLeft),
            ),
            const SizedBox(width: AppSpacing.sm),
            _PosTile(
              label: l10n.positionBottomRight,
              dotAlignment: Alignment.bottomRight,
              selected: selected == WatermarkPosition.bottomRight,
              onTap: () => onChanged(WatermarkPosition.bottomRight),
            ),
          ],
        ),
      ],
    );
  }
}

class _PosTile extends StatelessWidget {
  final String label;
  final Alignment dotAlignment;
  final bool selected;
  final VoidCallback onTap;

  const _PosTile({
    required this.label,
    required this.dotAlignment,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 72,
          decoration: BoxDecoration(
            color: selected ? AppColors.accentOverlay : AppColors.surfaceElevated,
            borderRadius: AppRadius.mdAll,
            border: Border.all(
              color: selected ? AppColors.accent : AppColors.accentBorderFaint,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Align(
                    alignment: dotAlignment,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: selected ? AppColors.accent : AppColors.textHint,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: selected ? AppColors.accent : AppColors.textTertiary,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
