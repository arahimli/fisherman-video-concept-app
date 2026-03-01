import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';

import 'settings_service.dart';

enum VideoLanguage { en, tr }

class VideoService {
  static Future<String> copyVoiceToTemp(VideoLanguage language) async {
    final dir = await getTemporaryDirectory();
    final assetPath = language == VideoLanguage.tr
        ? 'assets/voices/tr_voice.mp3'
        : 'assets/voices/en_voice.mp3';
    final fileName = language == VideoLanguage.tr ? 'tr_voice.mp3' : 'en_voice.mp3';
    final file = File("${dir.path}/$fileName");

    if (!await file.exists()) {
      final bytes = await rootBundle.load(assetPath);
      await file.writeAsBytes(bytes.buffer.asUint8List());
    }

    return file.path;
  }

  static Future<String?> generateVideo(
    Map<String, String> images, {
    WatermarkSettings? watermark,
    VideoLanguage language = VideoLanguage.en,
  }) async {
    try {
      // Validate input images
      for (var entry in images.entries) {
        if (!await File(entry.value).exists()) {
          log("Image not found: ${entry.key} at ${entry.value}");
          return null;
        }
      }

      final dir = await getTemporaryDirectory();
      final outputPath =
          "${dir.path}/output_${DateTime.now().millisecondsSinceEpoch}.mp4";
      final musicPath = await copyVoiceToTemp(language);

      final hasImageWatermark = watermark != null && watermark.hasImageWatermark;

      // [0–5]: video frames, [6]: audio, [7]: image watermark (if any)
      final extraInput = hasImageWatermark ? '-i "${watermark!.imagePath}" ' : '';
      final wmIndex = 7;

      final pos = watermark?.position ?? WatermarkPosition.topRight;
      final ox = _overlayX(pos);
      final oy = _overlayY(pos);

      // Build filter_complex
      const scaleFilters =
          '[0:v]scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2,setsar=1,fps=30[v0];'
          '[1:v]scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2,setsar=1,fps=30[v1];'
          '[2:v]scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2,setsar=1,fps=30[v2];'
          '[3:v]scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2,setsar=1,fps=30[v3];'
          '[4:v]scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2,setsar=1,fps=30[v4];'
          '[5:v]scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2,setsar=1,fps=30[v5];';

      final concatLabel = hasImageWatermark ? '[cat]' : '[outv]';
      final concat = '[v0][v1][v2][v3][v4][v5]concat=n=6:v=1:a=0$concatLabel';

      final wmFilter = hasImageWatermark
          ? ';[$wmIndex:v]scale=150:150:force_original_aspect_ratio=decrease,pad=150:150:(ow-iw)/2:(oh-ih)/2[wm];[cat][wm]overlay=$ox:$oy[outv]'
          : '';

      final filterComplex = '"$scaleFilters$concat$wmFilter"';

      final command = '-y '
          '-loop 1 -t 2 -i "${images['original']}" '
          '-loop 1 -t 3 -i "${images['left_half_black']}" '
          '-loop 1 -t 10 -i "${images['left_symmetry']}" '
          '-loop 1 -t 2 -i "${images['original']}" '
          '-loop 1 -t 2 -i "${images['right_half_black']}" '
          '-loop 1 -t 12 -i "${images['right_symmetry']}" '
          '-i "$musicPath" '
          '$extraInput'
          '-filter_complex $filterComplex '
          '-map "[outv]" '
          '-map 6:a '
          '-t 30 '
          '-c:v libx264 '
          '-preset ultrafast '
          '-pix_fmt yuv420p '
          '-c:a aac '
          '-b:a 128k '
          '"$outputPath"';

      log("Executing FFmpeg command...");
      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        log("Video generated successfully at: $outputPath");
        return outputPath;
      } else {
        final logs = await session.getAllLogsAsString();
        log("FFmpeg failed with return code: ${returnCode?.getValue()}");
        log("Full logs:\n$logs");
        return null;
      }
    } catch (e) {
      log("Error generating video: $e");
      return null;
    }
  }

  // FFmpeg overlay coordinates based on watermark position
  static String _overlayX(WatermarkPosition pos) =>
      (pos == WatermarkPosition.topLeft || pos == WatermarkPosition.bottomLeft)
          ? '40'
          : 'W-w-40';

  static String _overlayY(WatermarkPosition pos) =>
      (pos == WatermarkPosition.topLeft || pos == WatermarkPosition.topRight)
          ? '40'
          : 'H-h-80';
}
