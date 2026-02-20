import 'package:go_router/go_router.dart';

import '../../presentation/pages/history_page.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/video_preview_page.dart';
import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const NewHomePage(),
    ),
    GoRoute(
      path: AppRoutes.history,
      builder: (context, state) => const HistoryPage(),
    ),
    GoRoute(
      path: AppRoutes.videoPreview,
      builder: (context, state) {
        final videoPath = state.extra as String;
        return VideoPreviewScreen(videoPath: videoPath);
      },
    ),
  ],
);
