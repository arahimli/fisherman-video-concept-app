import 'package:flutter/material.dart';

import '../../../core/design/design_system.dart';
import '../../../l10n/app_localizations_extension.dart';

class HistoryLanguageFilterChips extends StatelessWidget {
  final String? selectedLanguage;
  final ValueChanged<String?> onLanguageChanged;

  const HistoryLanguageFilterChips({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final filters = [
      (label: l10n.allLanguages, value: null),
      (label: l10n.englishVoice, value: 'en'),
      (label: l10n.turkishVoice, value: 'tr'),
      (label: l10n.russianVoice, value: 'ru'),
      (label: l10n.frenchVoice, value: 'fr'),
      (label: l10n.arabicVoice, value: 'ar'),
      (label: l10n.chineseVoice, value: 'zh'),
      (label: l10n.spanishVoice, value: 'es'),
      (label: l10n.hindiVoice, value: 'hi'),
    ];

    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, i) {
          final isSelected = selectedLanguage == filters[i].value;
          return ChoiceChip(
            label: Text(filters[i].label),
            selected: isSelected,
            onSelected: (_) => onLanguageChanged(filters[i].value),
            labelStyle: AppTextStyles.filterChip.copyWith(
              color: isSelected ? AppColors.background : AppColors.textPrimary,
            ),
            selectedColor: AppColors.accent,
            backgroundColor: AppColors.surface,
            side: BorderSide(
              color: isSelected ? AppColors.accent : AppColors.accentBorder,
              width: 1,
            ),
            shape: const StadiumBorder(),
            showCheckmark: false,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 2),
          );
        },
      ),
    );
  }
}
