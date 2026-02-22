import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
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
      await file.writeAsBytes(bytes.buffer.asUint8List());
    }

    return file.path;
  }

  // Renders text as a transparent PNG using Flutter's canvas.
  // Avoids FFmpeg drawtext which requires system fonts unavailable on mobile.
  static Future<String?> _renderTextAsImage(String text) async {
    try {
      const fontSize = 38.0;
      const padding = 16.0;

      final textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: const TextStyle(
            color: Color(0xA6FFFFFF), // white at ~65% opacity
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            shadows: [
              Shadow(
                offset: Offset(1.5, 1.5),
                blurRadius: 6,
                color: Color(0x99000000),
              ),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      // H.264/yuv420p requires even dimensions
      final imgW = _toEven(textPainter.width + padding * 2);
      final imgH = _toEven(textPainter.height + padding);

      final recorder = ui.PictureRecorder();
      final canvas = ui.Canvas(recorder);
      textPainter.paint(canvas, const Offset(padding, padding / 2));
      final picture = recorder.endRecording();

      final img = await picture.toImage(imgW, imgH);
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/text_watermark_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(byteData.buffer.asUint8List());
      return file.path;
    } catch (e) {
      log('Error rendering text watermark image: $e');
      return null;
    }
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

      final hasImageWatermark = watermark != null && watermark.hasImageWatermark;
      final hasTextWatermark = watermark != null && watermark.hasTextWatermark;

      // Pre-render text watermark as PNG (avoids FFmpeg font dependency)
      String? textImagePath;
      if (hasTextWatermark) {
        textImagePath = await _renderTextAsImage(watermark!.text);
      }

      // Build extra inputs and their FFmpeg input indices
      // [0–5]: video frames, [6]: audio, [7]: image wm, [7 or 8]: text wm
      String extraInputs = '';
      int imageWmIndex = -1;
      int textWmIndex = -1;
      int nextIndex = 7;

      if (hasImageWatermark) {
        extraInputs += '-i "${watermark!.imagePath}" ';
        imageWmIndex = nextIndex++;
      }
      if (textImagePath != null) {
        extraInputs += '-i "$textImagePath" ';
        textWmIndex = nextIndex++;
      }

      final hasAnyWatermark = imageWmIndex >= 0 || textWmIndex >= 0;
      final pos = watermark?.position ?? WatermarkPosition.bottomRight;
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

      final concatLabel = hasAnyWatermark ? '[cat]' : '[outv]';
      final concat = '[v0][v1][v2][v3][v4][v5]concat=n=6:v=1:a=0$concatLabel';

      // Chain watermark overlays
      String wmFilters = '';
      String lastLabel = hasAnyWatermark ? 'cat' : 'outv';

      if (imageWmIndex >= 0) {
        final nextLabel = textWmIndex >= 0 ? 'wm1' : 'outv';
        wmFilters +=
            ';[$imageWmIndex:v]scale=150:150:force_original_aspect_ratio=decrease,pad=150:150:(ow-iw)/2:(oh-ih)/2[wm_img];[$lastLabel][wm_img]overlay=$ox:$oy[$nextLabel]';
        lastLabel = nextLabel;
      }

      if (textWmIndex >= 0) {
        wmFilters +=
            ';[$textWmIndex:v][$lastLabel]overlay=$ox:$oy[outv]';
      }

      final filterComplex = '"$scaleFilters$concat$wmFilters"';

      final command = '-y '
          '-loop 1 -t 2 -i "${images['original']}" '
          '-loop 1 -t 3 -i "${images['left_half_black']}" '
          '-loop 1 -t 10 -i "${images['left_symmetry']}" '
          '-loop 1 -t 2 -i "${images['original']}" '
          '-loop 1 -t 2 -i "${images['right_half_black']}" '
          '-loop 1 -t 12 -i "${images['right_symmetry']}" '
          '-i "$musicPath" '
          '$extraInputs'
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

  // Round up to nearest even integer (required by H.264/yuv420p)
  static int _toEven(double v) {
    final n = v.ceil();
    return n.isEven ? n : n + 1;
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
