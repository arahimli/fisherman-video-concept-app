// repositories/video_history_repository.dart
import 'package:drift/drift.dart' as drift;
import '../database/app_database.dart';

class VideoHistoryRepository {
  final AppDatabase _database;

  VideoHistoryRepository(this._database);

  // Create new video
  Future<int> createVideo({
    required String videoPath,
    String? thumbnailPath,
    String? imagePath,
    required String title,
  }) async {
    final video = VideoHistoryCompanion(
      videoPath: drift.Value(videoPath),
      thumbnailPath: drift.Value(thumbnailPath),
      imagePath: drift.Value(imagePath),
      createdAt: drift.Value(DateTime.now()),
      title: drift.Value(title),
    );

    return await _database.createVideo(video);
  }

  // Get all videos with pagination
  Future<List<VideoHistoryData>> getAllVideos({
    int? limit,
    int? offset,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await _database.getAllVideos(
      limit: limit,
      offset: offset,
      startDate: startDate,
      endDate: endDate,
    );
  }

  // Get recent videos (last 10)
  Future<List<VideoHistoryData>> getRecentVideos({int limit = 10}) async {
    return await _database.getAllVideos(limit: limit);
  }

  // Watch videos (Stream for real-time updates)
  Stream<List<VideoHistoryData>> watchAllVideos({
    int? limit,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _database.watchAllVideos(
      limit: limit,
      startDate: startDate,
      endDate: endDate,
    );
  }

  // Watch recent videos
  Stream<List<VideoHistoryData>> watchRecentVideos({int limit = 10}) {
    return _database.watchAllVideos(limit: limit);
  }

  // Get video count
  Future<int> getVideoCount({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await _database.getVideoCount(
      startDate: startDate,
      endDate: endDate,
    );
  }

  // Delete video
  Future<int> deleteVideo(int id) async {
    return await _database.deleteVideo(id);
  }

  // Update video
  Future<bool> updateVideo(VideoHistoryData video) async {
    return await _database.updateVideo(video);
  }

  // Get videos by date range
  Future<List<VideoHistoryData>> getVideosByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    int? limit,
    int? offset,
  }) async {
    return await _database.getAllVideos(
      startDate: startDate,
      endDate: endDate,
      limit: limit,
      offset: offset,
    );
  }

  // Get videos for today
  Future<List<VideoHistoryData>> getTodayVideos() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return await _database.getAllVideos(
      startDate: startOfDay,
      endDate: endOfDay,
    );
  }

  // Get videos for yesterday
  Future<List<VideoHistoryData>> getYesterdayVideos() async {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final startOfDay = DateTime(yesterday.year, yesterday.month, yesterday.day);
    final endOfDay =
    DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);

    return await _database.getAllVideos(
      startDate: startOfDay,
      endDate: endOfDay,
    );
  }

  // Get videos for this week
  Future<List<VideoHistoryData>> getThisWeekVideos() async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startDate =
    DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

    return await _database.getAllVideos(
      startDate: startDate,
      endDate: now,
    );
  }

  // Get videos for this month
  Future<List<VideoHistoryData>> getThisMonthVideos() async {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, 1);

    return await _database.getAllVideos(
      startDate: startDate,
      endDate: now,
    );
  }

  // Search videos by title
  Future<List<VideoHistoryData>> searchVideosByTitle(String query) async {
    final allVideos = await _database.getAllVideos();
    return allVideos
        .where((video) =>
        video.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Delete all videos
  Future<void> deleteAllVideos() async {
    final allVideos = await _database.getAllVideos();
    for (final video in allVideos) {
      await _database.deleteVideo(video.id);
    }
  }

  // Delete videos older than specified days
  Future<int> deleteOldVideos({required int days}) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    final oldVideos = await _database.getAllVideos();

    int deletedCount = 0;
    for (final video in oldVideos) {
      if (video.createdAt.isBefore(cutoffDate)) {
        await _database.deleteVideo(video.id);
        deletedCount++;
      }
    }

    return deletedCount;
  }

  // Get statistics
  Future<Map<String, dynamic>> getStatistics() async {
    final allVideos = await _database.getAllVideos();
    final now = DateTime.now();

    final todayStart = DateTime(now.year, now.month, now.day);
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final monthStart = DateTime(now.year, now.month, 1);

    final todayCount = allVideos
        .where((v) => v.createdAt.isAfter(todayStart))
        .length;

    final weekCount = allVideos
        .where((v) => v.createdAt.isAfter(weekStart))
        .length;

    final monthCount = allVideos
        .where((v) => v.createdAt.isAfter(monthStart))
        .length;

    return {
      'total': allVideos.length,
      'today': todayCount,
      'thisWeek': weekCount,
      'thisMonth': monthCount,
    };
  }

  // Close database connection
  Future<void> close() async {
    await _database.close();
  }
}