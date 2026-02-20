# Fisherman Video Concept App

## Project
Flutter app that generates stylized motion videos from photos using FFmpeg.

## Key Commands
- Run: `fvm flutter run`
- Pub get: `fvm flutter pub get`
- Analyze: `fvm flutter analyze`
- Push: `git push git@github.com:arahimli/fisherman-video-concept-app.git <branch>`

## Architecture
- **State management**: flutter_bloc
- **Database**: Drift/SQLite (`lib/data/database/app_database.dart`)
- **DI**: get_it (`lib/core/di/service_locator.dart`)
- **Routing**: go_router (`lib/core/router/app_router.dart` + `app_routes.dart`)
- **Design system**: `lib/core/design/design_system.dart` (barrel export)

## Routes (AppRoutes)
- `/` → NewHomePage
- `/history` → HistoryPage
- `/video-preview` → VideoPreviewScreen (videoPath via `extra`)

## Design System (`lib/core/design/`)
- `AppColors` — all const hex colors
- `AppSpacing` — xs/sm/md/lg/xl/xxl/xxxl
- `AppRadius` — values + BorderRadius helpers (smAll, lgAll, topXl…)
- `AppTextStyles` — named const TextStyles
- `AppShadows` — const BoxShadow lists

## Preferences
- Use `fvm flutter` not `flutter`
- Use SSH for git push: `git push git@github.com:arahimli/...`
- No `gh` CLI (not authenticated); create PRs manually on GitHub
