
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
  final String? language;

  HistoryLoaded({
    required this.videos,
    this.hasMore = true,
    this.currentPage = 0,
    this.startDate,
    this.endDate,
    this.language,
  });

  HistoryLoaded copyWith({
    List<VideoHistoryData>? videos,
    bool? hasMore,
    int? currentPage,
    DateTime? startDate,
    DateTime? endDate,
    String? language,
    bool clearLanguage = false,
  }) {
    return HistoryLoaded(
      videos: videos ?? this.videos,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      language: clearLanguage ? null : (language ?? this.language),
    );
  }
}

class HistoryError extends HistoryState {
  final String message;

  HistoryError(this.message);
}