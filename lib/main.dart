import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'l10n/app_localizations.dart';
import 'presentation/managers/video_bloc/bloc.dart';
import 'presentation/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: BlocProvider(
        create: (context) => VideoBloc(),
        child: const NewHomePage(),
      ),
    );
  }
}