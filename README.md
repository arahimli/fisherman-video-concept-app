# Old Fisherman — Video Concept App

A Flutter mobile application that transforms static images into artistic, animated videos with multi-language narration.

## What It Does

The app takes a single photo and generates a 30-second cinematic video by applying mirror/symmetry effects to create multiple image variants, then compositing them into a video with pre-recorded narration audio.

**Video generation pipeline:**
1. User selects an image from gallery or camera
2. App generates 5 image variants (original + left/right mirror symmetry + left/right half-black overlay)
3. FFmpeg composes the variants into a 30-second MP4 (1080×1920, h264/AAC)
4. Optional watermark overlay is applied
5. User previews, saves to gallery, and shares

## Features

- **8 narration languages**: English, Turkish, Russian, French, Arabic, Chinese, Spanish, Hindi
- **Watermark system**: Optional image watermark with 4 corner positions
- **Video history**: Browse past videos with date and language filters
- **Gallery & sharing**: Save to device, share via WhatsApp/Telegram/etc.
- **Settings**: Watermark configuration, position selection
- **Remote config**: Firebase Remote Config for feature flags and app updates
- **UI languages**: Azerbaijani, English, Russian, Turkish

## Tech Stack

| Category | Library |
|----------|---------|
| Framework | Flutter (FVM-managed) |
| State management | flutter_bloc |
| Dependency injection | get_it |
| Navigation | go_router |
| Database | Drift (SQLite ORM) |
| Image processing | image package (background isolate) |
| Video generation | ffmpeg_kit_flutter_new |
| Video playback | video_player + chewie |
| SVG icons | flutter_svg |
| Firebase | firebase_core, firebase_remote_config |
| Storage | shared_preferences, saver_gallery |
| Sharing | share_plus |
| App info | package_info_plus, url_launcher |

> **Note:** `google_mobile_ads` is currently commented out in `pubspec.yaml` and will be re-enabled in the next release.

## Project Structure

```
lib/
├── main.dart
├── core/
│   ├── ads/           # AdMob configuration
│   ├── design/        # Design system (colors, spacing, typography, shadows, vectors)
│   ├── di/            # Service locator setup
│   └── router/        # go_router routes
├── data/
│   ├── database/      # Drift/SQLite schema and DAOs
│   ├── models/        # Data models
│   ├── repositories/  # Repository layer
│   └── services/      # ImageService, VideoService, SettingsService
├── presentation/
│   ├── managers/      # BLoCs: VideoBloc, HistoryBloc, RecentVideosBloc
│   ├── pages/         # Full-screen pages
│   └── widgets/       # Reusable UI components
└── l10n/              # Localization (az, en, ru, tr)

assets/
├── images/            # App images and splash assets
├── vectors/           # SVG icon files (19 icons)
└── voices/            # Narration audio tracks
```

## Architecture

The app follows Clean Architecture with BLoC pattern for state management:

- **VideoBloc** — manages the video generation workflow (image selection → processing → encoding → preview)
- **HistoryBloc** — manages video history with filtering
- **RecentVideosBloc** — manages the home page recent videos list

Dependency injection is handled via `get_it` service locator, configured in `lib/core/di/service_locator.dart`.

## Getting Started

### Prerequisites

- Flutter SDK (use `fvm` for version management)
- Android Studio / Xcode for device targets
- `fvm` installed globally

### Setup

```bash
# Install dependencies
fvm flutter pub get

# Generate Drift database code
fvm flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
fvm flutter run
```

### Localization

Translations are manually maintained in `lib/l10n/`. Adding a new string requires:

1. Adding the key to the relevant `.arb` file
2. Adding the abstract method to `app_localizations.dart`
3. Implementing the method in all 4 locale files (`app_localizations_az.dart`, `_en.dart`, `_ru.dart`, `_tr.dart`)

## Design System

The app uses a dark theme centered on a brown/tan accent color (`#B8956A`). All design tokens live in `lib/core/design/` and are exported via `design_system.dart`.

- `AppColors` — color palette with opacity variants
- `AppSpacing` — margin/padding scale
- `AppRadius` — border radius values
- `AppTextStyles` — typography (Georgia font family)
- `AppShadows` — shadow effects
- `AppVectors` — SVG asset path constants (`assets/vectors/`)
- `AppVectorIcon` — reusable SVG icon widget (wraps `flutter_svg`)

### SVG Icons

All icons are custom SVGs in `assets/vectors/`. Use `AppVectorIcon` with a path from `AppVectors` instead of `Icon(Icons.*)`:

```dart
// Instead of: Icon(Icons.delete_outline, color: AppColors.error, size: 22)
AppVectorIcon(AppVectors.delete, color: AppColors.error, size: 22)
```

Available vectors: `camera`, `check`, `checkCircle`, `delete`, `globe`, `heart`, `heartHandDonate`, `home`, `image`, `photoPlus`, `play`, `playCircle`, `plus`, `refresh`, `save`, `settings`, `share`, `video`, `videoAds`.

## Screens

| Route | Screen |
|-------|--------|
| `/` | Animated splash screen |
| `/home` | Main creation interface |
| `/history` | Video history with filters |
| `/video-preview` | Full-screen video preview |
| `/settings` | Watermark & app settings |
| `/support` | Ad support page |