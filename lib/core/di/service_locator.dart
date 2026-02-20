import 'package:get_it/get_it.dart';

import '../../data/database/app_database.dart';
import '../../data/repositories/video_history_repository.dart';
import '../../presentation/managers/history_bloc/bloc.dart';
import '../../presentation/managers/video_bloc/bloc.dart';

final GetIt sl = GetIt.instance;

void setupServiceLocator() {
  // Database
  sl.registerSingleton<AppDatabase>(AppDatabase());

  // Repository
  sl.registerSingleton<VideoHistoryRepository>(
    VideoHistoryRepository(sl<AppDatabase>()),
  );

  // BLoCs
  sl.registerFactory<VideoBloc>(
    () => VideoBloc(database: sl<AppDatabase>()),
  );

  sl.registerFactory<HistoryBloc>(
    () => HistoryBloc(database: sl<AppDatabase>()),
  );
}
