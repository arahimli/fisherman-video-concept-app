// blocs/history_bloc.dart
part of 'bloc.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final AppDatabase database;
  static const int pageSize = 10;

  HistoryBloc({required this.database}) : super(HistoryInitial()) {
    on<LoadHistoryEvent>(_onLoadHistory);
    on<DeleteVideoEvent>(_onDeleteVideo);
    on<FilterByDateEvent>(_onFilterByDate);
    on<FilterByLanguageEvent>(_onFilterByLanguage);
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
          language: event.language ?? currentState.language,
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
          language: event.language,
        );

        emit(HistoryLoaded(
          videos: videos,
          hasMore: videos.length == pageSize,
          currentPage: 0,
          startDate: event.startDate,
          endDate: event.endDate,
          language: event.language,
        ));
      }
    } catch (e) {
      emit(HistoryError('Failed to load history: $e'));
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
      }
    } catch (e) {
      emit(HistoryError('Failed to delete video: $e'));
    }
  }

  Future<void> _onFilterByDate(
      FilterByDateEvent event,
      Emitter<HistoryState> emit,
      ) async {
    final currentLanguage = state is HistoryLoaded ? (state as HistoryLoaded).language : null;
    add(LoadHistoryEvent(
      startDate: event.startDate,
      endDate: event.endDate,
      language: currentLanguage,
    ));
  }

  Future<void> _onFilterByLanguage(
      FilterByLanguageEvent event,
      Emitter<HistoryState> emit,
      ) async {
    final currentState = state is HistoryLoaded ? state as HistoryLoaded : null;
    add(LoadHistoryEvent(
      startDate: currentState?.startDate,
      endDate: currentState?.endDate,
      language: event.language,
    ));
  }
}