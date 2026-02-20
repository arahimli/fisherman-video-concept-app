part of 'bloc.dart';

class RecentVideosBloc extends Bloc<RecentVideosEvent, RecentVideosState> {
  final AppDatabase database;

  RecentVideosBloc({required this.database}) : super(RecentVideosInitial()) {
    on<LoadRecentVideosEvent>(_onLoad);
  }

  Future<void> _onLoad(
    LoadRecentVideosEvent event,
    Emitter<RecentVideosState> emit,
  ) async {
    try {
      emit(RecentVideosLoading());
      final videos = await database.getAllVideos(limit: 10);
      emit(RecentVideosLoaded(videos));
    } catch (e) {
      emit(RecentVideosError('Failed to load recent videos: $e'));
    }
  }
}
