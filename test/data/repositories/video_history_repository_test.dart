import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fisherman_video/data/database/app_database.dart';
import 'package:fisherman_video/data/repositories/video_history_repository.dart';

AppDatabase _openDb() => AppDatabase.forTesting(NativeDatabase.memory());

VideoHistoryCompanion _companion({
  String videoPath = '/video.mp4',
  String title = 'MOTION_001',
  String? imagePath,
  DateTime? createdAt,
}) =>
    VideoHistoryCompanion.insert(
      videoPath: videoPath,
      title: title,
      createdAt: createdAt ?? DateTime.now(),
      imagePath: imagePath == null ? const Value.absent() : Value(imagePath),
    );

void main() {
  late AppDatabase db;
  late VideoHistoryRepository repo;

  setUp(() {
    db = _openDb();
    repo = VideoHistoryRepository(db);
  });

  tearDown(() async => db.close());

  // ── createVideo ───────────────────────────────────────────────────────────

  group('createVideo', () {
    test('returns a positive id', () async {
      final id = await repo.createVideo(
        videoPath: '/v.mp4',
        title: 'T',
      );
      expect(id, isPositive);
    });

    test('persisted record can be queried back', () async {
      await repo.createVideo(
        videoPath: '/v.mp4',
        title: 'MOTION_TEST',
        imagePath: '/img.jpg',
      );
      final all = await repo.getAllVideos();
      expect(all, hasLength(1));
      expect(all.first.videoPath, '/v.mp4');
      expect(all.first.title, 'MOTION_TEST');
      expect(all.first.imagePath, '/img.jpg');
    });

    test('thumbnailPath defaults to null', () async {
      await repo.createVideo(videoPath: '/v.mp4', title: 'T');
      final video = (await repo.getAllVideos()).first;
      expect(video.thumbnailPath, isNull);
    });
  });

  // ── getAllVideos ──────────────────────────────────────────────────────────

  group('getAllVideos', () {
    setUp(() async {
      for (int i = 1; i <= 15; i++) {
        await db.createVideo(_companion(
          videoPath: '/v$i.mp4',
          title: 'T$i',
          // stagger timestamps so ordering is deterministic
          createdAt: DateTime(2024, 1, 1).add(Duration(minutes: i)),
        ));
      }
    });

    test('returns all 15 records when no limit', () async {
      expect(await repo.getAllVideos(), hasLength(15));
    });

    test('respects limit', () async {
      expect(await repo.getAllVideos(limit: 5), hasLength(5));
    });

    test('respects offset', () async {
      final all = await repo.getAllVideos();
      final paged = await repo.getAllVideos(limit: 5, offset: 5);
      expect(paged.first.id, isNot(equals(all.first.id)));
      expect(paged, hasLength(5));
    });

    test('results are ordered newest-first', () async {
      final videos = await repo.getAllVideos();
      for (int i = 0; i < videos.length - 1; i++) {
        expect(
          videos[i].createdAt.isAfter(videos[i + 1].createdAt) ||
              videos[i].createdAt.isAtSameMomentAs(videos[i + 1].createdAt),
          isTrue,
        );
      }
    });
  });

  // ── getRecentVideos ───────────────────────────────────────────────────────

  group('getRecentVideos', () {
    test('returns at most 10 from a 15-record db', () async {
      for (int i = 0; i < 15; i++) {
        await repo.createVideo(videoPath: '/v$i.mp4', title: 'T$i');
      }
      expect(await repo.getRecentVideos(), hasLength(10));
    });

    test('honours a custom limit', () async {
      for (int i = 0; i < 5; i++) {
        await repo.createVideo(videoPath: '/v$i.mp4', title: 'T$i');
      }
      expect(await repo.getRecentVideos(limit: 3), hasLength(3));
    });

    test('returns all when count is below the limit', () async {
      await repo.createVideo(videoPath: '/v.mp4', title: 'T');
      expect(await repo.getRecentVideos(), hasLength(1));
    });
  });

  // ── deleteVideo ───────────────────────────────────────────────────────────

  group('deleteVideo', () {
    test('removes the record', () async {
      final id = await repo.createVideo(videoPath: '/v.mp4', title: 'T');
      await repo.deleteVideo(id);
      expect(await repo.getAllVideos(), isEmpty);
    });

    test('returns 1 when a row was deleted', () async {
      final id = await repo.createVideo(videoPath: '/v.mp4', title: 'T');
      expect(await repo.deleteVideo(id), 1);
    });

    test('returns 0 for an unknown id', () async {
      expect(await repo.deleteVideo(9999), 0);
    });

    test('does not affect other records', () async {
      final id = await repo.createVideo(videoPath: '/a.mp4', title: 'A');
      await repo.createVideo(videoPath: '/b.mp4', title: 'B');
      await repo.deleteVideo(id);
      expect(await repo.getAllVideos(), hasLength(1));
    });
  });

  // ── updateVideo ───────────────────────────────────────────────────────────

  group('updateVideo', () {
    test('change persists after update', () async {
      await repo.createVideo(videoPath: '/v.mp4', title: 'OLD');
      final original = (await repo.getAllVideos()).first;
      await repo.updateVideo(original.copyWith(title: 'NEW'));
      expect((await repo.getAllVideos()).first.title, 'NEW');
    });
  });

  // ── searchVideosByTitle ───────────────────────────────────────────────────

  group('searchVideosByTitle', () {
    setUp(() async {
      await repo.createVideo(videoPath: '/a.mp4', title: 'MOTION_ABC');
      await repo.createVideo(videoPath: '/b.mp4', title: 'MOTION_XYZ');
      await repo.createVideo(videoPath: '/c.mp4', title: 'OTHER_CLIP');
    });

    test('finds records by partial match (case-insensitive)', () async {
      expect(await repo.searchVideosByTitle('motion'), hasLength(2));
    });

    test('is case-insensitive', () async {
      expect(await repo.searchVideosByTitle('MOTION'), hasLength(2));
    });

    test('returns empty list when nothing matches', () async {
      expect(await repo.searchVideosByTitle('NOPE'), isEmpty);
    });

    test('exact match returns one result', () async {
      expect(await repo.searchVideosByTitle('OTHER_CLIP'), hasLength(1));
    });
  });

  // ── date-range helpers ────────────────────────────────────────────────────

  group('getTodayVideos', () {
    test('includes a just-inserted video', () async {
      await repo.createVideo(videoPath: '/v.mp4', title: 'T');
      final results = await repo.getTodayVideos();
      expect(results, isNotEmpty);
    });

    test('does not include a video from 2 days ago', () async {
      await db.createVideo(_companion(
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ));
      expect(await repo.getTodayVideos(), isEmpty);
    });
  });

  group('getYesterdayVideos', () {
    test('returns empty for a freshly inserted (today) video', () async {
      await repo.createVideo(videoPath: '/v.mp4', title: 'T');
      expect(await repo.getYesterdayVideos(), isEmpty);
    });
  });

  group('getThisWeekVideos', () {
    test('includes a just-inserted video', () async {
      await repo.createVideo(videoPath: '/v.mp4', title: 'T');
      expect(await repo.getThisWeekVideos(), isNotEmpty);
    });
  });

  group('getThisMonthVideos', () {
    test('includes a just-inserted video', () async {
      await repo.createVideo(videoPath: '/v.mp4', title: 'T');
      expect(await repo.getThisMonthVideos(), isNotEmpty);
    });
  });

  // ── getStatistics ─────────────────────────────────────────────────────────

  group('getStatistics', () {
    test('all counters are 0 for an empty database', () async {
      final stats = await repo.getStatistics();
      expect(stats['total'], 0);
      expect(stats['today'], 0);
      expect(stats['thisWeek'], 0);
      expect(stats['thisMonth'], 0);
    });

    test('a newly inserted video increments all counters', () async {
      await repo.createVideo(videoPath: '/v.mp4', title: 'T');
      final stats = await repo.getStatistics();
      expect(stats['total'], 1);
      expect(stats['today'], 1);
      expect(stats['thisWeek'], 1);
      expect(stats['thisMonth'], 1);
    });

    test('total reflects all records regardless of age', () async {
      await repo.createVideo(videoPath: '/a.mp4', title: 'A');
      await repo.createVideo(videoPath: '/b.mp4', title: 'B');
      expect((await repo.getStatistics())['total'], 2);
    });
  });

  // ── deleteOldVideos ───────────────────────────────────────────────────────

  group('deleteOldVideos', () {
    test('does not delete a record inserted today', () async {
      await repo.createVideo(videoPath: '/v.mp4', title: 'T');
      expect(await repo.deleteOldVideos(days: 30), 0);
      expect(await repo.getAllVideos(), hasLength(1));
    });

    test('deletes a record older than the threshold', () async {
      await db.createVideo(_companion(
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
      ));
      expect(await repo.deleteOldVideos(days: 30), 1);
      expect(await repo.getAllVideos(), isEmpty);
    });

    test('only deletes records beyond the threshold', () async {
      await repo.createVideo(videoPath: '/new.mp4', title: 'NEW');
      await db.createVideo(_companion(
        videoPath: '/old.mp4',
        title: 'OLD',
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
      ));
      expect(await repo.deleteOldVideos(days: 30), 1);
      expect(await repo.getAllVideos(), hasLength(1));
    });
  });

  // ── deleteAllVideos ───────────────────────────────────────────────────────

  group('deleteAllVideos', () {
    test('empties the table', () async {
      await repo.createVideo(videoPath: '/a.mp4', title: 'A');
      await repo.createVideo(videoPath: '/b.mp4', title: 'B');
      await repo.deleteAllVideos();
      expect(await repo.getAllVideos(), isEmpty);
    });

    test('is a no-op on an already-empty table', () async {
      await repo.deleteAllVideos();
      expect(await repo.getAllVideos(), isEmpty);
    });
  });
}
