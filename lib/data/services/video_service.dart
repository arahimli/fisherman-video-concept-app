import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';

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

  static Future<String?> generateVideo(Map<String, String> images) async {
    try {
      // Validate input images
      for (var entry in images.entries) {
        if (!await File(entry.value).exists()) {
          log("Image not found: ${entry.key} at ${entry.value}");
          return null;
        }
      }

      final dir = await getTemporaryDirectory();
      final outputPath = "${dir.path}/output_${DateTime.now().millisecondsSinceEpoch}.mp4";
      final musicPath = await copyMusicToTemp();

      // Video strukturu - 30 saniyə:
      // 0-2s: Original şəkil
      // 2-5s: Sol yarı qara (3s)
      // 5-15s: Sol simmetriya (10s)
      // 15-17s: Original şəkil (2s)
      // 17-19s: Sağ yarı qara (2s)
      // 19-30s: Sağ simmetriya (11s)

      final command = '-y '
          '-loop 1 -t 2 -i "${images['original']}" '           // [0] Original (0-2s)
          '-loop 1 -t 3 -i "${images['left_half_black']}" '    // [1] Sol yarı qara (2-5s)
          '-loop 1 -t 10 -i "${images['left_symmetry']}" '      // [2] Sol simmetriya (5-15s)
          '-loop 1 -t 2 -i "${images['original']}" '           // [3] Original (15-17s)
          '-loop 1 -t 2 -i "${images['right_half_black']}" '   // [4] Sağ yarı qara (17-19s)
          '-loop 1 -t 12 -i "${images['right_symmetry']}" '    // [5] Sağ simmetriya (19-30s)
          '-i "$musicPath" '                                    // [6] Audio
          '-filter_complex "'
          '[0:v]scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2,setsar=1,fps=30[v0];'
          '[1:v]scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2,setsar=1,fps=30[v1];'
          '[2:v]scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2,setsar=1,fps=30[v2];'
          '[3:v]scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2,setsar=1,fps=30[v3];'
          '[4:v]scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2,setsar=1,fps=30[v4];'
          '[5:v]scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2,setsar=1,fps=30[v5];'
          '[v0][v1][v2][v3][v4][v5]concat=n=6:v=1:a=0[outv]" '
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
}