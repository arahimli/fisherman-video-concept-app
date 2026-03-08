# Old Fisherman — Technical Documentation

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Architecture](#2-architecture)
3. [Directory Structure](#3-directory-structure)
4. [Core Infrastructure](#4-core-infrastructure)
5. [Design System](#5-design-system)
6. [Data Layer](#6-data-layer)
7. [State Management (BLoC)](#7-state-management-bloc)
8. [Pages](#8-pages)
9. [Widgets](#9-widgets)
10. [Services](#10-services)
11. [Localization](#11-localization)
12. [Image Processing Algorithm](#12-image-processing-algorithm)
13. [Video Generation Algorithm](#13-video-generation-algorithm)
14. [Monetization](#14-monetization)
15. [Dependencies](#15-dependencies)

---

## 1. Project Overview

**App name:** Old Fisherman
**Package:** `fisherman_video`
**Platforms:** Android, iOS
**Dart SDK:** `^3.9.2`
**Flutter:** FVM-managed

The app transforms a single still photo into a 30-second vertical (1080×1920) motion video using symmetry effects and FFmpeg encoding. A background music track is mixed in automatically. Users can customize a watermark overlay, browse their video history, and support the app by watching ads.

---

## 2. Architecture

The project follows **Clean Architecture** layered into three zones:

```
Presentation  →  Domain (implicit in BLoCs)  →  Data
```

| Layer        | What lives here |
|--------------|----------------|
| Presentation | Pages, Widgets, BLoCs, Events, States |
| Data         | Repositories, Services, Database, Models |
| Core         | DI, Router, Design System |

**State management:** `flutter_bloc` (BLoC pattern)
**Dependency injection:** `get_it` service locator
**Navigation:** `go_router` with named routes
**Database:** `drift` (type-safe SQLite ORM)
**Settings persistence:** `shared_preferences`

---

## 3. Directory Structure

```
lib/
├── main.dart
├── core/
│   ├── design/
│   │   ├── app_colors.dart
│   │   ├── app_radius.dart
│   │   ├── app_shadows.dart
│   │   ├── app_spacing.dart
│   │   ├── app_text_styles.dart
│   │   └── design_system.dart          # barrel export
│   ├── di/
│   │   └── service_locator.dart
│   └── router/
│       ├── app_routes.dart
│       └── app_router.dart
├── data/
│   ├── database/
│   │   ├── app_database.dart
│   │   └── app_database.g.dart         # generated
│   ├── repositories/
│   │   └── video_history_repository.dart
│   └── services/
│       ├── image_service.dart
│       ├── settings_service.dart
│       └── video_service.dart
├── presentation/
│   ├── managers/
│   │   ├── video_bloc/
│   │   │   ├── video_bloc.dart
│   │   │   ├── video_event.dart
│   │   │   └── video_state.dart
│   │   ├── history_bloc/
│   │   │   ├── history_bloc.dart
│   │   │   ├── history_event.dart
│   │   │   └── history_state.dart
│   │   └── recent_videos_bloc/
│   │       ├── recent_videos_bloc.dart
│   │       ├── recent_videos_event.dart
│   │       └── recent_videos_state.dart
│   ├── pages/
│   │   ├── splash_page.dart
│   │   ├── home_page.dart
│   │   ├── history_page.dart
│   │   ├── video_preview_page.dart
│   │   ├── settings_page.dart
│   │   └── support_page.dart
│   └── widgets/
│       ├── home/
│       ├── history/
│       ├── video_preview/
│       ├── settings/
│       └── splash/
└── l10n/
    ├── app_localizations.dart
    ├── app_localizations_en.dart
    ├── app_localizations_az.dart
    ├── app_localizations_ru.dart
    └── app_localizations_tr.dart
```

---

## 4. Core Infrastructure

### 4.1 Entry Point — `main.dart`

Startup sequence:
1. `WidgetsFlutterBinding.ensureInitialized()`
2. `MobileAds.instance.initialize()` — Google ads SDK
3. `setupServiceLocator()` — registers all GetIt dependencies
4. Wraps app root with `MultiBlocProvider` providing `VideoBloc` and `RecentVideosBloc`
5. `RecentVideosBloc` dispatches `LoadRecentVideosEvent` immediately on startup

App config:
- `MaterialApp` with `GoRouter`
- `ThemeData` dark background `#0A0A0A`, font family **Georgia**
- `localizationsDelegates` includes the custom `AppLocalizations.delegate`
- Supported locales: `az`, `en`, `ru`, `tr`

### 4.2 Dependency Injection — `service_locator.dart`

Uses `get_it` singleton (`sl = GetIt.instance`).

| Registration | Type | Class |
|---|---|---|
| `AppDatabase` | Singleton | Drift database |
| `VideoHistoryRepository` | Singleton | Wraps `AppDatabase` |
| `VideoBloc` | Factory | New instance per access |
| `HistoryBloc` | Factory | New instance per access |
| `RecentVideosBloc` | Factory | New instance per access |

BLoCs are registered as factories so each route gets a fresh BLoC without stale state.

### 4.3 Navigation — `app_router.dart` / `app_routes.dart`

| Route constant | Path | Page |
|---|---|---|
| `AppRoutes.splash` | `/` | `SplashPage` |
| `AppRoutes.home` | `/home` | `NewHomePage` |
| `AppRoutes.history` | `/history` | `HistoryPage` |
| `AppRoutes.videoPreview` | `/video-preview` | `VideoPreviewPage` |
| `AppRoutes.settings` | `/settings` | `SettingsPage` |
| `AppRoutes.support` | `/support` | `SupportPage` |

`VideoPreviewPage` receives `videoPath` via `GoRouterState.extra` (not a query param).
`HistoryBloc` is injected into `BlocProvider` when entering `/home` or `/history`.

---

## 5. Design System

All tokens live in `lib/core/design/` and are exported via `design_system.dart`.

### 5.1 Colors — `AppColors`

```dart
// Backgrounds
background        #0A0A0A   // page background
surface           #1A1A1A   // cards, bottom sheets
surfaceElevated   #2A2A2A
surfaceHighest    #3A3A3A

// Accent (warm tan)
accent            #B8956A
accentStrong      #E6B84D   // golden highlight
accentBorder      0x4D B8956A  // 30 % opacity
accentBorderLight 0x33 B8956A  // 20 %
accentBorderFaint 0x26 B8956A  // 15 %
accentOverlay     0x1A B8956A  // 10 % — icon backgrounds

// Text (all on dark background)
textPrimary    white
textSecondary  white 70 %
textTertiary   white 54 %
textDisabled   white 38 %
textHint       white 24 %
```

### 5.2 Spacing — `AppSpacing`

```
xs=4  sm=8  md=12  lg=16  xl=20  xxl=24  xxxl=32
```

### 5.3 Border Radius — `AppRadius`

```
xs=4  sm=8  md=12  lg=16  xl=20  pill=50
```

Convenience helpers: `AppRadius.lgAll` → `BorderRadius.circular(16)`, `AppRadius.topLg` → top-only radius for bottom sheets.

### 5.4 Text Styles — `AppTextStyles`

| Style | Size | Weight | Notes |
|---|---|---|---|
| `appBarTitle` | 18 | light | italic, Georgia, 2 px letter-spacing |
| `createLabel` | 11 | normal | uppercase, 3 px letter-spacing |
| `historyCardTitle` | 12 | medium | card labels |
| `historyCardDate` | 10 | normal | `textTertiary` |
| `emptyStateTitle` | 18 | light | empty screens |
| `sectionLabel` | 11 | normal | subtle section headers |
| `filterChip` | 12 | medium | date filter chips |

### 5.5 Shadows — `AppShadows`

| Shadow | Use |
|---|---|
| `accentGlow` | accent 30 %, blur 40, spread 5 — prominent glow |
| `accentSubtle` | accent 20 %, blur 30, spread 5 — subtle glow |
| `bottomSheet` | grey 20 %, blur 10, offset (0, −3) |

---

## 6. Data Layer

### 6.1 Database — `AppDatabase` (Drift)

File location: `getApplicationDocumentsDirectory() / video_history.sqlite`
Schema version: 1

**Table: `VideoHistory`**

| Column | Type | Notes |
|---|---|---|
| `id` | `int` | auto-increment PK |
| `videoPath` | `text` | path to generated MP4 |
| `thumbnailPath` | `text?` | optional thumbnail |
| `imagePath` | `text?` | source image path |
| `createdAt` | `dateTime` | creation timestamp |
| `title` | `text` | e.g. `MOTION_20240223_143022` |

**Database operations (defined directly on `AppDatabase`):**

```dart
Future<int>                createVideo(VideoHistoryCompanion)
Future<List<VideoHistoryData>> getAllVideos({limit?, offset?, startDate?, endDate?})
Future<int>                getVideoCount({startDate?, endDate?})
Stream<List<VideoHistoryData>> watchAllVideos({limit?, offset?, startDate?, endDate?})
Future<int>                deleteVideo(int id)
Future<bool>               updateVideo(VideoHistoryData)
```

### 6.2 Repository — `VideoHistoryRepository`

Thin wrapper that adds higher-level convenience methods on top of `AppDatabase`.

**Key methods:**

```dart
// CRUD
Future<int>  createVideo({videoPath, thumbnailPath, imagePath, title})
Future<int>  deleteVideo(int id)
Future<bool> updateVideo(VideoHistoryData)

// Queries
Future<List<VideoHistoryData>> getAllVideos({limit?, offset?, startDate?, endDate?})
Future<List<VideoHistoryData>> getRecentVideos({limit: 10})
Future<List<VideoHistoryData>> searchVideosByTitle(String query)

// Date presets
Future<List<VideoHistoryData>> getTodayVideos()
Future<List<VideoHistoryData>> getYesterdayVideos()
Future<List<VideoHistoryData>> getThisWeekVideos()
Future<List<VideoHistoryData>> getThisMonthVideos()

// Reactive streams
Stream<List<VideoHistoryData>> watchAllVideos({...})
Stream<List<VideoHistoryData>> watchRecentVideos({limit: 10})

// Aggregate
Future<Map<String, dynamic>> getStatistics()
// → { total, today, thisWeek, thisMonth }

// Maintenance
Future<int> deleteOldVideos({required int days})
```

---

## 7. State Management (BLoC)

### 7.1 VideoBloc

Controls the full image-to-video creation workflow on the home page.

**States:**

```
VideoInitial
ImagePickedState(File image)
VideoLoadingState(File image, String message)
VideoGeneratedState(File image, String videoPath)
VideoErrorState(String message, File? image)
```

**Events → Handler summary:**

| Event | Handler |
|---|---|
| `PickImageEvent(ImageSource)` | Opens picker; emits `ImagePickedState` or `VideoErrorState` |
| `GenerateVideoEvent` | Processes image in isolate → generates video via FFmpeg → saves to DB |
| `ResetEvent` | Emits `VideoInitial` |

`GenerateVideoEvent` flow:
```
emit VideoLoadingState("Processing image...")
  → ImageService.processImage(file)       // Isolate
emit VideoLoadingState("Generating video...")
  → SettingsService.getWatermarkSettings()
  → VideoService.generateVideo(images, watermark)
  → AppDatabase.createVideo(...)
emit VideoGeneratedState / VideoErrorState
```

### 7.2 HistoryBloc

Manages the paginated, filterable video history list.

**States:**

```
HistoryInitial
HistoryLoading
HistoryLoaded(
  videos: List<VideoHistoryData>,
  hasMore: bool,
  currentPage: int,
  startDate?: DateTime,
  endDate?: DateTime,
)
HistoryError(message: String)
```

**Events → Handler summary:**

| Event | Handler |
|---|---|
| `LoadHistoryEvent(startDate?, endDate?, loadMore)` | Load first page or append next page (10 per page) |
| `DeleteVideoEvent(int videoId)` | Delete from DB; remove from current list in state |
| `FilterByDateEvent(startDate?, endDate?)` | Delegates to `LoadHistoryEvent` with new date range |

Pagination: `offset = currentPage * 10`, appends results when `loadMore: true`.

### 7.3 RecentVideosBloc

Lightweight BLoC that loads and caches the 10 most recent videos for the home page carousel.

**Events:** `LoadRecentVideosEvent`
**States:** `RecentVideosInitial | RecentVideosLoading | RecentVideosLoaded(videos) | RecentVideosError`

Dispatched once in `main.dart` during startup.

---

## 8. Pages

### 8.1 SplashPage

Animated intro screen. Uses a `CustomPaint` concrete-wall texture background.

Timeline (4 500 ms):

| Phase | Duration | Animation |
|---|---|---|
| Entry | 38 % | Logo scales `0.70 → 1.0`, fades in |
| Hold | 24 % | No change |
| Exit | 38 % | Logo scales `1.0 → 1.6`, fades out |

On animation complete → `context.go(AppRoutes.home)`.

### 8.2 HomePage (`NewHomePage`)

Main creation screen. Renders one of four child widgets based on `VideoBloc` state:

| BLoC State | Widget shown |
|---|---|
| `VideoInitial` | `CreateModeWidget` |
| `ImagePickedState`, `VideoErrorState` | `ImagePreviewModeWidget` |
| `VideoLoadingState` | `LoadingStateWidget` |
| `VideoGeneratedState` | `VideoReadyModeWidget` |

AppBar icons: support (heart) and settings (gear).

Double-back-press-to-exit: a 2-second window between two back presses shows a snackbar then exits. On `ImagePickedState` or `VideoGeneratedState`, a single back press shows a confirmation dialog to return to select-image mode.

BLoC listener: on `VideoGeneratedState` → fires `LoadRecentVideosEvent` so the carousel refreshes immediately.

### 8.3 HistoryPage

Full video history with filter chips and infinite scroll.

- Chips: All / Today / Yesterday / This Week / This Month
- Grid: `SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75)`
- Pagination: triggers `LoadHistoryEvent(loadMore: true)` when scroll position ≥ 90 % of max
- Long-press card → options sheet (delete, details)
- Tap card → `context.push(AppRoutes.videoPreview, extra: videoPath)`

### 8.4 VideoPreviewPage

Full-screen video player using **Chewie** on top of `VideoPlayerController`.

- Auto-plays on init, loops
- Custom accent-colored progress indicator
- Replay overlay when playback position ≥ 95 %
- "Save" → `SaverGallery.saveFile` with filename `fisherman_video_{timestamp}`
- "Share" → `Share.shareXFiles` via `share_plus`
- Receives `videoPath` from `GoRouterState.extra`

### 8.5 SettingsPage

Watermark configuration. Reads settings via `SettingsService` on `initState`, persists on each change.

Controls:
- Toggle: image watermark enabled/disabled
- Image picker: select watermark PNG from gallery
- Change/Remove buttons when image is selected
- Position selector: 2×2 grid (topLeft, topRight, bottomLeft, bottomRight)
- Hint text explaining watermark behavior

### 8.6 SupportPage

Ad-watching interface with persistent view counters.

**Stat cards** (side-by-side):
- Today's count (`ads_watched_today` key, resets daily via `ads_watched_date`)
- All-time total (`ads_watched_count` key)

**Ad cards:**
- Short video → `InterstitialAd`; count increments on `onAdDismissedFullScreenContent`
- Long video → `RewardedAd`; count increments only if `onUserEarnedReward` fired before dismiss (`_rewardEarned` flag)

**Confetti:** `ConfettiController` (2 s, 30 particles, explosive) plays on every successful watch.

**SharedPreferences keys:**

| Key | Type | Description |
|---|---|---|
| `ads_watched_count` | int | All-time total |
| `ads_watched_today` | int | Count for the current calendar day |
| `ads_watched_date` | string | `YYYY-MM-DD` of last watched day |

---

## 9. Widgets

### 9.1 Home Widgets

**`CreateModeWidget`**
- `SolarSystemPainter` (CustomPaint) — orbital rings animated over 36 s with `AnimationController`
- Center pulsing circle (scale `1.0 → 1.08` over 4 s, repeat)
- Tap center → shows `HomeSheets.showImageSourceSheet`

**`LoadingStateWidget`**
- Rotating gradient ring animation
- Loading message text + `LinearProgressIndicator`
- Two `BannerAd` slots (top + bottom); ads loaded async, `setState` on load

**`VideoReadyModeWidget`**
- Source image with play icon overlay and "Video Ready" badge
- Primary CTA → navigate to `VideoPreviewPage`

**`RecentVideosWidget`**
- Horizontal `ListView.builder`
- BLoC-driven from `RecentVideosBloc`
- "View All" navigates to `/history`

### 9.2 History Widgets

**`HistoryVideoCard`**
- `Image.file` thumbnail or placeholder `Icons.videocam`
- Delete button top-right, dispatches `DeleteVideoEvent`
- Formatted timestamp using `intl`

**`HistoryFilterChips`**
- Single-select chip row; selected chip uses accent background

**`HistoryEmptyState`**
- Icon + title + description, centered

### 9.3 Video Preview Widgets

**`VideoPlayerView`**
- `ChewieController` wraps `VideoPlayerController.file`
- `CupertinoProgressColors` uses `AppColors.accent`
- `ReplayOverlay` shown when `value.position / value.duration ≥ 0.95`

**`PreviewShareSheet`**
- Bottom modal with Save row and Share row
- Save triggers `SaverGallery.saveFile`, shows success/error snackbar

### 9.4 Settings Widgets

**`WatermarkPositionSelector`**
- `GridView` 2×2, each cell is a tappable `Container` with icon
- Selected cell renders with accent border

### 9.5 Custom Painters

**`SolarSystemPainter`** — draws concentric oval orbits; three planets orbit at different speeds derived from a single `animationValue` (0–1). Used in `CreateModeWidget`.

**`ConcreteWallPainter`** — procedural noise-like texture using `Canvas.drawRect` with randomised grey tones. Used as splash background.

---

## 10. Services

### 10.1 ImageService

**File:** `lib/data/services/image_service.dart`
**Execution:** `Isolate.run` (non-blocking)

```dart
static Future<Map<String, String>> processImage(File file)
```

Steps inside the isolate:

1. Decode image bytes → `image.Image`
2. Resize to width = 1080 px (preserve aspect ratio)
3. Split canvas at `halfWidth = width ~/ 2`
4. Build five variants:

| Key | Description |
|---|---|
| `original` | Resized source |
| `left_half_black` | Left half pasted on black canvas |
| `right_half_black` | Right half pasted on black canvas |
| `left_symmetry` | Left half + horizontally-flipped left half |
| `right_symmetry` | Right half + horizontally-flipped right half |

5. Encode each as PNG, save to system temp directory
6. Return `Map<String, String>` of variant name → file path

### 10.2 VideoService

**File:** `lib/data/services/video_service.dart`

```dart
static Future<String?> generateVideo(
  Map<String, String> images, {
  WatermarkSettings? watermark,
})
```

Steps:

1. Validate all five image paths exist on disk
2. Copy `assets/music.mp3` from asset bundle to temp directory
3. Build FFmpeg command (see [Section 13](#13-video-generation-algorithm))
4. Execute via `FFmpegKit.executeAsync`
5. On success return output MP4 path; on failure return `null`

Output filename: `fisherman_{timestamp}.mp4` in temp directory.

### 10.3 SettingsService

**File:** `lib/data/services/settings_service.dart`

All values stored in `SharedPreferences`.

| Key | Type | Default |
|---|---|---|
| `watermark_image_enabled` | bool | `false` |
| `watermark_image_path` | String? | `null` |
| `watermark_position` | int (enum index) | `0` (topLeft) |

```dart
class WatermarkSettings {
  final bool imageEnabled;
  final String? imagePath;
  final WatermarkPosition position;

  bool get hasImageWatermark => imageEnabled && imagePath != null;
}

enum WatermarkPosition { topLeft, topRight, bottomLeft, bottomRight }
```

`getWatermarkSettings()` returns a snapshot of all three values at once.

---

## 11. Localization

**System:** Manual Dart implementation (not `gen-l10n` code-gen).
**Source of truth:** ARB files in `lib/l10n/`.
**Abstract class:** `AppLocalizations` (in `app_localizations.dart`)
**Implementations:** `app_localizations_{en,az,ru,tr}.dart`

Supported locales: `az`, `en`, `ru`, `tr`

### Adding a new string key

1. Add to all four ARB files (`app_{en,az,ru,tr}.arb`)
2. Add abstract getter (or method for parameterized keys) to `app_localizations.dart`
3. Add `@override` implementation to all four `app_localizations_*.dart` files

**Parameterized keys** use `Object` for the parameter type in the abstract class:

```dart
// abstract
String error(Object error);
String shareError(Object error);
String videosCount(int count);

// implementation (en)
String error(Object error) => 'Error: $error';
```

### Key categories

| Category | Example keys |
|---|---|
| Navigation / actions | `create`, `history`, `settings`, `support`, `save`, `share`, `delete`, `cancel` |
| Video workflow | `generateVideo`, `videoReady`, `videoGenerating`, `videoGenerated` |
| History / dates | `today`, `yesterday`, `thisWeek`, `thisMonth`, `allVideos`, `noVideos` |
| Watermark | `watermark`, `imageWatermark`, `watermarkPosition`, `positionTopLeft` … |
| Support / ads | `adsWatchedToday`, `adsWatchedTotal`, `watchAd`, `thankYouSupport` |
| Errors | `error`, `shareError`, `videoGenerationError` |

---

## 12. Image Processing Algorithm

Input: one `File` (any format readable by the `image` package)
Output: five PNG files on disk

```
Original (1080 × H)
│
├── left half (0 .. halfWidth)     right half (halfWidth .. width)
│         │                                │
│   + black fill                      + black fill
│         │                                │
│   left_half_black               right_half_black
│         │                                │
│   flip horizontally             flip horizontally
│         │                                │
│   paste at halfWidth            paste at 0
│         │                                │
│   left_symmetry                 right_symmetry
```

Mirror technique: `image.flipHorizontal(image.copyCrop(...))` then composited onto a blank canvas.

---

## 13. Video Generation Algorithm

FFmpeg receives **7 inputs** (6 images + 1 audio, plus optional watermark as 8th input):

```
Input 0  original          loop 1, duration 2 s
Input 1  left_half_black   loop 1, duration 3 s
Input 2  left_symmetry     loop 1, duration 10 s
Input 3  original          loop 1, duration 2 s
Input 4  right_half_black  loop 1, duration 2 s
Input 5  right_symmetry    loop 1, duration 12 s   ← longest, final frame
Input 6  music.mp3
Input 7  watermark.png     (optional)
```

Filter graph:
1. Each video input → `scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920,fps=30` → `[v0]…[v5]`
2. `[v0][v1][v2][v3][v4][v5]concat=n=6:v=1:a=0` → `[cat]`
3. If watermark: `[7:v]scale=150:150[wm]`, `[cat][wm]overlay=x:y` → `[outv]`
4. Map `[outv]` for video, `[6:a]` for audio, limit to `-t 30`

**Output encoding:**

| Parameter | Value |
|---|---|
| Video codec | `libx264` |
| Preset | `ultrafast` |
| Pixel format | `yuv420p` |
| Audio codec | `aac` |
| Audio bitrate | `128 k` |
| Resolution | `1080 × 1920` (9:16) |
| Frame rate | `30 fps` |
| Duration | `30 s` |

**Watermark positions** (overlay x/y expressions):

| Position | x | y |
|---|---|---|
| topLeft | `40` | `40` |
| topRight | `W-w-40` | `40` |
| bottomLeft | `40` | `H-h-80` |
| bottomRight | `W-w-40` | `H-h-80` |

Watermark is always scaled to 150×150 px before overlay.

---

## 14. Monetization

Uses **Google Mobile Ads SDK** (`google_mobile_ads: ^5.1.0`).

All current ad unit IDs are Google's **test IDs** and must be replaced before production release.

| Ad type | Current (test) ID — Android | Current (test) ID — iOS |
|---|---|---|
| Interstitial | `ca-app-pub-3940256099942544/1033173712` | `ca-app-pub-3940256099942544/4411468910` |
| Rewarded | `ca-app-pub-3940256099942544/5224354917` | `ca-app-pub-3940256099942544/1712485313` |
| Banner | (loaded in `LoadingStateWidget`) | |

**Ad lifecycle (SupportPage):**
- Ads are loaded in `initState` and reloaded after each show
- `InterstitialAd` → `fullScreenContentCallback.onAdDismissedFullScreenContent` → count
- `RewardedAd` → `onUserEarnedReward` sets `_rewardEarned = true`; count on dismiss only if flag is set
- Both paths call `_onAdWatched()` → increments SharedPreferences counters → plays confetti

---

## 15. Dependencies

### Runtime

| Package | Version | Purpose |
|---|---|---|
| `flutter_bloc` | `^9.1.1` | BLoC state management |
| `get_it` | `^8.0.0` | Service locator / DI |
| `go_router` | `^14.0.0` | Declarative routing |
| `drift` | `^2.14.1` | Type-safe SQLite ORM |
| `sqlite3_flutter_libs` | `^0.5.18` | SQLite native binaries |
| `shared_preferences` | `^2.3.3` | Key-value persistence |
| `image_picker` | `^1.0.4` | Gallery / camera access |
| `image` | `^4.1.7` | Dart image processing |
| `ffmpeg_kit_flutter_new` | `^4.1.0` | FFmpeg native wrapper |
| `video_player` | `^2.8.0` | Platform video playback |
| `chewie` | `^1.7.0` | Video player UI controls |
| `path_provider` | `^2.1.2` | App directory paths |
| `permission_handler` | `^11.3.0` | Runtime permissions |
| `share_plus` | `^10.0.0` | OS share sheet |
| `saver_gallery` | `^4.1.0` | Save file to device gallery |
| `google_mobile_ads` | `^5.1.0` | Google AdMob SDK |
| `confetti` | `^0.7.0` | Confetti particle animation |
| `intl` | `^0.20.2` | i18n + date formatting |
| `cupertino_icons` | `^1.0.8` | iOS-style icons |

### Dev

| Package | Version | Purpose |
|---|---|---|
| `drift_dev` | `^2.14.1` | Drift code generation |
| `build_runner` | `^2.4.6` | Code generation runner |
| `flutter_lints` | `^5.0.0` | Lint rules |
| `flutter_launcher_icons` | `^0.14.3` | App icon generation |

### Build commands

```bash
# Fetch packages
fvm flutter pub get

# Regenerate Drift code after schema changes
fvm flutter pub run build_runner build --delete-conflicting-outputs

# Run on device
fvm flutter run

# Release builds
fvm flutter build apk --release
fvm flutter build appbundle --release
fvm flutter build ios --release

# Push via SSH (project convention)
git push git@github.com:arahimli/fisherman-video-concept-app.git <branch>
```
