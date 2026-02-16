import 'package:fisherman_video/presentation/managers/history_bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/database/app_database.dart';
import 'l10n/app_localizations.dart';
import 'presentation/managers/video_bloc/bloc.dart';
import 'presentation/pages/home_page.dart';

void main() {  // Initialize database globally
  final database = AppDatabase();
  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;

  const MyApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vogue Motion',
      // localizationsDelegates: const [
      //   AppLocalizations.delegate,
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      locale: Locale(
        'en'
      ),
      localizationsDelegates:
      AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        fontFamily: 'Georgia',
      ),
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<VideoBloc>(
            create: (context) => VideoBloc(database: database),
          ),
          BlocProvider<HistoryBloc>(
            create: (context) => HistoryBloc(database: database)
              ..add(LoadRecentVideosEvent()),
          ),
        ],
        child: const NewHomePage(),
      ),
    );
  }
}