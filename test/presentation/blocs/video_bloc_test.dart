import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fisherman_video/data/database/app_database.dart';
import 'package:fisherman_video/data/services/settings_service.dart';
import 'package:fisherman_video/presentation/managers/video_bloc/bloc.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

AppDatabase _openDb() => AppDatabase.forTesting(NativeDatabase.memory());

final _fakeImageFile = File('/fake/image.jpg');

const _fakeImages = {
  'original': '/tmp/original.png',
  'left_symmetry': '/tmp/left_sym.png',
  'right_symmetry': '/tmp/right_sym.png',
  'left_half_black': '/tmp/left_hb.png',
  'right_half_black': '/tmp/right_hb.png',
};

const _fakeVideoPath = '/tmp/output_12345.mp4';

final _noWatermark = WatermarkSettings(
  imageEnabled: false,
  position: WatermarkPosition.topRight,
);

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late AppDatabase db;

  setUp(() => db = _openDb());
  tearDown(() async => db.close());

  VideoBloc _buildBloc({
    ProcessImageFn? processImageFn,
    GenerateVideoFn? generateVideoFn,
    GetWatermarkFn? getWatermarkSettingsFn,
  }) =>
      VideoBloc(
        database: db,
        processImageFn: processImageFn,
        generateVideoFn: generateVideoFn,
        getWatermarkSettingsFn: getWatermarkSettingsFn,
      );

  // ── initial state ─────────────────────────────────────────────────────────

  test('initial state is VideoInitial', () {
    expect(_buildBloc().state, isA<VideoInitial>());
  });

  // ── ResetEvent ────────────────────────────────────────────────────────────

  group('ResetEvent', () {
    blocTest<VideoBloc, VideoState>(
      'always emits VideoInitial regardless of current state',
      build: _buildBloc,
      act: (bloc) => bloc.add(ResetEvent()),
      expect: () => [isA<VideoInitial>()],
    );

    blocTest<VideoBloc, VideoState>(
      'resets from ImagePickedState back to VideoInitial',
      build: _buildBloc,
      seed: () => ImagePickedState(_fakeImageFile),
      act: (bloc) => bloc.add(ResetEvent()),
      expect: () => [isA<VideoInitial>()],
    );

    blocTest<VideoBloc, VideoState>(
      'resets from VideoGeneratedState back to VideoInitial',
      build: _buildBloc,
      seed: () => VideoGeneratedState(_fakeImageFile, _fakeVideoPath),
      act: (bloc) => bloc.add(ResetEvent()),
      expect: () => [isA<VideoInitial>()],
    );
  });

  // ── GenerateVideoEvent — validation guards ────────────────────────────────

  group('GenerateVideoEvent — validation errors', () {
    blocTest<VideoBloc, VideoState>(
      'emits VideoErrorState when current state is VideoInitial',
      build: _buildBloc,
      act: (bloc) => bloc.add(GenerateVideoEvent()),
      expect: () => [isA<VideoErrorState>()],
    );

    blocTest<VideoBloc, VideoState>(
      'emits VideoErrorState when VideoErrorState carries no image',
      build: _buildBloc,
      seed: () => VideoErrorState('previous error'),
      act: (bloc) => bloc.add(GenerateVideoEvent()),
      expect: () => [isA<VideoErrorState>()],
    );
  });

  // ── GenerateVideoEvent — happy path ───────────────────────────────────────

  group('GenerateVideoEvent — success', () {
    blocTest<VideoBloc, VideoState>(
      'emits Loading → Loading → Generated',
      build: () => _buildBloc(
        processImageFn: (_) async => _fakeImages,
        generateVideoFn: (_, {watermark, language}) async => _fakeVideoPath,
        getWatermarkSettingsFn: () async => _noWatermark,
      ),
      seed: () => ImagePickedState(_fakeImageFile),
      act: (bloc) => bloc.add(GenerateVideoEvent()),
      expect: () => [
        isA<VideoLoadingState>(),
        isA<VideoLoadingState>(),
        isA<VideoGeneratedState>(),
      ],
    );

    blocTest<VideoBloc, VideoState>(
      'VideoGeneratedState carries the correct videoPath',
      build: () => _buildBloc(
        processImageFn: (_) async => _fakeImages,
        generateVideoFn: (_, {watermark, language}) async => _fakeVideoPath,
        getWatermarkSettingsFn: () async => _noWatermark,
      ),
      seed: () => ImagePickedState(_fakeImageFile),
      act: (bloc) => bloc.add(GenerateVideoEvent()),
      expect: () => [
        isA<VideoLoadingState>(),
        isA<VideoLoadingState>(),
        isA<VideoGeneratedState>().having(
          (s) => s.videoPath,
          'videoPath',
          _fakeVideoPath,
        ),
      ],
    );

    blocTest<VideoBloc, VideoState>(
      'VideoGeneratedState carries the source imageFile',
      build: () => _buildBloc(
        processImageFn: (_) async => _fakeImages,
        generateVideoFn: (_, {watermark, language}) async => _fakeVideoPath,
        getWatermarkSettingsFn: () async => _noWatermark,
      ),
      seed: () => ImagePickedState(_fakeImageFile),
      act: (bloc) => bloc.add(GenerateVideoEvent()),
      expect: () => [
        isA<VideoLoadingState>(),
        isA<VideoLoadingState>(),
        isA<VideoGeneratedState>().having(
          (s) => s.imageFile.path,
          'imagePath',
          _fakeImageFile.path,
        ),
      ],
    );

    blocTest<VideoBloc, VideoState>(
      'saves video record to database on success',
      build: () => _buildBloc(
        processImageFn: (_) async => _fakeImages,
        generateVideoFn: (_, {watermark, language}) async => _fakeVideoPath,
        getWatermarkSettingsFn: () async => _noWatermark,
      ),
      seed: () => ImagePickedState(_fakeImageFile),
      act: (bloc) => bloc.add(GenerateVideoEvent()),
      verify: (_) async {
        final videos = await db.getAllVideos();
        expect(videos, hasLength(1));
        expect(videos.first.videoPath, _fakeVideoPath);
      },
    );

    blocTest<VideoBloc, VideoState>(
      'works from a VideoErrorState that carries an imageFile',
      build: () => _buildBloc(
        processImageFn: (_) async => _fakeImages,
        generateVideoFn: (_, {watermark, language}) async => _fakeVideoPath,
        getWatermarkSettingsFn: () async => _noWatermark,
      ),
      seed: () => VideoErrorState('prior error', imageFile: _fakeImageFile),
      act: (bloc) => bloc.add(GenerateVideoEvent()),
      expect: () => [
        isA<VideoLoadingState>(),
        isA<VideoLoadingState>(),
        isA<VideoGeneratedState>(),
      ],
    );
  });

  // ── GenerateVideoEvent — custom messages ──────────────────────────────────

  group('GenerateVideoEvent — custom loading messages', () {
    blocTest<VideoBloc, VideoState>(
      'first VideoLoadingState uses processingMessage',
      build: () => _buildBloc(
        processImageFn: (_) async => _fakeImages,
        generateVideoFn: (_, {watermark, language}) async => _fakeVideoPath,
        getWatermarkSettingsFn: () async => _noWatermark,
      ),
      seed: () => ImagePickedState(_fakeImageFile),
      act: (bloc) => bloc.add(
        GenerateVideoEvent(processingMessage: 'Custom processing…'),
      ),
      expect: () => [
        isA<VideoLoadingState>().having(
          (s) => s.loadingMessage,
          'loadingMessage',
          'Custom processing…',
        ),
        isA<VideoLoadingState>(),
        isA<VideoGeneratedState>(),
      ],
    );

    blocTest<VideoBloc, VideoState>(
      'second VideoLoadingState uses generatingMessage',
      build: () => _buildBloc(
        processImageFn: (_) async => _fakeImages,
        generateVideoFn: (_, {watermark, language}) async => _fakeVideoPath,
        getWatermarkSettingsFn: () async => _noWatermark,
      ),
      seed: () => ImagePickedState(_fakeImageFile),
      act: (bloc) => bloc.add(
        GenerateVideoEvent(generatingMessage: 'Custom generating…'),
      ),
      expect: () => [
        isA<VideoLoadingState>(),
        isA<VideoLoadingState>().having(
          (s) => s.loadingMessage,
          'loadingMessage',
          'Custom generating…',
        ),
        isA<VideoGeneratedState>(),
      ],
    );
  });

  // ── GenerateVideoEvent — service failures ─────────────────────────────────

  group('GenerateVideoEvent — service failures', () {
    blocTest<VideoBloc, VideoState>(
      'emits VideoErrorState when generateVideo returns null',
      build: () => _buildBloc(
        processImageFn: (_) async => _fakeImages,
        generateVideoFn: (_, {watermark, language}) async => null,
        getWatermarkSettingsFn: () async => _noWatermark,
      ),
      seed: () => ImagePickedState(_fakeImageFile),
      act: (bloc) => bloc.add(GenerateVideoEvent()),
      expect: () => [
        isA<VideoLoadingState>(),
        isA<VideoLoadingState>(),
        isA<VideoErrorState>(),
      ],
    );

    blocTest<VideoBloc, VideoState>(
      'emits VideoErrorState when processImage throws',
      build: () => _buildBloc(
        processImageFn: (_) async => throw Exception('decode failed'),
        generateVideoFn: (_, {watermark, language}) async => _fakeVideoPath,
        getWatermarkSettingsFn: () async => _noWatermark,
      ),
      seed: () => ImagePickedState(_fakeImageFile),
      act: (bloc) => bloc.add(GenerateVideoEvent()),
      expect: () => [
        isA<VideoLoadingState>(),
        isA<VideoErrorState>(),
      ],
    );

    blocTest<VideoBloc, VideoState>(
      'VideoErrorState on failure still carries the imageFile',
      build: () => _buildBloc(
        processImageFn: (_) async => _fakeImages,
        generateVideoFn: (_, {watermark, language}) async => null,
        getWatermarkSettingsFn: () async => _noWatermark,
      ),
      seed: () => ImagePickedState(_fakeImageFile),
      act: (bloc) => bloc.add(GenerateVideoEvent()),
      expect: () => [
        isA<VideoLoadingState>(),
        isA<VideoLoadingState>(),
        isA<VideoErrorState>().having(
          (s) => s.imageFile?.path,
          'imagePath',
          _fakeImageFile.path,
        ),
      ],
    );

    blocTest<VideoBloc, VideoState>(
      'does not save to DB when video generation fails',
      build: () => _buildBloc(
        processImageFn: (_) async => _fakeImages,
        generateVideoFn: (_, {watermark, language}) async => null,
        getWatermarkSettingsFn: () async => _noWatermark,
      ),
      seed: () => ImagePickedState(_fakeImageFile),
      act: (bloc) => bloc.add(GenerateVideoEvent()),
      verify: (_) async {
        expect(await db.getAllVideos(), isEmpty);
      },
    );
  });
}
