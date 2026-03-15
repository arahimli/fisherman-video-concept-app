import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/design/design_system.dart';
import '../../data/services/settings_service.dart';
import '../../l10n/app_localizations.dart';
import '../managers/locale_bloc/bloc.dart';
import '../widgets/settings/language_bottom_sheet.dart';
import '../widgets/settings/settings_card.dart';
import '../widgets/settings/settings_section_label.dart';
import '../widgets/settings/settings_toggle_row.dart';
import '../widgets/settings/watermark_image_preview.dart';
import '../widgets/settings/watermark_pick_image_button.dart';
import '../widgets/settings/watermark_position_selector.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _LanguageRow extends StatelessWidget {
  final VoidCallback onTap;
  const _LanguageRow({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final currentCode =
        context.watch<LocaleBloc>().state.locale.languageCode;
    final currentName = nativeLanguageName(currentCode);

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.lgAll,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: const BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: AppRadius.smAll,
              ),
              child: const Icon(
                Icons.language_rounded,
                color: AppColors.accent,
                size: 22,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).appLanguage,
                    style: AppTextStyles.historyCardTitle,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    currentName,
                    style: AppTextStyles.historyCardDate,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textTertiary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsPageState extends State<SettingsPage> {
  final _settings = SettingsService();
  final _picker = ImagePicker();

  bool _imageEnabled = false;
  String? _imagePath;
  WatermarkPosition _position = WatermarkPosition.topRight;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = await _settings.getWatermarkSettings();
    setState(() {
      _imageEnabled = s.imageEnabled;
      _imagePath = s.imagePath;
      _position = s.position;
      _loading = false;
    });
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    await _settings.setImageWatermarkPath(picked.path);
    setState(() => _imagePath = picked.path);
  }

  Future<void> _removeImage() async {
    await _settings.setImageWatermarkPath(null);
    setState(() => _imagePath = null);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.settings, style: AppTextStyles.appBarTitle),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : SafeArea(
              top: false,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                children: [
                  SettingsSectionLabel(l10n.appLanguage),
                  const SizedBox(height: AppSpacing.sm),
                  SettingsCard(
                    children: [
                      _LanguageRow(
                        onTap: () => showLanguageBottomSheet(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  SettingsSectionLabel(l10n.watermark),
                  const SizedBox(height: AppSpacing.sm),
                  SettingsCard(
                    children: [
                      SettingsToggleRow(
                        icon: Icons.image_outlined,
                        title: l10n.imageWatermark,
                        subtitle: l10n.imageWatermarkDesc,
                        value: _imageEnabled,
                        onChanged: (v) {
                          setState(() => _imageEnabled = v);
                          _settings.setImageWatermarkEnabled(v);
                        },
                      ),
                      if (_imageEnabled) ...[
                        const Divider(color: AppColors.surfaceElevated, height: 1),
                        const SizedBox(height: AppSpacing.md),
                        _imagePath != null
                            ? WatermarkImagePreview(
                                path: _imagePath!,
                                onChange: _pickImage,
                                onRemove: _removeImage,
                              )
                            : WatermarkPickImageButton(onTap: _pickImage),
                        const SizedBox(height: AppSpacing.md),
                      ],
                    ],
                  ),
                  if (_imageEnabled) ...[
                    const SizedBox(height: AppSpacing.md),
                    SettingsSectionLabel(l10n.watermarkPosition),
                    const SizedBox(height: AppSpacing.sm),
                    SettingsCard(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: WatermarkPositionSelector(
                            selected: _position,
                            onChanged: (p) {
                              setState(() => _position = p);
                              _settings.setPosition(p);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    l10n.watermarkHint,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textHint,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
