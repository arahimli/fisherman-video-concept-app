import 'package:fisherman_video/presentation/managers/history_bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/service_locator.dart';
import 'core/router/app_router.dart';
import 'l10n/app_localizations.dart';
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
        BlocProvider<HistoryBloc>(
          create: (context) => sl<HistoryBloc>()..add(LoadRecentVideosEvent()),
        ),
        BlocProvider<VideoBloc>(
          create: (context) => sl<VideoBloc>(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter,
        title: 'Vogue Motion',
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