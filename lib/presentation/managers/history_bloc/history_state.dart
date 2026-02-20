
part of 'bloc.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<VideoHistoryData> videos;
  final bool hasMore;
  final int currentPage;
  final DateTime? startDate;
  final DateTime? endDate;

  HistoryLoaded({
    required this.videos,
    this.hasMore = true,
    this.currentPage = 0,
    this.startDate,
    this.endDate,
  });

  HistoryLoaded copyWith({
    List<VideoHistoryData>? videos,
    bool? hasMore,
    int? currentPage,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return HistoryLoaded(
      videos: videos ?? this.videos,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

class RecentVideosLoaded extends HistoryState {
  final List<VideoHistoryData> videos;

  RecentVideosLoaded(this.videos);
}

class HistoryError extends HistoryState {
  final String message;

  HistoryError(this.message);
}