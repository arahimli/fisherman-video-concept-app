import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design/design_system.dart';
import '../../../l10n/app_localizations.dart';
import '../../managers/locale_bloc/bloc.dart';

class _LangItem {
  final String code;
  final String flag;
  final String native;
  final String english;

  const _LangItem({
    required this.code,
    required this.flag,
    required this.native,
    required this.english,
  });
}

const _languages = [
  _LangItem(code: 'ar', flag: '🇸🇦', native: 'العربية', english: 'Arabic'),
  _LangItem(code: 'az', flag: '🇦🇿', native: 'Azərbaycanca', english: 'Azerbaijani'),
  _LangItem(code: 'en', flag: '🇬🇧', native: 'English', english: 'English'),
  _LangItem(code: 'es', flag: '🇪🇸', native: 'Español', english: 'Spanish'),
  _LangItem(code: 'fr', flag: '🇫🇷', native: 'Français', english: 'French'),
  _LangItem(code: 'hi', flag: '🇮🇳', native: 'हिंदी', english: 'Hindi'),
  _LangItem(code: 'ru', flag: '🇷🇺', native: 'Русский', english: 'Russian'),
  _LangItem(code: 'tr', flag: '🇹🇷', native: 'Türkçe', english: 'Turkish'),
  _LangItem(code: 'zh', flag: '🇨🇳', native: '中文', english: 'Chinese'),
];

String nativeLanguageName(String code) {
  return _languages
      .firstWhere((l) => l.code == code, orElse: () => _languages[2])
      .native;
}

void showLanguageBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => BlocProvider.value(
      value: context.read<LocaleBloc>(),
      child: const _LanguageSheet(),
    ),
  );
}

class _LanguageSheet extends StatelessWidget {
  const _LanguageSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentCode =
        context.watch<LocaleBloc>().state.locale.languageCode;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppSpacing.md),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.surfaceHighest,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Row(
              children: [
                const Icon(
                  Icons.language_rounded,
                  color: AppColors.accent,
                  size: 22,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  l10n.appLanguage,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.surfaceElevated, height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _languages.length,
            separatorBuilder: (_, __) =>
                const Divider(color: AppColors.surfaceElevated, height: 1),
            itemBuilder: (context, i) {
              final lang = _languages[i];
              final isSelected = lang.code == currentCode;
              return _LanguageTile(
                lang: lang,
                isSelected: isSelected,
                onTap: () {
                  context
                      .read<LocaleBloc>()
                      .add(ChangeLocaleEvent(Locale(lang.code)));
                  Navigator.of(context).pop();
                },
              );
            },
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + AppSpacing.md),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final _LangItem lang;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.lang,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Text(lang.flag, style: const TextStyle(fontSize: 26)),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang.native,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.accent
                          : AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                  Text(
                    lang.english,
                    style: const TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_rounded,
                color: AppColors.accent,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
