# Log Analyzer Flutter

[![Flutter](https://img.shields.io/badge/Flutter-3.24-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.7-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20macOS%20%7C%20Linux%20%7C%20Web-lightgrey?style=for-the-badge)](/)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

A modern, **offline-first** log file analyzer for Windows and macOS Desktop (with support for Web and Linux), built with Flutter using **Clean Architecture** and **MVVM**.

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 📁 **Drag & Drop Upload** | Seamless log file upload (.log, .txt) with drag-and-drop support |
| 🔍 **Full-Text Search** | Instantly search across all log entries |
| 🏷️ **Smart Categorization** | Automatic categorization: Error, Warning, Success/Info |
| 📅 **Date/Time Filtering** | Custom calendar and time picker for range filtering |
| 📊 **Dashboard Analytics** | Real-time stats and summaries at a glance |
| 🔄 **Duplicate Detection** | Smart detection with user-friendly dialogs |
| ⚡ **Offline-First** | Works without internet connection |
| 🌙 **Dark UI** | Pixel-perfect dark theme design |

---

## 🏗️ Architecture

This project follows **Clean Architecture** principles with **MVVM** pattern for clear separation of concerns and maintainability.

```
┌─────────────────────────────────────────────────────────────┐
│                     Presentation Layer                       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Widgets   │  │   Pages     │  │   State (Riverpod)  │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
├─────────────────────────────────────────────────────────────┤
│                      Domain Layer                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │  Entities   │  │ Repositories│  │     Use Cases       │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
├─────────────────────────────────────────────────────────────┤
│                       Data Layer                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Models    │  │Data Sources │  │  Repository Impl    │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

## 🛠️ Tech Stack

| Category | Technology |
|----------|------------|
| **Framework** | Flutter 3.24+ |
| **Language** | Dart 3.7+ |
| **State Management** | Riverpod |
| **Routing** | Go Router (Navigator 2.0) |
| **File Handling** | File Picker, Desktop Drop |
| **Storage** | Shared Preferences |
| **UI Components** | Syncfusion DatePicker, Lucide Icons |

---

## 📁 Project Structure

```
lib/
├── app.dart                    # Root application widget
├── main.dart                   # Entry point
├── core/                       # Shared utilities
│   ├── constants/              # App-wide constants
│   └── theme/                  # Theme configuration
│       ├── app_colors.dart
│       ├── app_text_styles.dart
│       └── app_theme.dart
├── features/                   # Feature modules
│   ├── dashboard/              # Dashboard & analytics
│   │   ├── presentation/
│   │   │   ├── pages/
│   │   │   └── widgets/
│   ├── log_upload/             # File upload feature
│   │   ├── application/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── log_view/               # Log viewing & filtering
│   │   └── presentation/
│   └── not_found/              # 404 page
└── presentation/               # Shared presentation
    ├── routes/                 # App routing
    └── widgets/                # Shared widgets
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.24+ recommended)
- Windows 10/11 or macOS 11+ for desktop build
- Web and Linux also supported

### Installation

```bash
# Clone the repository
git clone https://github.com/NaderEmad9/log_app.git

# Navigate to project directory
cd log_app

# Install dependencies
flutter pub get
```

### Running the App

```bash
# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Web
flutter run -d chrome

# Linux
flutter run -d linux
```

### Building for Production

```bash
# Windows
flutter build windows

# macOS
flutter build macos

# Web
flutter build web
```

---

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

| Test Type | Status |
|-----------|--------|
| Unit Tests | 🔜 Coming Soon |
| Widget Tests | 🔜 Coming Soon |
| Integration Tests | 🔜 Coming Soon |

---

## 📝 Notes

- This project is a Flutter port of the [log-analyzer React app](https://github.com/NaderEmad9/log-analyzer)
- All UI/UX, color palette, and features are matched as closely as possible
- Prioritizes Windows desktop support and offline-first features

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👤 Author

**Nader Emad**

[![GitHub](https://img.shields.io/badge/GitHub-NaderEmad9-181717?style=for-the-badge&logo=github)](https://github.com/NaderEmad9)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/naderemad9/)
