import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fisherman_video/data/services/settings_service.dart';

void main() {
  late SettingsService sut;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    sut = SettingsService();
  });

  group('SettingsService', () {
    // ── image watermark enabled ─────────────────────────────────────────────

    group('imageWatermarkEnabled', () {
      test('returns false by default', () async {
        expect(await sut.getImageWatermarkEnabled(), isFalse);
      });

      test('stores true and retrieves it', () async {
        await sut.setImageWatermarkEnabled(true);
        expect(await sut.getImageWatermarkEnabled(), isTrue);
      });

      test('can be toggled back to false', () async {
        await sut.setImageWatermarkEnabled(true);
        await sut.setImageWatermarkEnabled(false);
        expect(await sut.getImageWatermarkEnabled(), isFalse);
      });
    });

    // ── image watermark path ────────────────────────────────────────────────

    group('imageWatermarkPath', () {
      test('returns null by default', () async {
        expect(await sut.getImageWatermarkPath(), isNull);
      });

      test('stores and retrieves a path', () async {
        await sut.setImageWatermarkPath('/assets/logo.png');
        expect(await sut.getImageWatermarkPath(), '/assets/logo.png');
      });

      test('removes the key when set to null', () async {
        await sut.setImageWatermarkPath('/assets/logo.png');
        await sut.setImageWatermarkPath(null);
        expect(await sut.getImageWatermarkPath(), isNull);
      });

      test('overwrites a previous path', () async {
        await sut.setImageWatermarkPath('/old.png');
        await sut.setImageWatermarkPath('/new.png');
        expect(await sut.getImageWatermarkPath(), '/new.png');
      });
    });

    // ── watermark position ──────────────────────────────────────────────────

    group('watermarkPosition', () {
      test('returns topRight by default', () async {
        expect(await sut.getPosition(), WatermarkPosition.topRight);
      });

      for (final position in WatermarkPosition.values) {
        test('stores and retrieves $position', () async {
          await sut.setPosition(position);
          expect(await sut.getPosition(), position);
        });
      }
    });

    // ── WatermarkSettings snapshot ──────────────────────────────────────────

    group('getWatermarkSettings', () {
      test('returns defaults when nothing has been set', () async {
        final s = await sut.getWatermarkSettings();
        expect(s.imageEnabled, isFalse);
        expect(s.imagePath, isNull);
        expect(s.position, WatermarkPosition.topRight);
        expect(s.hasImageWatermark, isFalse);
        expect(s.hasAnyWatermark, isFalse);
      });

      test('hasImageWatermark is true when enabled and path is set', () async {
        await sut.setImageWatermarkEnabled(true);
        await sut.setImageWatermarkPath('/logo.png');
        final s = await sut.getWatermarkSettings();
        expect(s.hasImageWatermark, isTrue);
        expect(s.hasAnyWatermark, isTrue);
      });

      test('hasImageWatermark is false when enabled but no path', () async {
        await sut.setImageWatermarkEnabled(true);
        final s = await sut.getWatermarkSettings();
        expect(s.hasImageWatermark, isFalse);
        expect(s.hasAnyWatermark, isFalse);
      });

      test('hasImageWatermark is false when path set but disabled', () async {
        await sut.setImageWatermarkEnabled(false);
        await sut.setImageWatermarkPath('/logo.png');
        final s = await sut.getWatermarkSettings();
        expect(s.hasImageWatermark, isFalse);
        expect(s.hasAnyWatermark, isFalse);
      });

      test('reflects the last-written position', () async {
        await sut.setPosition(WatermarkPosition.bottomLeft);
        final s = await sut.getWatermarkSettings();
        expect(s.position, WatermarkPosition.bottomLeft);
      });
    });
  });
}
