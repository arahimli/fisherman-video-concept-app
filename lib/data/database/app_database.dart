// database/app_database.dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

class VideoHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get videoPath => text()();
  TextColumn get thumbnailPath => text().nullable()();
  TextColumn get imagePath => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get title => text()();
  TextColumn get language => text().nullable()();
}

@DriftDatabase(tables: [VideoHistory])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Opens an in-memory database — use only in tests.
  AppDatabase.forTesting(QueryExecutor executor) : super(executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(videoHistory, videoHistory.language);
          }
        },
      );

  // Create
  Future<int> createVideo(VideoHistoryCompanion video) async {
    return await into(videoHistory).insert(video);
  }

  // Read all with pagination and filters
  Future<List<VideoHistoryData>> getAllVideos({
    int? limit,
    int? offset,
    DateTime? startDate,
    DateTime? endDate,
    String? language,
  }) async {
    final query = select(videoHistory)
      ..orderBy([
            (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
      ]);

    if (startDate != null && endDate != null) {
      query.where((tbl) =>
      tbl.createdAt.isBiggerOrEqualValue(startDate) &
      tbl.createdAt.isSmallerOrEqualValue(endDate));
    }

    if (language != null) {
      query.where((tbl) => tbl.language.equals(language));
    }

    if (limit != null) {
      query.limit(limit, offset: offset);
    }

    return await query.get();
  }

  // Get count
  Future<int> getVideoCount({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final query = selectOnly(videoHistory)..addColumns([videoHistory.id.count()]);

    if (startDate != null && endDate != null) {
      query.where(
        videoHistory.createdAt.isBiggerOrEqualValue(startDate) &
        videoHistory.createdAt.isSmallerOrEqualValue(endDate),
      );
    }

    final result = await query.getSingle();
    return result.read(videoHistory.id.count()) ?? 0;
  }

  // Watch videos (for stream)
  Stream<List<VideoHistoryData>> watchAllVideos({
    int? limit,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final query = select(videoHistory)
      ..orderBy([
            (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
      ]);

    if (startDate != null && endDate != null) {
      query.where((tbl) =>
      tbl.createdAt.isBiggerOrEqualValue(startDate) &
      tbl.createdAt.isSmallerOrEqualValue(endDate));
    }

    if (limit != null) {
      query.limit(limit);
    }

    return query.watch();
  }

  // Delete
  Future<int> deleteVideo(int id) async {
    return await (delete(videoHistory)..where((t) => t.id.equals(id))).go();
  }

  // Update
  Future<bool> updateVideo(VideoHistoryData video) async {
    return await update(videoHistory).replace(video);
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'video_history.sqlite'));
    return NativeDatabase(file);
  });
}