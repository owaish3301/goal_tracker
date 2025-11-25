# Goal Tracker - Intelligent Offline Scheduler

An offline-first, privacy-centric productivity app that uses on-device Machine Learning to automatically generate daily schedules based on user goals. Unlike standard to-do lists, this app **learns** from the user's completion habits and productivity ratings to optimize *when* tasks are scheduled, without ever sending data to the cloud.

**Core Philosophy:** Privacy + Adaptation. The app adapts to the user, not the other way around.

## 📱 Platform
- **Primary Target:** Android (Flutter)
- **Architecture:** Offline-first, privacy-focused
- **ML:** On-device pattern-based learning (pluggable for TensorFlow Lite)

## 📚 Documentation

- **[PRD.md](PRD.md)** - Complete Product Requirements Document with feature specifications
- **[DEVELOPMENT_PHASES.md](DEVELOPMENT_PHASES.md)** - Phased development roadmap (10 phases, ~7-8 weeks)
- **[DATABASE_SCHEMA.md](DATABASE_SCHEMA.md)** - Detailed database schema with Isar collections

## 🚀 Quick Start

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run all tests
flutter test
```

## 🧪 Test Coverage

```bash
# Run all tests (197 tests)
flutter test --reporter compact
```

| Test Suite | Tests |
|------------|-------|
| Core Services (HybridScheduler, ProductivityDataCollector, PatternBasedML) | 35 |
| Widget Tests (TaskCompletionModal, ScheduledTaskCard, UnifiedTimelineCard) | 58 |
| Provider Tests (scheduledTaskProviders, timelineProviders) | 25 |
| Repository Tests (Goal, Task, Milestone, OneTimeTask, UserProfile, etc.) | 52 |
| Model Tests (GoalCategory) | 27 |
| **Total** | **197** |

## 🏗️ Project Structure

```
lib/
├── core/           # Core utilities, constants, themes
├── data/           # Data layer (models, repositories, database)
├── features/       # Feature modules (goals, scheduler, timeline)
├── shared/         # Shared widgets and utilities
└── main.dart       # App entry point
```

## 🎯 Current Phase

**Phase 5: User Profile & Goal Categories** ✅ COMPLETE

- ✅ Phase 0: Project Setup & Foundation
- ✅ Phase 1: Core Data Layer  
- ✅ Phase 2: Goal Management UI
- ✅ Phase 3: One-Time Tasks
- ✅ Phase 4: ML-Powered Scheduler (138 tests)
- ✅ Phase 5: User Profile & Goal Categories (59 tests)
- ⏳ Phase 6: Onboarding Flow (Next)

See [DEVELOPMENT_PHASES.md](DEVELOPMENT_PHASES.md) for detailed roadmap.

## 🔑 Key Features

- **Smart Scheduling:** ML-powered task scheduling based on your productivity patterns
- **Goal Management:** Create macro goals with milestones and priorities
- **Adaptive Learning:** App learns when you're most productive for each goal
- **Privacy-First:** All data stays on your device, no cloud sync
- **Beautiful UI:** Dark mode with neon accents and smooth animations

## 🛠️ Tech Stack

- **Framework:** Flutter
- **Database:** Isar (high-performance local storage)
- **State Management:** Riverpod/Bloc
- **ML:** Pattern-based on-device learning (pluggable for TensorFlow Lite)
- **Navigation:** GoRouter

## 📖 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Isar Database](https://isar.dev/)
- [TensorFlow Lite](https://www.tensorflow.org/lite)
