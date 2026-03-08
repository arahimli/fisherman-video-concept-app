import 'package:flutter/material.dart';

import '../../../core/design/design_system.dart';
import '../../../l10n/app_localizations.dart';

class HistoryFilterChips extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  const HistoryFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filters = [
      (label: l10n.allDates,  value: 'all'),
      (label: l10n.today,     value: 'today'),
      (label: l10n.yesterday, value: 'yesterday'),
      (label: l10n.thisWeek,  value: 'week'),
      (label: l10n.thisMonth, value: 'month'),
    ];

    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, i) {
          final isSelected = selectedFilter == filters[i].value;
          return ChoiceChip(
            label: Text(filters[i].label),
            selected: isSelected,
            onSelected: (_) => onFilterChanged(filters[i].value),
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
