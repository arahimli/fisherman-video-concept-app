import 'package:shared_preferences/shared_preferences.dart';

enum WatermarkPosition { topLeft, topRight, bottomLeft, bottomRight }

class SettingsService {
  static const _keyImageEnabled = 'watermark_image_enabled';
  static const _keyImagePath = 'watermark_image_path';
  static const _keyTextEnabled = 'watermark_text_enabled';
  static const _keyTextContent = 'watermark_text_content';
  static const _keyPosition = 'watermark_position';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  // ── Image watermark ──────────────────────────────────────────────────────

  Future<bool> getImageWatermarkEnabled() async =>
      (await _prefs).getBool(_keyImageEnabled) ?? false;

  Future<void> setImageWatermarkEnabled(bool value) async =>
      (await _prefs).setBool(_keyImageEnabled, value);

  Future<String?> getImageWatermarkPath() async =>
      (await _prefs).getString(_keyImagePath);

  Future<void> setImageWatermarkPath(String? path) async {
    final p = await _prefs;
    if (path == null) {
      p.remove(_keyImagePath);
    } else {
      p.setString(_keyImagePath, path);
    }
  }

  // ── Text watermark ───────────────────────────────────────────────────────

  Future<bool> getTextWatermarkEnabled() async =>
      (await _prefs).getBool(_keyTextEnabled) ?? false;

  Future<void> setTextWatermarkEnabled(bool value) async =>
      (await _prefs).setBool(_keyTextEnabled, value);

  Future<String> getTextWatermarkContent() async =>
      (await _prefs).getString(_keyTextContent) ?? '';

  Future<void> setTextWatermarkContent(String value) async =>
      (await _prefs).setString(_keyTextContent, value);

  // ── Position ─────────────────────────────────────────────────────────────

  Future<WatermarkPosition> getPosition() async {
    final index = (await _prefs).getInt(_keyPosition) ?? WatermarkPosition.bottomRight.index;
    return WatermarkPosition.values[index];
  }

  Future<void> setPosition(WatermarkPosition position) async =>
      (await _prefs).setInt(_keyPosition, position.index);

  // ── Combined snapshot ────────────────────────────────────────────────────

  Future<WatermarkSettings> getWatermarkSettings() async {
    final imageEnabled = await getImageWatermarkEnabled();
    final imagePath = await getImageWatermarkPath();
    final textEnabled = await getTextWatermarkEnabled();
    final text = await getTextWatermarkContent();
    final position = await getPosition();
    return WatermarkSettings(
      imageEnabled: imageEnabled,
      imagePath: imagePath,
      textEnabled: textEnabled,
      text: text,
      position: position,
    );
  }
}

class WatermarkSettings {
  final bool imageEnabled;
  final String? imagePath;
  final bool textEnabled;
  final String text;
  final WatermarkPosition position;

  const WatermarkSettings({
    required this.imageEnabled,
    this.imagePath,
    required this.textEnabled,
    required this.text,
    required this.position,
  });

  bool get hasImageWatermark => imageEnabled && imagePath != null;
  bool get hasTextWatermark => textEnabled && text.isNotEmpty;
  bool get hasAnyWatermark => hasImageWatermark || hasTextWatermark;
}
