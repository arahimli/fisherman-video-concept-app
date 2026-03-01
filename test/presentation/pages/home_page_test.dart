import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:fisherman_video/data/database/app_database.dart';
import 'package:fisherman_video/data/services/settings_service.dart';
import 'package:fisherman_video/l10n/app_localizations.dart';
import 'package:fisherman_video/presentation/managers/recent_videos_bloc/bloc.dart';
import 'package:fisherman_video/presentation/managers/video_bloc/bloc.dart';
import 'package:fisherman_video/presentation/pages/home_page.dart';
import 'package:fisherman_video/presentation/widgets/home/create_mode_widget.dart';
import 'package:fisherman_video/presentation/widgets/home/image_preview_mode_widget.dart';
import 'package:fisherman_video/presentation/widgets/home/loading_state_widget.dart';
import 'package:fisherman_video/presentation/widgets/home/video_ready_mode_widget.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

AppDatabase _openDb() => AppDatabase.forTesting(NativeDatabase.memory());

final _noWatermark = WatermarkSettings(
  imageEnabled: false,
  position: WatermarkPosition.topRight,
);

/// Creates a [VideoBloc] pre-seeded with [initialState].
/// All service functions are no-ops so no real I/O occurs during tests.
VideoBloc _makeVideoBloc(AppDatabase db, VideoState initialState) {
  final bloc = VideoBloc(
    database: db,
    processImageFn: (_) async => {},
    generateVideoFn: (_, {watermark, language}) async => null,
    getWatermarkSettingsFn: () async => _noWatermark,
  );
  // @visibleForTesting — allowed in test code.
  bloc.emit(initialState);
  return bloc;
}

RecentVideosBloc _makeRecentVideosBloc(AppDatabase db) =>
    RecentVideosBloc(database: db);

/// Wraps [NewHomePage] in the full environment required for widget tests:
/// BLoC providers placed *above* [MaterialApp.router] (so they are visible
/// to [BlocListener] / [BlocBuilder] widgets deep in the route tree),
/// a stub [GoRouter], and English localizations.
Widget _buildApp(VideoBloc videoBloc, RecentVideosBloc recentBloc) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => const NewHomePage()),
      GoRoute(path: '/support', builder: (_, __) => const Scaffold()),
      GoRoute(path: '/settings', builder: (_, __) => const Scaffold()),
      GoRoute(path: '/video-preview', builder: (_, __) => const Scaffold()),
      GoRoute(path: '/history', builder: (_, __) => const Scaffold()),
    ],
  );

  return MultiBlocProvider(
    providers: [
      BlocProvider<VideoBloc>.value(value: videoBloc),
      BlocProvider<RecentVideosBloc>.value(value: recentBloc),
    ],
    child: MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
    ),
  );
}

// ---------------------------------------------------------------------------
// Shared test asset: a real file so Image.file doesn't crash on stat()
// ---------------------------------------------------------------------------

late File _imageFile;

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  setUpAll(() async {
    final dir = await Directory.systemTemp.createTemp('home_widget_test_');
    _imageFile = File('${dir.path}/test.jpg');
    // A real file on disk with minimal JPEG magic bytes.
    // The decode will fail gracefully — Flutter shows nothing, the test still passes.
    _imageFile.writeAsBytesSync(
      Uint8List.fromList([0xFF, 0xD8, 0xFF, 0xD9]),
    );

    // Stub the google_mobile_ads binary channel at the raw-bytes level.
    // setMockMethodCallHandler would fail because google_mobile_ads uses a
    // different wire format than StandardMethodCodec. Returning a
    // StandardMethodCodec success envelope lets invokeMethod() resolve normally.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(
      'plugins.flutter.io/google_mobile_ads',
      (_) async => const StandardMethodCodec().encodeSuccessEnvelope(null),
    );
  });

  // ── Body: correct child widget per VideoBloc state ─────────────────────────

  group('Body renders correct child widget for each VideoBloc state', () {
    late AppDatabase db;
    setUp(() => db = _openDb());
    tearDown(() async => db.close());

    testWidgets('VideoInitial → CreateModeWidget', (tester) async {
      final vBloc = _makeVideoBloc(db, VideoInitial());
      final rBloc = _makeRecentVideosBloc(db);
      addTearDown(() async {
        await vBloc.close();
        await rBloc.close();
      });

      await tester.pumpWidget(_buildApp(vBloc, rBloc));
      await tester.pump();

      expect(find.byType(CreateModeWidget), findsOneWidget);
    });

    testWidgets(
        'VideoLoadingState → LoadingStateWidget with loading message',
        (tester) async {
      final vBloc =
          _makeVideoBloc(db, VideoLoadingState(_imageFile, 'Processing image...'));
      final rBloc = _makeRecentVideosBloc(db);
      addTearDown(() async {
        await vBloc.close();
        await rBloc.close();
      });

      await tester.pumpWidget(_buildApp(vBloc, rBloc));
      // Single pump — avoids waiting for LoadingStateWidget's repeating animation.
      await tester.pump();

      expect(find.byType(LoadingStateWidget), findsOneWidget);
      expect(find.text('Processing image...'), findsOneWidget);
    });

    testWidgets('VideoGeneratedState → VideoReadyModeWidget', (tester) async {
      final vBloc =
          _makeVideoBloc(db, VideoGeneratedState(_imageFile, '/tmp/output.mp4'));
      final rBloc = _makeRecentVideosBloc(db);
      addTearDown(() async {
        await vBloc.close();
        await rBloc.close();
      });

      await tester.pumpWidget(_buildApp(vBloc, rBloc));
      await tester.pump();

      expect(find.byType(VideoReadyModeWidget), findsOneWidget);
    });

    testWidgets('VideoGeneratedState → "VIDEO READY" badge visible',
        (tester) async {
      final vBloc =
          _makeVideoBloc(db, VideoGeneratedState(_imageFile, '/tmp/output.mp4'));
      final rBloc = _makeRecentVideosBloc(db);
      addTearDown(() async {
        await vBloc.close();
        await rBloc.close();
      });

      await tester.pumpWidget(_buildApp(vBloc, rBloc));
      await tester.pump();

      expect(find.text('VIDEO READY'), findsOneWidget);
    });

    testWidgets('VideoGeneratedState → "PREVIEW VIDEO" button visible',
        (tester) async {
      final vBloc =
          _makeVideoBloc(db, VideoGeneratedState(_imageFile, '/tmp/output.mp4'));
      final rBloc = _makeRecentVideosBloc(db);
      addTearDown(() async {
        await vBloc.close();
        await rBloc.close();
      });

      await tester.pumpWidget(_buildApp(vBloc, rBloc));
      await tester.pump();

      expect(find.text('PREVIEW VIDEO'), findsOneWidget);
    });

    testWidgets('ImagePickedState → ImagePreviewModeWidget', (tester) async {
      final vBloc = _makeVideoBloc(db, ImagePickedState(_imageFile));
      final rBloc = _makeRecentVideosBloc(db);
      addTearDown(() async {
        await vBloc.close();
        await rBloc.close();
      });

      await tester.pumpWidget(_buildApp(vBloc, rBloc));
      await tester.pump();

      expect(find.byType(ImagePreviewModeWidget), findsOneWidget);
    });

    testWidgets(
        'VideoErrorState without imageFile → CreateModeWidget (fallback)',
        (tester) async {
      final vBloc = _makeVideoBloc(db, VideoErrorState('oops'));
      final rBloc = _makeRecentVideosBloc(db);
      addTearDown(() async {
        await vBloc.close();
        await rBloc.close();
      });

      await tester.pumpWidget(_buildApp(vBloc, rBloc));
      await tester.pump();

      expect(find.byType(CreateModeWidget), findsOneWidget);
    });

    testWidgets('VideoErrorState with imageFile → ImagePreviewModeWidget',
        (tester) async {
      final vBloc =
          _makeVideoBloc(db, VideoErrorState('oops', imageFile: _imageFile));
      final rBloc = _makeRecentVideosBloc(db);
      addTearDown(() async {
        await vBloc.close();
        await rBloc.close();
      });

      await tester.pumpWidget(_buildApp(vBloc, rBloc));
      await tester.pump();

      expect(find.byType(ImagePreviewModeWidget), findsOneWidget);
    });
  });

  // ── AppBar ─────────────────────────────────────────────────────────────────

  group('AppBar', () {
    late AppDatabase db;
    setUp(() => db = _openDb());
    tearDown(() async => db.close());

    testWidgets('shows app title "Old Fisherman"', (tester) async {
      final vBloc = _makeVideoBloc(db, VideoInitial());
      final rBloc = _makeRecentVideosBloc(db);
      addTearDown(() async {
        await vBloc.close();
        await rBloc.close();
      });

      await tester.pumpWidget(_buildApp(vBloc, rBloc));
      await tester.pump();

      expect(find.text('Old Fisherman'), findsOneWidget);
    });

    testWidgets('refresh icon NOT shown when VideoInitial', (tester) async {
      final vBloc = _makeVideoBloc(db, VideoInitial());
      final rBloc = _makeRecentVideosBloc(db);
      addTearDown(() async {
        await vBloc.close();
        await rBloc.close();
      });

      await tester.pumpWidget(_buildApp(vBloc, rBloc));
      await tester.pump();

      expect(find.byIcon(Icons.refresh), findsNothing);
    });

    testWidgets('refresh icon NOT shown when VideoLoadingState', (tester) async {
      final vBloc =
          _makeVideoBloc(db, VideoLoadingState(_imageFile, 'Generating...'));
      final rBloc = _makeRecentVideosBloc(db);
      addTearDown(() async {
        await vBloc.close();
        await rBloc.close();
      });

      await tester.pumpWidget(_buildApp(vBloc, rBloc));
      await tester.pump();

      expect(find.byIcon(Icons.refresh), findsNothing);
    });

    testWidgets('refresh icon shown when ImagePickedState', (tester) async {
      final vBloc = _makeVideoBloc(db, ImagePickedState(_imageFile));
      final rBloc = _makeRecentVideosBloc(db);
      addTearDown(() async {
        await vBloc.close();
        await rBloc.close();
      });

      await tester.pumpWidget(_buildApp(vBloc, rBloc));
      await tester.pump();

      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('refresh icon shown when VideoGeneratedState', (tester) async {
      final vBloc =
          _makeVideoBloc(db, VideoGeneratedState(_imageFile, '/tmp/out.mp4'));
      final rBloc = _makeRecentVideosBloc(db);
      addTearDown(() async {
        await vBloc.close();
        await rBloc.close();
      });

      await tester.pumpWidget(_buildApp(vBloc, rBloc));
      await tester.pump();

      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('refresh icon shown when VideoErrorState', (tester) async {
      final vBloc = _makeVideoBloc(db, VideoErrorState('err'));
      final rBloc = _makeRecentVideosBloc(db);
      addTearDown(() async {
        await vBloc.close();
        await rBloc.close();
      });

      await tester.pumpWidget(_buildApp(vBloc, rBloc));
      await tester.pump();

      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });
  });

  // ── BlocListener: error snackbar ───────────────────────────────────────────

  group('BlocListener — VideoErrorState snackbar', () {
    late AppDatabase db;
    setUp(() => db = _openDb());
    tearDown(() async => db.close());

    testWidgets(
        'shows snackbar with error message on VideoErrorState transition',
        (tester) async {
      final vBloc = _makeVideoBloc(db, VideoInitial());
      final rBloc = _makeRecentVideosBloc(db);
      addTearDown(() async {
        await vBloc.close();
        await rBloc.close();
      });

      await tester.pumpWidget(_buildApp(vBloc, rBloc));
      await tester.pump();

      // Trigger a state transition — BlocListener fires and shows snackbar.
      vBloc.emit(VideoErrorState('Network error'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Network error'), findsOneWidget);
    });

    testWidgets(
        'snackbar NOT shown for initial VideoErrorState '
        '(BlocListener only fires on transitions, not initial state)',
        (tester) async {
      final vBloc =
          _makeVideoBloc(db, VideoErrorState('initial error'));
      final rBloc = _makeRecentVideosBloc(db);
      addTearDown(() async {
        await vBloc.close();
        await rBloc.close();
      });

      await tester.pumpWidget(_buildApp(vBloc, rBloc));
      await tester.pump();

      // No transition since pumpWidget — listener did not fire.
      expect(find.text('initial error'), findsNothing);
    });
  });

  // ── BlocListener: RecentVideos refresh on video generated ─────────────────

  group('BlocListener — RecentVideosBloc refresh when video generated', () {
    late AppDatabase db;
    setUp(() => db = _openDb());
    tearDown(() async => db.close());

    testWidgets(
        'dispatches LoadRecentVideosEvent when VideoGeneratedState is emitted',
        (tester) async {
      final vBloc = _makeVideoBloc(db, VideoInitial());
      final rBloc = _makeRecentVideosBloc(db);
      addTearDown(() async {
        await vBloc.close();
        await rBloc.close();
      });

      await tester.pumpWidget(_buildApp(vBloc, rBloc));
      await tester.pump();

      // Emitting VideoGeneratedState triggers LoadRecentVideosEvent via listener.
      vBloc.emit(VideoGeneratedState(_imageFile, '/tmp/out.mp4'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // RecentVideosBloc should now be in Loaded state (empty db → empty list).
      expect(rBloc.state, isA<RecentVideosLoaded>());
    });
  });

  // ── RecentVideosWidget ─────────────────────────────────────────────────────

  group('RecentVideosWidget (embedded in CreateModeWidget)', () {
    late AppDatabase db;
    setUp(() => db = _openDb());
    tearDown(() async => db.close());

    testWidgets('shows "RECENT VIDEOS" section label', (tester) async {
      final vBloc = _makeVideoBloc(db, VideoInitial());
      final rBloc = _makeRecentVideosBloc(db);
      addTearDown(() async {
        await vBloc.close();
        await rBloc.close();
      });

      await tester.pumpWidget(_buildApp(vBloc, rBloc));
      await tester.pump();

      expect(find.text('RECENT VIDEOS'), findsOneWidget);
    });

    testWidgets(
        'shows loading spinner while RecentVideosBloc is in initial state',
        (tester) async {
      final vBloc = _makeVideoBloc(db, VideoInitial());
      final rBloc = _makeRecentVideosBloc(db);
      addTearDown(() async {
        await vBloc.close();
        await rBloc.close();
      });

      await tester.pumpWidget(_buildApp(vBloc, rBloc));
      await tester.pump();

      // RecentVideosBloc starts in RecentVideosInitial → _buildLoading() shows spinner.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'shows "No videos yet" after LoadRecentVideosEvent returns empty list',
        (tester) async {
      final vBloc = _makeVideoBloc(db, VideoInitial());
      final rBloc = _makeRecentVideosBloc(db);
      addTearDown(() async {
        await vBloc.close();
        await rBloc.close();
      });

      await tester.pumpWidget(_buildApp(vBloc, rBloc));
      await tester.pump();

      // Trigger load against the empty in-memory database.
      rBloc.add(LoadRecentVideosEvent());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('No videos yet'), findsOneWidget);
    });
  });

  // ── Back button behavior ───────────────────────────────────────────────────

  group('Back button behavior', () {
    late AppDatabase db;
    setUp(() => db = _openDb());
    tearDown(() async => db.close());

    testWidgets(
        'first back press shows "Press back again to exit" snackbar',
        (tester) async {
      final vBloc = _makeVideoBloc(db, VideoInitial());
      final rBloc = _makeRecentVideosBloc(db);
      addTearDown(() async {
        await vBloc.close();
        await rBloc.close();
      });

      await tester.pumpWidget(_buildApp(vBloc, rBloc));
      await tester.pump();

      // Simulate the Android hardware back button.
      await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
        'flutter/navigation',
        const JSONMethodCodec()
            .encodeMethodCall(const MethodCall('popRoute')),
        (_) {},
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Press back again to exit'), findsOneWidget);
    });
  });
}
