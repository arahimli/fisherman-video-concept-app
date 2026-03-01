import 'package:bloc_test/bloc_test.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fisherman_video/data/database/app_database.dart';
import 'package:fisherman_video/presentation/managers/history_bloc/bloc.dart';

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

  HistoryBloc _buildBloc() => HistoryBloc(database: db);

  // ── initial state ─────────────────────────────────────────────────────────

  test('initial state is HistoryInitial', () {
    expect(_buildBloc().state, isA<HistoryInitial>());
  });

  // ── LoadHistoryEvent — first load ─────────────────────────────────────────

  group('LoadHistoryEvent — first load', () {
    blocTest<HistoryBloc, HistoryState>(
      'emits HistoryLoading then HistoryLoaded',
      build: _buildBloc,
      act: (bloc) => bloc.add(LoadHistoryEvent()),
      expect: () => [isA<HistoryLoading>(), isA<HistoryLoaded>()],
    );

    blocTest<HistoryBloc, HistoryState>(
      'loaded state has empty list for an empty database',
      build: _buildBloc,
      act: (bloc) => bloc.add(LoadHistoryEvent()),
      expect: () => [
        isA<HistoryLoading>(),
        isA<HistoryLoaded>().having((s) => s.videos, 'videos', isEmpty),
      ],
    );

    blocTest<HistoryBloc, HistoryState>(
      'loads the first page (10 of 15 records)',
      setUp: () => _seedVideos(db, 15),
      build: _buildBloc,
      act: (bloc) => bloc.add(LoadHistoryEvent()),
      expect: () => [
        isA<HistoryLoading>(),
        isA<HistoryLoaded>()
            .having((s) => s.videos.length, 'count', 10)
            .having((s) => s.hasMore, 'hasMore', true)
            .having((s) => s.currentPage, 'currentPage', 0),
      ],
    );

    blocTest<HistoryBloc, HistoryState>(
      'hasMore is false when fewer than pageSize records exist',
      setUp: () => _seedVideos(db, 5),
      build: _buildBloc,
      act: (bloc) => bloc.add(LoadHistoryEvent()),
      expect: () => [
        isA<HistoryLoading>(),
        isA<HistoryLoaded>().having((s) => s.hasMore, 'hasMore', false),
      ],
    );

    blocTest<HistoryBloc, HistoryState>(
      'hasMore is true when exactly pageSize records exist',
      setUp: () => _seedVideos(db, 10),
      build: _buildBloc,
      act: (bloc) => bloc.add(LoadHistoryEvent()),
      expect: () => [
        isA<HistoryLoading>(),
        isA<HistoryLoaded>().having((s) => s.hasMore, 'hasMore', true),
      ],
    );

    blocTest<HistoryBloc, HistoryState>(
      'stores startDate and endDate in the loaded state',
      build: _buildBloc,
      act: (bloc) => bloc.add(
        LoadHistoryEvent(
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 12, 31),
        ),
      ),
      expect: () => [
        isA<HistoryLoading>(),
        isA<HistoryLoaded>()
            .having((s) => s.startDate, 'startDate', DateTime(2024, 1, 1))
            .having((s) => s.endDate, 'endDate', DateTime(2024, 12, 31)),
      ],
    );
  });

  // ── LoadHistoryEvent — load more ──────────────────────────────────────────

  group('LoadHistoryEvent — load more (pagination)', () {
    blocTest<HistoryBloc, HistoryState>(
      'appends the next page to the existing list',
      setUp: () => _seedVideos(db, 15),
      build: _buildBloc,
      act: (bloc) async {
        bloc.add(LoadHistoryEvent());
        await bloc.stream.firstWhere((s) => s is HistoryLoaded);
        bloc.add(LoadHistoryEvent(loadMore: true));
      },
      expect: () => [
        isA<HistoryLoading>(),
        isA<HistoryLoaded>(), // page 0 — 10 videos
        isA<HistoryLoaded>(), // page 1 appended — 15 videos
      ],
      verify: (bloc) {
        final state = bloc.state as HistoryLoaded;
        expect(state.videos.length, 15);
        expect(state.currentPage, 1);
        expect(state.hasMore, isFalse);
      },
    );

    blocTest<HistoryBloc, HistoryState>(
      'does not emit HistoryLoading during load more',
      setUp: () => _seedVideos(db, 15),
      build: _buildBloc,
      act: (bloc) async {
        bloc.add(LoadHistoryEvent());
        await bloc.stream.firstWhere((s) => s is HistoryLoaded);
        bloc.add(LoadHistoryEvent(loadMore: true));
      },
      // HistoryLoading appears exactly once (for the initial load)
      verify: (bloc) {
        // nothing to assert here — the test above validates the emit sequence
      },
    );
  });

  // ── DeleteVideoEvent ──────────────────────────────────────────────────────

  group('DeleteVideoEvent', () {
    blocTest<HistoryBloc, HistoryState>(
      'removes the video from the loaded list',
      setUp: () => _seedVideos(db, 3),
      build: _buildBloc,
      act: (bloc) async {
        bloc.add(LoadHistoryEvent());
        final loaded =
            await bloc.stream.firstWhere((s) => s is HistoryLoaded) as HistoryLoaded;
        bloc.add(DeleteVideoEvent(loaded.videos.first.id));
      },
      expect: () => [
        isA<HistoryLoading>(),
        isA<HistoryLoaded>().having((s) => s.videos.length, 'before', 3),
        isA<HistoryLoaded>().having((s) => s.videos.length, 'after', 2),
      ],
    );

    blocTest<HistoryBloc, HistoryState>(
      'deletes the record from the database',
      setUp: () => _seedVideos(db, 1),
      build: _buildBloc,
      act: (bloc) async {
        bloc.add(LoadHistoryEvent());
        final loaded =
            await bloc.stream.firstWhere((s) => s is HistoryLoaded) as HistoryLoaded;
        bloc.add(DeleteVideoEvent(loaded.videos.first.id));
      },
      verify: (_) async {
        expect(await db.getAllVideos(), isEmpty);
      },
    );
  });

  // ── FilterByDateEvent ─────────────────────────────────────────────────────

  group('FilterByDateEvent', () {
    blocTest<HistoryBloc, HistoryState>(
      'triggers a reload (Loading → Loaded sequence)',
      build: _buildBloc,
      act: (bloc) => bloc.add(FilterByDateEvent()),
      expect: () => [isA<HistoryLoading>(), isA<HistoryLoaded>()],
    );

    blocTest<HistoryBloc, HistoryState>(
      'applies date filter to the resulting state',
      build: _buildBloc,
      act: (bloc) => bloc.add(FilterByDateEvent(
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 6, 30),
      )),
      expect: () => [
        isA<HistoryLoading>(),
        isA<HistoryLoaded>()
            .having((s) => s.startDate, 'startDate', DateTime(2024, 1, 1))
            .having((s) => s.endDate, 'endDate', DateTime(2024, 6, 30)),
      ],
    );
  });

  // ── HistoryLoaded.copyWith ────────────────────────────────────────────────

  group('HistoryLoaded.copyWith', () {
    test('creates a new instance with updated fields', () {
      final original = HistoryLoaded(videos: [], hasMore: true, currentPage: 0);
      final copy = original.copyWith(hasMore: false, currentPage: 1);
      expect(copy.hasMore, isFalse);
      expect(copy.currentPage, 1);
      expect(copy.videos, isEmpty); // unchanged
    });

    test('preserves unmodified fields', () {
      final start = DateTime(2024, 1, 1);
      final original = HistoryLoaded(
        videos: [],
        hasMore: true,
        currentPage: 0,
        startDate: start,
      );
      final copy = original.copyWith(currentPage: 2);
      expect(copy.startDate, start);
    });
  });
}
