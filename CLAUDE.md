# CLAUDE.md — Old Fisherman Video Concept App

Project-level conventions and rules for Claude Code working in this repository.

---

## Commands

Always use `fvm flutter` (never plain `flutter`):

```bash
fvm flutter pub get
fvm flutter pub run build_runner build --delete-conflicting-outputs
fvm flutter run
fvm flutter build apk --release
fvm flutter build appbundle --release
fvm flutter build ios --release
```

Git push via SSH — pass the URL directly, never use `git remote set-url`:

```bash
git push git@github.com:arahimli/fisherman-video-concept-app.git <branch>
```

Commit messages must be detailed: explain what changed and why.

---

## Architecture

- **State management:** `flutter_bloc` (VideoBloc, HistoryBloc, RecentVideosBloc)
- **DI:** `get_it` service locator — `lib/core/di/service_locator.dart`
- **Navigation:** `go_router` with named routes — `lib/core/router/app_routes.dart`
- **Database:** Drift/SQLite — `AppDatabase` in `lib/data/database/`
- **Design system:** `lib/core/design/` — exported via `design_system.dart`

Layers:
```
Presentation (pages, widgets, BLoCs) → Data (repositories, services, database) → Core (DI, router, design)
```

---

## Design System

All tokens are in `lib/core/design/`, imported via `design_system.dart` barrel export.

| File | Class | Purpose |
|------|-------|---------|
| `app_colors.dart` | `AppColors` | Color palette |
| `app_spacing.dart` | `AppSpacing` | Margin/padding scale (xs=4 … xxxl=32) |
| `app_radius.dart` | `AppRadius` | Border radius values |
| `app_text_styles.dart` | `AppTextStyles` | Typography (Georgia) |
| `app_shadows.dart` | `AppShadows` | Shadow effects |
| `app_vectors.dart` | `AppVectors` | SVG path constants |
| `app_vector_icon.dart` | `AppVectorIcon` | SVG icon widget |

### Accent color opacity constants (const hex alpha)

```
30% → Color(0x4DB8956A)
20% → Color(0x33B8956A)
15% → Color(0x26B8956A)
10% → Color(0x1AB8956A)
```

### SVG Icons

All icons are custom SVGs in `assets/vectors/`. Use `AppVectorIcon` + `AppVectors` — never use `Icon(Icons.*)` for icons that have an SVG equivalent.

```dart
// Correct
AppVectorIcon(AppVectors.delete, color: AppColors.error, size: 22)

// Wrong
Icon(Icons.delete_outline, color: AppColors.error, size: 22)
```

Available: `camera`, `check`, `checkCircle`, `delete`, `globe`, `heart`, `heartHandDonate`, `home`, `image`, `photoPlus`, `play`, `playCircle`, `plus`, `refresh`, `save`, `settings`, `share`, `video`, `videoAds`.

---

## Localization

- 4 locales: `az`, `en`, `ru`, `tr`
- Manual Dart files in `lib/l10n/` — **not** code-generated from ARB
- ARB files are the source of truth for translations

### Adding a new string key

1. Add to all four ARB files (`app_{en,az,ru,tr}.arb`)
2. Add abstract getter/method to `app_localizations.dart`
3. Add `@override` implementation in all four `app_localizations_*.dart` files

### Parameterized keys

Use `Object` (not `String`) for parameter types in the abstract class:

```dart
// abstract
String error(Object error);
String shareError(Object error);
```

### BuildContext extension

Use `context.l10n` (via `AppLocalizationsX` extension) instead of `AppLocalizations.of(context)!`.

---

## Database

Drift schema is code-generated. After any schema change:

```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

Never edit `app_database.g.dart` manually.

---

## Dependencies

`google_mobile_ads` is currently commented out in `pubspec.yaml` — do not uncomment unless explicitly asked (reserved for the next release).