import 'package:bloc_test/bloc_test.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fisherman_video/data/database/app_database.dart';
import 'package:fisherman_video/presentation/managers/recent_videos_bloc/bloc.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

AppDatabase _openDb() => AppDatabase.forTesting(NativeDatabase.memory());

Future<void> _seedVideos(AppDatabase db, int count) async {
  for (int i = 0; i < count; i++) {
    await db.createVideo(VideoHistoryCompanion.insert(
      videoPath: '/v$i.mp4',
      title: 'MOTION_$i',
      createdAt: DateTime(2024, 1, 1).add(Duration(minutes: i)),
    ));
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late AppDatabase db;

  setUp(() => db = _openDb());
  tearDown(() async => db.close());

  RecentVideosBloc _buildBloc() => RecentVideosBloc(database: db);

  // ── initial state ─────────────────────────────────────────────────────────

  test('initial state is RecentVideosInitial', () {
    expect(_buildBloc().state, isA<RecentVideosInitial>());
  });

  // ── LoadRecentVideosEvent ─────────────────────────────────────────────────

  group('LoadRecentVideosEvent', () {
    blocTest<RecentVideosBloc, RecentVideosState>(
      'emits Loading then Loaded',
      build: _buildBloc,
      act: (bloc) => bloc.add(LoadRecentVideosEvent()),
      expect: () => [isA<RecentVideosLoading>(), isA<RecentVideosLoaded>()],
    );

    blocTest<RecentVideosBloc, RecentVideosState>(
      'loaded state has empty list for an empty database',
      build: _buildBloc,
      act: (bloc) => bloc.add(LoadRecentVideosEvent()),
      expect: () => [
        isA<RecentVideosLoading>(),
        isA<RecentVideosLoaded>()
            .having((s) => s.videos, 'videos', isEmpty),
      ],
    );

    blocTest<RecentVideosBloc, RecentVideosState>(
      'caps results at 10 when more than 10 records exist',
      setUp: () => _seedVideos(db, 15),
      build: _buildBloc,
      act: (bloc) => bloc.add(LoadRecentVideosEvent()),
      expect: () => [
        isA<RecentVideosLoading>(),
        isA<RecentVideosLoaded>()
            .having((s) => s.videos.length, 'count', 10),
      ],
    );

    blocTest<RecentVideosBloc, RecentVideosState>(
      'returns all videos when fewer than 10 exist',
      setUp: () => _seedVideos(db, 4),
      build: _buildBloc,
      act: (bloc) => bloc.add(LoadRecentVideosEvent()),
      expect: () => [
        isA<RecentVideosLoading>(),
        isA<RecentVideosLoaded>()
            .having((s) => s.videos.length, 'count', 4),
      ],
    );

    blocTest<RecentVideosBloc, RecentVideosState>(
      'returns exactly 10 when the database has exactly 10 records',
      setUp: () => _seedVideos(db, 10),
      build: _buildBloc,
      act: (bloc) => bloc.add(LoadRecentVideosEvent()),
      expect: () => [
        isA<RecentVideosLoading>(),
        isA<RecentVideosLoaded>()
            .having((s) => s.videos.length, 'count', 10),
      ],
    );

    blocTest<RecentVideosBloc, RecentVideosState>(
      'a second dispatch overwrites the first loaded state',
      setUp: () => _seedVideos(db, 3),
      build: _buildBloc,
      act: (bloc) async {
        bloc.add(LoadRecentVideosEvent());
        await bloc.stream.firstWhere((s) => s is RecentVideosLoaded);
        bloc.add(LoadRecentVideosEvent());
      },
      expect: () => [
        isA<RecentVideosLoading>(),
        isA<RecentVideosLoaded>(),
        isA<RecentVideosLoading>(),
        isA<RecentVideosLoaded>(),
      ],
    );
  });
}
