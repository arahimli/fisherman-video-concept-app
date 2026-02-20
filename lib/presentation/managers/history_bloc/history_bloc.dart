// blocs/history_bloc.dart
part of 'bloc.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final AppDatabase database;
  static const int pageSize = 10;

  HistoryBloc({required this.database}) : super(HistoryInitial()) {
    on<LoadHistoryEvent>(_onLoadHistory);
    on<LoadRecentVideosEvent>(_onLoadRecentVideos);
    on<DeleteVideoEvent>(_onDeleteVideo);
    on<FilterByDateEvent>(_onFilterByDate);
  }

  Future<void> _onLoadHistory(
      LoadHistoryEvent event,
      Emitter<HistoryState> emit,
      ) async {
    try {
      if (event.loadMore && state is HistoryLoaded) {
        final currentState = state as HistoryLoaded;
        final nextPage = currentState.currentPage + 1;

        final newVideos = await database.getAllVideos(
          limit: pageSize,
          offset: nextPage * pageSize,
          startDate: event.startDate ?? currentState.startDate,
          endDate: event.endDate ?? currentState.endDate,
        );

        emit(currentState.copyWith(
          videos: [...currentState.videos, ...newVideos],
          hasMore: newVideos.length == pageSize,
          currentPage: nextPage,
        ));
      } else {
        emit(HistoryLoading());

        final videos = await database.getAllVideos(
          limit: pageSize,
          offset: 0,
          startDate: event.startDate,
          endDate: event.endDate,
        );

        emit(HistoryLoaded(
          videos: videos,
          hasMore: videos.length == pageSize,
          currentPage: 0,
          startDate: event.startDate,
          endDate: event.endDate,
        ));
      }
    } catch (e) {
      emit(HistoryError('Failed to load history: $e'));
    }
  }

  Future<void> _onLoadRecentVideos(
      LoadRecentVideosEvent event,
      Emitter<HistoryState> emit,
      ) async {
    try {
      final videos = await database.getAllVideos(limit: 10);
      emit(RecentVideosLoaded(videos));
    } catch (e) {
      emit(HistoryError('Failed to load recent videos: $e'));
    }
  }

  Future<void> _onDeleteVideo(
      DeleteVideoEvent event,
      Emitter<HistoryState> emit,
      ) async {
    try {
      await database.deleteVideo(event.videoId);

      if (state is HistoryLoaded) {
        final currentState = state as HistoryLoaded;
        final updatedVideos = currentState.videos
            .where((video) => video.id != event.videoId)
            .toList();

        emit(currentState.copyWith(videos: updatedVideos));
      } else if (state is RecentVideosLoaded) {
        // Reload recent videos
        add(LoadRecentVideosEvent());
      }
    } catch (e) {
      emit(HistoryError('Failed to delete video: $e'));
    }
  }

  Future<void> _onFilterByDate(
      FilterByDateEvent event,
      Emitter<HistoryState> emit,
      ) async {
    add(LoadHistoryEvent(
      startDate: event.startDate,
      endDate: event.endDate,
    ));
  }
}