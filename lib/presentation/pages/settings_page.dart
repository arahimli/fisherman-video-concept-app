import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/design/design_system.dart';
import '../../data/services/settings_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _settings = SettingsService();
  final _picker = ImagePicker();
  final _textController = TextEditingController();

  bool _imageEnabled = false;
  String? _imagePath;
  bool _textEnabled = false;
  WatermarkPosition _position = WatermarkPosition.bottomRight;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final s = await _settings.getWatermarkSettings();
    _textController.text = s.text;
    setState(() {
      _imageEnabled = s.imageEnabled;
      _imagePath = s.imagePath;
      _textEnabled = s.textEnabled;
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text('Settings', style: AppTextStyles.appBarTitle),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : SafeArea(
              top: false,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                children: [
                  _SectionLabel('Watermark'),
                  const SizedBox(height: AppSpacing.sm),

                  // ── Image watermark ───────────────────────────────────
                  _SettingsCard(
                    children: [
                      _ToggleRow(
                        icon: Icons.image_outlined,
                        title: 'Image Watermark',
                        subtitle: 'Overlay a logo or image on the video',
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
                            ? _ImagePreview(
                                path: _imagePath!,
                                onChange: _pickImage,
                                onRemove: _removeImage,
                              )
                            : _PickImageButton(onTap: _pickImage),
                        const SizedBox(height: AppSpacing.md),
                      ],
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // ── Text watermark ────────────────────────────────────
                  _SettingsCard(
                    children: [
                      _ToggleRow(
                        icon: Icons.text_fields_outlined,
                        title: 'Text Watermark',
                        subtitle: 'Add custom text on the video',
                        value: _textEnabled,
                        onChanged: (v) {
                          setState(() => _textEnabled = v);
                          _settings.setTextWatermarkEnabled(v);
                        },
                      ),
                      if (_textEnabled) ...[
                        const Divider(color: AppColors.surfaceElevated, height: 1),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.md,
                            AppSpacing.md,
                            AppSpacing.md,
                            AppSpacing.md,
                          ),
                          child: TextField(
                            controller: _textController,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                            ),
                            maxLength: 60,
                            decoration: InputDecoration(
                              hintText: 'e.g. © Your Name 2025',
                              hintStyle: const TextStyle(
                                color: AppColors.textHint,
                                fontSize: 14,
                              ),
                              counterStyle: const TextStyle(
                                color: AppColors.textHint,
                                fontSize: 11,
                              ),
                              filled: true,
                              fillColor: AppColors.surfaceElevated,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                                vertical: AppSpacing.md,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: AppRadius.mdAll,
                                borderSide: const BorderSide(
                                  color: AppColors.accentBorder,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: AppRadius.mdAll,
                                borderSide: const BorderSide(
                                  color: AppColors.accent,
                                ),
                              ),
                            ),
                            onChanged: (v) => _settings.setTextWatermarkContent(v),
                          ),
                        ),
                      ],
                    ],
                  ),

                  // ── Position ──────────────────────────────────────────
                  if (_imageEnabled || _textEnabled) ...[
                    const SizedBox(height: AppSpacing.md),
                    _SectionLabel('Watermark Position'),
                    const SizedBox(height: AppSpacing.sm),
                    _SettingsCard(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: _PositionSelector(
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
                  const Text(
                    'Uncheck both watermarks to create videos without any overlay.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
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

// ── Section label ──────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.xs, bottom: AppSpacing.sm),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: AppColors.textHint,
          fontSize: 11,
          letterSpacing: 1.4,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── Settings card ──────────────────────────────────────────────────────────────

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgAll,
        border: const Border.fromBorderSide(
          BorderSide(color: AppColors.accentBorderFaint),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

// ── Toggle row ─────────────────────────────────────────────────────────────────

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            child: Icon(icon, color: AppColors.accent, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.historyCardTitle),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.historyCardDate),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.accent,
            inactiveTrackColor: AppColors.surfaceHighest,
            inactiveThumbColor: AppColors.textHint,
          ),
        ],
      ),
    );
  }
}

// ── Image preview ──────────────────────────────────────────────────────────────

class _ImagePreview extends StatelessWidget {
  final String path;
  final VoidCallback onChange;
  final VoidCallback onRemove;

  const _ImagePreview({
    required this.path,
    required this.onChange,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
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
                  child: const Text('Change Image',
                      style: TextStyle(fontSize: 13)),
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
                  child: const Text('Remove', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Position selector ─────────────────────────────────────────────────────────

class _PositionSelector extends StatelessWidget {
  final WatermarkPosition selected;
  final ValueChanged<WatermarkPosition> onChanged;

  const _PositionSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _PosTile(
              label: 'Top Left',
              dotAlignment: Alignment.topLeft,
              selected: selected == WatermarkPosition.topLeft,
              onTap: () => onChanged(WatermarkPosition.topLeft),
            ),
            const SizedBox(width: AppSpacing.sm),
            _PosTile(
              label: 'Top Right',
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
              label: 'Bottom Left',
              dotAlignment: Alignment.bottomLeft,
              selected: selected == WatermarkPosition.bottomLeft,
              onTap: () => onChanged(WatermarkPosition.bottomLeft),
            ),
            const SizedBox(width: AppSpacing.sm),
            _PosTile(
              label: 'Bottom Right',
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
            color: selected
                ? AppColors.accentOverlay
                : AppColors.surfaceElevated,
            borderRadius: AppRadius.mdAll,
            border: Border.all(
              color: selected ? AppColors.accent : AppColors.accentBorderFaint,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Stack(
            children: [
              // Corner dot indicator
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Align(
                    alignment: dotAlignment,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.accent
                            : AppColors.textHint,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
              // Label
              Center(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: selected
                        ? AppColors.accent
                        : AppColors.textTertiary,
                    fontWeight: selected
                        ? FontWeight.w600
                        : FontWeight.w400,
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

// ── Pick image button ──────────────────────────────────────────────────────────

class _PickImageButton extends StatelessWidget {
  final VoidCallback onTap;
  const _PickImageButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            borderRadius: AppRadius.mdAll,
            border: Border.all(
              color: AppColors.accentBorder,
              style: BorderStyle.solid,
            ),
            color: AppColors.surfaceElevated,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_photo_alternate_outlined,
                  color: AppColors.accent, size: 22),
              SizedBox(width: AppSpacing.sm),
              Text(
                'Select Image',
                style: TextStyle(color: AppColors.accent, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
