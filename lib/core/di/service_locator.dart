import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

import '../../data/database/app_database.dart';
import '../../data/repositories/video_history_repository.dart';
import '../../data/services/force_update_service.dart';
import '../../presentation/managers/history_bloc/bloc.dart';
import '../../presentation/managers/locale_bloc/bloc.dart';
import '../../presentation/managers/recent_videos_bloc/bloc.dart';
import '../../presentation/managers/video_bloc/bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  await Firebase.initializeApp();

  sl.registerLazySingleton<ForceUpdateService>(() => ForceUpdateService());
  // Database
  sl.registerSingleton<AppDatabase>(AppDatabase());

  // Repository
  sl.registerSingleton<VideoHistoryRepository>(
    VideoHistoryRepository(sl<AppDatabase>()),
  );

  // BLoCs
  sl.registerLazySingleton<LocaleBloc>(() => LocaleBloc());

  sl.registerFactory<VideoBloc>(
    () => VideoBloc(database: sl<AppDatabase>()),
  );

  sl.registerFactory<HistoryBloc>(
    () => HistoryBloc(database: sl<AppDatabase>()),
  );

  sl.registerFactory<RecentVideosBloc>(
    () => RecentVideosBloc(database: sl<AppDatabase>()),
  );
}
