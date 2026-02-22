import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';

import 'settings_service.dart';

class VideoService {
  static Future<String> copyMusicToTemp() async {
    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/music.mp3");

    if (!await file.exists()) {
      final bytes = await rootBundle.load("assets/music.mp3");
      await file.writeAsBytes(
        bytes.buffer.asUint8List(),
      );
    }

    return file.path;
  }

  static Future<String?> generateVideo(
    Map<String, String> images, {
    WatermarkSettings? watermark,
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
      final musicPath = await copyMusicToTemp();

      final hasImageWatermark =
          watermark != null && watermark.hasImageWatermark;
      final hasTextWatermark = watermark != null && watermark.hasTextWatermark;

      // Audio is input [6], image watermark (if any) is input [7]
      final watermarkInput =
          hasImageWatermark ? '-i "${watermark.imagePath}" ' : '';
      final watermarkIndex = 7; // index of watermark image input

      // Build filter_complex
      final scaleFilters =
          '[0:v]scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2,setsar=1,fps=30[v0];'
          '[1:v]scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2,setsar=1,fps=30[v1];'
          '[2:v]scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2,setsar=1,fps=30[v2];'
          '[3:v]scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2,setsar=1,fps=30[v3];'
          '[4:v]scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2,setsar=1,fps=30[v4];'
          '[5:v]scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2,setsar=1,fps=30[v5];';

      final concatOutput =
          hasImageWatermark || hasTextWatermark ? '[cat]' : '[outv]';
      final concat =
          '[v0][v1][v2][v3][v4][v5]concat=n=6:v=1:a=0$concatOutput';

      String watermarkFilters = '';
      String lastLabel = hasImageWatermark || hasTextWatermark ? 'cat' : 'outv';

      final pos = watermark?.position ?? WatermarkPosition.bottomRight;
      final overlayX = _overlayX(pos);
      final overlayY = _overlayY(pos);
      final textX = _textX(pos);
      final textY = _textY(pos);

      if (hasImageWatermark) {
        final nextLabel = hasTextWatermark ? 'overlaid' : 'outv';
        watermarkFilters +=
            ';[$watermarkIndex:v]scale=220:-1[wm];[$lastLabel][wm]overlay=$overlayX:$overlayY[$nextLabel]';
        lastLabel = nextLabel;
      }

      if (hasTextWatermark) {
        final escaped = _escapeDrawtext(watermark!.text);
        watermarkFilters +=
            ';[$lastLabel]drawtext=text=\'$escaped\':fontsize=38:fontcolor=white:alpha=0.65:x=$textX:y=$textY[outv]';
      }

      final filterComplex =
          '"$scaleFilters$concat$watermarkFilters"';

      final command = '-y '
          '-loop 1 -t 2 -i "${images['original']}" '
          '-loop 1 -t 3 -i "${images['left_half_black']}" '
          '-loop 1 -t 10 -i "${images['left_symmetry']}" '
          '-loop 1 -t 2 -i "${images['original']}" '
          '-loop 1 -t 2 -i "${images['right_half_black']}" '
          '-loop 1 -t 12 -i "${images['right_symmetry']}" '
          '-i "$musicPath" '
          '$watermarkInput'
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

  // Escape special characters for FFmpeg drawtext filter
  static String _escapeDrawtext(String text) {
    return text
        .replaceAll('\\', '\\\\')
        .replaceAll("'", "\\'")
        .replaceAll(':', '\\:');
  }

  // FFmpeg overlay coordinates for image watermark
  static String _overlayX(WatermarkPosition pos) =>
      (pos == WatermarkPosition.topLeft || pos == WatermarkPosition.bottomLeft)
          ? '40'
          : 'W-w-40';

  static String _overlayY(WatermarkPosition pos) =>
      (pos == WatermarkPosition.topLeft || pos == WatermarkPosition.topRight)
          ? '40'
          : 'H-h-80';

  // FFmpeg drawtext coordinates for text watermark
  static String _textX(WatermarkPosition pos) =>
      (pos == WatermarkPosition.topLeft || pos == WatermarkPosition.bottomLeft)
          ? '40'
          : 'w-tw-40';

  static String _textY(WatermarkPosition pos) =>
      (pos == WatermarkPosition.topLeft || pos == WatermarkPosition.topRight)
          ? '40'
          : 'h-th-80';
}
