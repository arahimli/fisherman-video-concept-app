import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'core/ads/ads_config.dart';
import 'core/di/service_locator.dart';
import 'core/router/app_router.dart';
import 'l10n/app_localizations.dart';
import 'presentation/managers/recent_videos_bloc/bloc.dart';
import 'presentation/managers/video_bloc/bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  if (kDebugMode) {
    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: AdsConfig.testDeviceIds),
    );
  }
  await setupServiceLocator();
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
          appBarTheme: const AppBarTheme(
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
          ),
          snackBarTheme: SnackBarThemeData(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}