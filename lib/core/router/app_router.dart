import 'package:go_router/go_router.dart';

import '../../presentation/pages/history_page.dart';
import '../../presentation/pages/home_page.dart';
import '../../video_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const NewHomePage(),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryPage(),
    ),
    GoRoute(
      path: '/video-preview',
      builder: (context, state) {
        final videoPath = state.extra as String;
        return VideoPreviewScreen(videoPath: videoPath);
      },
    ),
  ],
);
