import 'dart:io';
import 'dart:isolate';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ImageService {
  static Future<Map<String, String>> processImage(File file) async {
    final params = _ImageProcessParams(
      filePath: file.path,
      tempDirPath: (await getTemporaryDirectory()).path,
    );

    final result = await Isolate.run(() => _processImageInIsolate(params));
    return result;
  }

  static Future<Map<String, String>> _processImageInIsolate(
      _ImageProcessParams params) async {
    final bytes = await File(params.filePath).readAsBytes();
    final originalImage = img.decodeImage(bytes);

    if (originalImage == null) {
      throw Exception("Image decode failed");
    }

    // Şəkli resize et
    final original = img.copyResize(
      originalImage,
      width: 1080,
    );

    final width = original.width;
    final height = original.height;
    final halfWidth = width ~/ 2;

    // SOL YARINI GÖTÜR (orijinaldan)
    final leftHalf = img.copyCrop(
      original,
      x: 0,
      y: 0,
      width: halfWidth,
      height: height,
    );

    // SOL SİMMETRİYA: Sol yarını flip edib sağ tərəfə yapışdır
    final leftSymmetry = img.Image(width: width, height: height);

    img.compositeImage(
      leftSymmetry,
      leftHalf,
      dstX: 0,
      dstY: 0,
    );

    final leftFlipped = img.flipHorizontal(leftHalf);
    img.compositeImage(
      leftSymmetry,
      leftFlipped,
      dstX: halfWidth,
      dstY: 0,
    );

    // SAĞ YARINI GÖTÜR (orijinaldan)
    final rightHalf = img.copyCrop(
      original,
      x: halfWidth,
      y: 0,
      width: halfWidth,
      height: height,
    );

    // SAĞ SİMMETRİYA: Sağ yarını flip edib sol tərəfə yapışdır
    final rightSymmetry = img.Image(width: width, height: height);

    img.compositeImage(
      rightSymmetry,
      rightHalf,
      dstX: halfWidth,
      dstY: 0,
    );

    final rightFlipped = img.flipHorizontal(rightHalf);
    img.compositeImage(
      rightSymmetry,
      rightFlipped,
      dstX: 0,
      dstY: 0,
    );

    // YARI QARA ŞƏKİLLƏR (ORİJİNAL ŞƏKLİN YARISI)

    // Sol yarı (ORİJİNALDAN) + sağ qara
    final leftHalfBlack = img.Image(width: width, height: height);
    img.fill(leftHalfBlack, color: img.ColorRgb8(0, 0, 0));

    // ORİJİNAL şəklin SOL YARISINI sol tərəfə qoy
    final originalLeftHalf = img.copyCrop(
      original,
      x: 0,
      y: 0,
      width: halfWidth,
      height: height,
    );
    img.compositeImage(
      leftHalfBlack,
      originalLeftHalf,
      dstX: 0,
      dstY: 0,
    );

    // Sağ yarı (ORİJİNALDAN) + sol qara
    final rightHalfBlack = img.Image(width: width, height: height);
    img.fill(rightHalfBlack, color: img.ColorRgb8(0, 0, 0));

    // ORİJİNAL şəklin SAĞ YARISINI sağ tərəfə qoy
    final originalRightHalf = img.copyCrop(
      original,
      x: halfWidth,
      y: 0,
      width: halfWidth,
      height: height,
    );
    img.compositeImage(
      rightHalfBlack,
      originalRightHalf,
      dstX: halfWidth,
      dstY: 0,
    );

    final originalPath = "${params.tempDirPath}/original.png";
    final leftSymPath = "${params.tempDirPath}/left_symmetry.png";
    final rightSymPath = "${params.tempDirPath}/right_symmetry.png";
    final leftHalfBlackPath = "${params.tempDirPath}/left_half_black.png";
    final rightHalfBlackPath = "${params.tempDirPath}/right_half_black.png";

    await File(originalPath).writeAsBytes(img.encodePng(original));
    await File(leftSymPath).writeAsBytes(img.encodePng(leftSymmetry));
    await File(rightSymPath).writeAsBytes(img.encodePng(rightSymmetry));
    await File(leftHalfBlackPath).writeAsBytes(img.encodePng(leftHalfBlack));
    await File(rightHalfBlackPath).writeAsBytes(img.encodePng(rightHalfBlack));

    return {
      "original": originalPath,
      "left_symmetry": leftSymPath,
      "right_symmetry": rightSymPath,
      "left_half_black": leftHalfBlackPath,
      "right_half_black": rightHalfBlackPath,
    };
  }
}

class _ImageProcessParams {
  final String filePath;
  final String tempDirPath;

  _ImageProcessParams({
    required this.filePath,
    required this.tempDirPath,
  });
}