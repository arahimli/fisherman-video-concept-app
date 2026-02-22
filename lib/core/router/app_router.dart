import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/service_locator.dart';
import '../../presentation/managers/history_bloc/bloc.dart';
import '../../presentation/pages/history_page.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/splash_page.dart';
import '../../presentation/pages/settings_page.dart';
import '../../presentation/pages/video_preview_page.dart';
import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => BlocProvider<HistoryBloc>(
        create: (_) => sl<HistoryBloc>(),
        child: const NewHomePage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.history,
      builder: (context, state) => BlocProvider<HistoryBloc>(
        create: (_) => sl<HistoryBloc>()..add(LoadHistoryEvent()),
        child: const HistoryPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.videoPreview,
      builder: (context, state) {
        final videoPath = state.extra as String;
        return VideoPreviewScreen(videoPath: videoPath);
      },
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);
