# Ascend - Intelligent Goal & Habit Tracker

An offline-first, privacy-centric productivity app that uses on-device Machine Learning to automatically generate daily schedules based on user goals. Unlike standard to-do lists, this app **learns** from your completion habits and productivity ratings to optimize *when* tasks are scheduled.

**Core Philosophy:** Privacy + Adaptation. The app adapts to you, not the other way around.

## 📱 Download

[![GitHub Release](https://img.shields.io/github/v/release/owaish3301/goal_tracker?style=for-the-badge)](https://github.com/owaish3301/goal_tracker/releases/latest)

Download the latest APK from [GitHub Releases](https://github.com/owaish3301/goal_tracker/releases/latest):
- **arm64-v8a** - Most modern Android phones (~28MB)
- **armeabi-v7a** - Older Android phones (~26MB)
- **Universal** - Works on all devices (~65MB)

**In-App Updates:** The app automatically checks for updates and notifies you when a new version is available!

## ✨ Features

### 🎯 Goal Management
- Create macro goals with milestones and priorities
- Track progress with visual indicators
- Drag-and-drop reordering for priority management
- Streak tracking to maintain momentum

### 📅 Smart Scheduling
- ML-powered task scheduling based on your productivity patterns
- Learns when you're most productive for each type of goal
- Dynamic time windows that adapt to your sleep/wake patterns
- Automatic schedule regeneration at midnight

### 📊 Analytics Dashboard
- Productivity trends and insights
- Goal completion statistics
- Streak tracking and best streaks
- Performance analytics

### 🗓️ Calendar View
- Monthly and weekly views
- See scheduled tasks at a glance
- One-time task management

### 🔒 Privacy-First
- All data stays on your device
- No cloud sync, no data collection
- Full offline functionality

## 🚀 Quick Start

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Build release APK
flutter build apk --release --split-per-abi

# Run all tests
flutter test
```

## 🧪 Test Coverage

```bash
# Run all tests (391 tests)
flutter test --reporter compact
```

| Test Suite | Tests |
|------------|-------|
| Core Services (Scheduler, ML, Productivity) | 85+ |
| Widget Tests | 60+ |
| Provider Tests | 30+ |
| Repository Tests | 55+ |
| Integration Tests | 40+ |
| Sleep/Wake Tracking | 30+ |
| **Total** | **391** |

## 🏗️ Project Structure

```
lib/
├── core/           # Core services, theme, router, widgets
│   ├── services/   # App update, database, background scheduling
│   ├── theme/      # Dark theme with neon accents
│   ├── router/     # GoRouter navigation
│   └── widgets/    # Shared widgets (update dialog, etc.)
├── data/           # Data layer
│   ├── models/     # Isar models (Goal, Task, UserProfile, etc.)
│   └── repositories/
├── features/       # Feature modules
│   ├── goals/      # Goal management UI
│   ├── timeline/   # Daily timeline view
│   ├── calendar/   # Calendar view
│   ├── analytics/  # Analytics dashboard
│   ├── settings/   # App settings
│   └── onboarding/ # First-time setup
└── main.dart
```

## 🔑 Key Features Breakdown

| Feature | Status |
|---------|--------|
| Goal Management | ✅ Complete |
| Milestone Tracking | ✅ Complete |
| Smart Scheduling | ✅ Complete |
| Pattern-Based ML | ✅ Complete |
| Calendar View | ✅ Complete |
| Analytics Dashboard | ✅ Complete |
| Sleep/Wake Tracking | ✅ Complete |
| Background Scheduling | ✅ Android |
| Notifications | ✅ Complete |
| Backup/Restore | ✅ Complete |
| In-App Updates | ✅ Complete |
| Dark Theme | ✅ Complete |

## 🛠️ Tech Stack

- **Framework:** Flutter 3.10+
- **Database:** Isar (high-performance local storage)
- **State Management:** Riverpod
- **Navigation:** GoRouter
- **ML:** Pattern-based on-device learning
- **HTTP:** Dio (for update checking)
- **Signing:** Release builds with custom keystore

## 📋 Building from Source

### Prerequisites
- Flutter SDK 3.10+
- Android Studio / VS Code
- Java 17+ (for Android builds)

### Release Build
```bash
# Build split APKs (recommended)
flutter build apk --release --split-per-abi

# Build universal APK
flutter build apk --release
```

### Setting up Signing (for your own builds)
1. Generate a keystore:
   ```bash
   keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. Create `android/key.properties`:
   ```properties
   storePassword=your_password
   keyPassword=your_password
   keyAlias=upload
   storeFile=../upload-keystore.jks
   ```

## 📖 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Isar Database](https://isar.dev/)
- [Riverpod](https://riverpod.dev/)

## 📄 License

This project is for personal use. All rights reserved.
