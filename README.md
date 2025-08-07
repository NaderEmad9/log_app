# Log Analyzer Flutter

A modern, offline-first log file analyzer for Windows and macOS Desktop (with support for Web and Linux), built with Flutter using Clean Architecture and MVVM.

## Features
- Drag & drop log file upload (.log, .txt)
- Full-text search across logs
- Categorization: Error, Warning, Success/Info
- Date/time range filtering with custom calendar and time picker
- Dashboard with stats and summaries
- Duplicate file detection and user-friendly dialogs
- Fast, offline-first
- Modular, customizable UI components
- Pixel-perfect dark UI

## Architecture
- Clean Architecture + MVVM
- Riverpod for state management
- Navigator 2.0 for routing

## Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.10+ recommended)
- Windows 10/11 or macOS 11+ for desktop build (Web, Linux also supported)

### Installation
```sh
flutter pub get
```

### Running on Windows Desktop
```sh
flutter run -d windows
```

### Running on macOS Desktop
```sh
flutter run -d macos
```

### Running on Web
```sh
flutter run -d chrome
```

### Building Release (Windows)
```sh
flutter build windows
```

### Building Release (macOS)
```sh
flutter build macos
```

## Folder Structure
- `lib/`
  - `core/` (shared logic, themes, utils)
  - `features/` (feature modules: log_upload, search, dashboard, etc.)
  - `presentation/` (UI, widgets, screens)
  - `data/` (data sources, models)
  - `domain/` (entities, repositories, use cases)
  - `app.dart` (root app)

## Assets
- Place all images, icons, and fonts in the `assets/` directory.

## Notes
- This project is a Flutter port of the [log-analyzer React app](https://github.com/NaderEmad9/log-analyzer).
- All UI/UX, color palette, and features are matched as closely as possible.

## License
MIT

## Author
- [Nader Emad](https://github.com/NaderEmad9)
