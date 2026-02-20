part of 'bloc.dart';

abstract class RecentVideosState {}

class RecentVideosInitial extends RecentVideosState {}

class RecentVideosLoading extends RecentVideosState {}

class RecentVideosLoaded extends RecentVideosState {
  final List<VideoHistoryData> videos;

  RecentVideosLoaded(this.videos);
}

class RecentVideosError extends RecentVideosState {
  final String message;

  RecentVideosError(this.message);
}
