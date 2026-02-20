import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/service_locator.dart';
import 'core/router/app_router.dart';
import 'l10n/app_localizations.dart';
import 'presentation/managers/recent_videos_bloc/bloc.dart';
import 'presentation/managers/video_bloc/bloc.dart';

void main() {
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RecentVideosBloc>(
          create: (context) => sl<RecentVideosBloc>()..add(LoadRecentVideosEvent()),
        ),
        BlocProvider<VideoBloc>(
          create: (context) => sl<VideoBloc>(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter,
        title: 'Old Fisherman',
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0A0A0A),
          fontFamily: 'Georgia',
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}