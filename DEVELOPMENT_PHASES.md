# Goal Tracker - Development Phases

This document outlines the phased development approach for the Goal Tracker app, breaking down the project into manageable milestones.

---

## Phase 0: Project Setup & Foundation
**Duration:** 1-2 days  
**Goal:** Set up the Flutter project with necessary dependencies and architecture

### Tasks
- [x] Initialize Flutter project
- [x] Set up project structure (features, core, shared)
- [x] Add dependencies:
  - `isar` and `isar_flutter_libs` (local database)
  - `riverpod` or `bloc` (state management)
  - `go_router` (navigation)
  - `flutter_hooks` (UI utilities)
  - `intl` (date/time formatting)
- [x] Configure Android-specific settings
- [x] Set up dark theme with Material Design 3
- [x] Create base color scheme and design tokens

### Deliverables
- ✅ Working Flutter project
- ✅ Configured theme system
- ✅ Basic navigation structure

---

## Phase 1: Core Data Layer
**Duration:** 3-4 days  
**Goal:** Build the local database schema and data models

### Tasks
- [x] Design and implement Isar schemas:
  - `Goal` model (title, frequency, duration, priority, color, icon)
  - `Milestone` model (linked to Goal)
  - `Task` model (scheduled tasks with actual completion data)
  - `OneTimeTask` model (events/blockers)
  - `ProductivityData` model (ML training data)
- [x] Create repository pattern for data access
- [x] Implement CRUD operations for all entities
- [x] Add data validation logic
- [x] Write unit tests for data layer

### Deliverables
- ✅ Complete database schema
- ✅ Repository classes
- ✅ Unit tests for data operations

---

## Phase 2: Goal Management UI (Module A)
**Duration:** 4-5 days  
**Goal:** Build the goal creation and management interface

### Tasks
- [x] Create "Goals" screen with list view
- [x] Implement "Add Goal" form:
  - Title input
  - Frequency selector (day picker)
  - Duration picker
  - Color/icon selector
  - Priority drag-and-drop list
- [x] Build milestone/checklist editor within goals
- [x] Implement goal editing and deletion
- [x] Add visual feedback and animations
- [x] Create empty states and error handling

### Deliverables
- ✅ Fully functional goal management UI
- ✅ Drag-and-drop priority ordering
- ✅ Milestone tracking within goals

---

## Phase 3: One-Time Tasks (Module D) ✅ COMPLETE
**Duration:** 2-3 days  
**Goal:** Implement event/blocker functionality

### Tasks
- [x] Create "Add Event" button and form
- [x] Implement date/time picker for events
- [x] Build event list view
- [x] Add edit/delete functionality for events
- [x] Integrate events into timeline view
- [x] Add task completion toggle
- [x] Implement swipe-to-delete
- [x] Add pull-to-refresh
- [x] Block past date selection
- [x] Auto-refresh after create/edit

### Deliverables
- ✅ One-time task creation and management
- ✅ Event storage in database
- ✅ Timeline integration with real-time updates
- ✅ Task card with completion tracking

---

## Phase 4: ML-Powered Scheduler (Module B - Part 1) ✅ COMPLETE
**Duration:** 2-3 weeks  
**Goal:** Build intelligent scheduling system that learns from user behavior  
**Status:** COMPLETE (All tests passing - 138 total)

### Part A: Foundation & Data Collection (Week 1) ✅
- [x] Create enhanced `ScheduledTask` model with ML tracking fields
- [x] Create `ProductivityData` model for ML training
- [x] Implement repositories for scheduled tasks and productivity data
- [x] Build rule-based scheduler (fallback for new users):
  - Filter goals by frequency (day of week)
  - Sort by priority
  - Place one-time tasks as blockers
  - Distribute goals across available time slots
- [x] Create time slot allocation algorithm
- [x] Handle conflicts and overlaps

### Part B: ML Model Setup (Week 2) ✅
- [x] Set up pattern-based ML (pluggable architecture for TensorFlow Lite later)
- [x] Design ML model architecture (Goal ID, Hour, Day, Duration → Productivity Score)
- [x] Create ML service for predictions
- [x] Implement hybrid scheduler (ML + rule-based fallback)
- [x] Track confidence scores and scheduling method

### Part C: Learning Loop (Week 2-3) ✅
- [x] Create task completion modal with productivity rating
- [x] Capture actual start time and duration
- [x] Record reschedule events (user preferences)
- [x] Store all data to ProductivityData table
- [x] Implement model update mechanism
- [x] Add manual "Regenerate Schedule" via pull-to-refresh

### Part D: Integration & Polish (Week 3) ✅
- [x] Update timeline to show scheduled tasks
- [x] Create scheduled task card widget
- [x] Merge one-time and scheduled tasks in timeline
- [x] Implement auto-generation on app launch
- [x] Implement auto-regeneration on goal changes (create/update/delete/reorder)
- [x] Multi-day regeneration (today, tomorrow, day after tomorrow)
- [x] Handle edge cases (no goals, insufficient time, etc.)
- [x] Fix infinite loop issues (Goal equality, listEquals)
- [x] Fix UI update consistency (date normalization)

### Part E: Testing ✅
- [x] Write unit tests for PatternBasedMLService ✅ (8 tests passing)
- [x] Write unit tests for HybridScheduler ✅ (13 tests passing)
- [x] Write unit tests for ProductivityDataCollector ✅ (14 tests passing)
- [x] Write widget tests for TaskCompletionModal ✅ (16 tests passing)
- [x] Write widget tests for ScheduledTaskCard ✅ (19 tests passing)
- [x] Write widget tests for UnifiedTimelineCard ✅ (23 tests passing)
- [x] Write provider tests for scheduledTaskProviders ✅ (13 tests passing)
- [x] Write provider tests for timelineProviders ✅ (12 tests passing)
- [x] Write integration test for schedule generation flow
- [x] Write integration test for auto-regeneration
- [x] Fix API alignment in unit tests ✅
- [x] Fix TaskRepository Isar link bug ✅

### Deliverables
- ✅ Working hybrid scheduler (rule-based + ML)
- ✅ Productivity data collection system
- ✅ Pattern-based ML model that learns from user behavior
- ✅ Auto-regeneration on goal changes
- ✅ Multi-day schedule consistency
- ✅ Comprehensive test coverage (138 tests total, all passing)

---

## Phase 5: User Profile & Goal Categories (Prerequisites for Scheduler v2) ✅ COMPLETE
**Duration:** 3-4 days  
**Goal:** Build foundation for personalized scheduling - User profiling and goal categorization
**Status:** COMPLETE (197 tests passing)

### Part A: User Profile Data Layer ✅
- [x] Create `UserProfile` Isar model with fields:
  - `chronoType` (earlyBird, normal, nightOwl, flexible)
  - `wakeUpHour`, `sleepHour`
  - `workStartHour`, `workEndHour` (optional)
  - `busyDays` list
  - `preferredSessionLength` (short, medium, long)
  - `prefersRoutine` boolean
  - `onboardingCompleted` flag
- [x] Create `UserProfileRepository` with CRUD operations
- [x] Create `userProfileRepositoryProvider` for state management
- [x] Write unit tests for UserProfile repository (32 tests)
- [x] Add UserProfileSchema to DatabaseService initialization

### Part B: Goal Categories ✅
- [x] Add `GoalCategory` enum to goal model:
  - exercise, learning, creative, work, wellness, social, chores, other
- [x] Update `Goal` model with `category` field
- [x] Create research-backed optimal hours mapping per category
- [x] Create `GoalCategoryService` for scheduling logic
- [x] Write tests for category functionality (27 tests)
- [x] Create `CategorySelector` widget with optimal time hints
- [x] Update goal form UI to include category selector
- [x] Migrate existing goals to 'other' category (auto via default)

### Part C: App Settings Enhancement (Deferred to Phase 9)
- [ ] Extend `AppSettings` model if needed for global preferences
- [ ] Add settings for notification preferences (future use)
- [ ] Create settings repository and provider

### Deliverables
- ✅ UserProfile model and repository (with 32 tests)
- ✅ Goal categories with optimal time mappings (with 27 tests)
- ✅ CategorySelector widget with optimal time hints
- ✅ Goal form UI with category selector
- ✅ Foundation for personalized scheduling

### Test Coverage
- **Phase 5 Tests:** 59 tests (all passing)
- **Total Tests:** 197 tests (all passing)

---

## Phase 6: Onboarding Flow ✅ COMPLETE
**Duration:** 3-4 days  
**Goal:** Create onboarding experience that captures user profile for Day 1 personalization
**Status:** COMPLETE (222 tests passing)

### Part A: Onboarding UI Screens ✅
- [x] Create onboarding feature folder structure
- [x] Screen 1: Welcome screen with animated floating emojis and gradient title
- [x] Screen 2: Chronotype selection (4 options with emoji/description cards)
- [x] Screen 3: Sleep schedule picker (wake up / sleep time with visual feedback)
- [x] Screen 4: Session length preference (short/medium/long with duration bars)
- [x] Screen 5: Work schedule (optional, with toggle and time pickers)
- [x] Screen 6: Completion celebration with confetti animation
- [x] Add animated progress indicator and page dots
- [x] Add skip option (uses defaults)
- [x] Create reusable widgets: OnboardingPageIndicator, OnboardingCard, OnboardingButton, OnboardingBackground

### Part B: Onboarding Logic ✅
- [x] Create `OnboardingController` StateNotifier to manage flow state
- [x] Create `OnboardingData` and `OnboardingState` classes
- [x] Save user profile on completion via UserProfileRepository
- [x] Set `onboardingCompleted = true` flag
- [x] Handle skip scenario with sensible defaults
- [x] Auto-suggest sleep schedule based on chronotype selection
- [x] Create `onboardingControllerProvider` for state management

### Part C: Navigation Integration ✅
- [x] Update app router with `/onboarding` route
- [x] Add redirect logic to check onboarding status on launch
- [x] Redirect new users to onboarding flow
- [x] Redirect returning users to timeline

### Part D: Testing ✅
- [x] Write unit tests for OnboardingData
- [x] Write unit tests for OnboardingState
- [x] Write tests for chronotype sleep suggestions
- [x] Write tests for session length properties
- [x] Write tests for work schedule data

### Deliverables
- ✅ Complete 6-screen onboarding flow with beautiful animations
- ✅ Theme-matched dark UI with lime green accents
- ✅ Haptic feedback throughout the flow
- ✅ User profile saved on completion
- ✅ Automatic routing based on onboarding status
- ✅ Fixed timeline colors to match dark theme
- ✅ 25 new tests (222 total)

### Files Created
- `lib/features/onboarding/presentation/providers/onboarding_provider.dart`
- `lib/features/onboarding/presentation/widgets/onboarding_widgets.dart`
- `lib/features/onboarding/presentation/pages/onboarding_page.dart`
- `lib/features/onboarding/presentation/pages/welcome_screen.dart`
- `lib/features/onboarding/presentation/pages/chronotype_screen.dart`
- `lib/features/onboarding/presentation/pages/sleep_schedule_screen.dart`
- `lib/features/onboarding/presentation/pages/session_length_screen.dart`
- `lib/features/onboarding/presentation/pages/work_schedule_screen.dart`
- `lib/features/onboarding/presentation/pages/completion_screen.dart`
- `test/features/onboarding/providers/onboarding_provider_test.dart`

---

## Phase 7: Habit Tracking Foundation ✅ COMPLETE
**Duration:** 2-3 days  
**Goal:** Build streak and consistency tracking infrastructure
**Status:** COMPLETE (279 tests passing)

### Part A: Habit Metrics Data Layer ✅
- [x] Create `HabitMetrics` Isar model with fields:
  - `goalId` (linked to Goal)
  - `currentStreak`, `longestStreak`
  - `lastCompletedDate`
  - `consistencyScore` (% of scheduled days completed)
  - `timeConsistency` (% completed at same hour)
  - `stickyHour`, `stickyDayOfWeek`
  - `totalCompletions`, `totalScheduled`
- [x] Create `HabitMetricsRepository` with CRUD and calculation methods
- [x] Add HabitMetricsSchema to DatabaseService

### Part B: Habit Formation Service ✅
- [x] Create `HabitFormationService` with methods:
  - `updateMetricsOnCompletion(goalId, completedAt)`
  - `updateMetricsOnSkip(goalId)`
  - `calculateConsistencyScore(goalId)`
  - `findStickyTime(goalId)` - most successful hour
  - `getStreakStatus(goalId)` - current vs longest
- [x] Integrate with ProductivityDataCollector (update on task completion)
- [x] Calculate metrics from historical ProductivityData on first run

### Part C: Streak UI Components ✅
- [x] Create streak badge widget (🔥 14 days)
- [x] Create consistency indicator widget
- [x] Add streak display to goal card
- [x] Add streak display to timeline task card
- [x] Create "streak at risk" warning component

### Part D: Testing ✅
- [x] Write unit tests for HabitMetrics calculations (24 tests)
- [x] Write tests for streak increment/reset logic (22 tests)
- [x] Write widget tests for streak components (18 tests)

### Deliverables
- ✅ HabitMetrics model tracking streaks and consistency
- ✅ HabitFormationService for calculations
- ✅ Streak UI components (StreakBadge, MiniStreakBadge, StreakDisplay)
- ✅ Integration with GoalCard and ScheduledTaskCard
- ✅ Habit metrics providers for UI state management

### Files Created
- `lib/data/models/habit_metrics.dart`
- `lib/data/repositories/habit_metrics_repository.dart`
- `lib/core/services/habit_formation_service.dart`
- `lib/features/goals/presentation/widgets/streak_badge.dart`
- `lib/features/goals/presentation/providers/habit_metrics_provider.dart`
- `test/data/models/habit_metrics_test.dart`
- `test/data/repositories/habit_metrics_repository_test.dart`
- `test/features/goals/presentation/widgets/streak_badge_test.dart`

### Test Coverage
- **Phase 7 Tests:** 64 tests (all passing)
- **Total Tests:** 279 tests (all passing)

---

## Phase 8: Enhanced ProductivityData & ML Features ✅ COMPLETE
**Duration:** 2-3 days  
**Goal:** Add contextual features to ProductivityData for smarter ML predictions
**Status:** COMPLETE (330 tests passing)

### Part A: ProductivityData Model Enhancement ✅
- [x] Add new fields to `ProductivityData`:
  - `taskOrderInDay` (1st, 2nd, 3rd task)
  - `minutesSinceFirstActivity` (minutes since user's first activity)
  - `relativeTimeInDay` (0.0 = wake, 1.0 = sleep)
  - `previousTaskRating` (rating of task before this)
  - `currentStreakAtCompletion` (goal's streak at time of completion)
  - `goalConsistencyScore` (overall goal consistency)
  - `completionRateLast7Days`
  - `totalTasksScheduledToday`
  - `tasksCompletedBeforeThis`
  - `consecutiveTasksCompleted` (momentum tracking)
  - `minutesSinceLastCompletion`
- [x] Update `ProductivityDataCollector` to capture new fields
- [x] Capture momentum (consecutive completions, time gaps)

### Part A.1: Dynamic Wake/Sleep Handling ✅
- [x] Create `DailyActivityLog` model (Isar)
  - Track first/last activity times
  - Track tasks scheduled/completed/skipped per day
  - Store learned weekday/weekend wake patterns
- [x] Create `DailyActivityLogRepository`
  - CRUD operations
  - Pattern aggregation (getActivityPatterns)
  - Average completion rate calculation
- [x] Create `DailyActivityService`
  - `getEffectiveWakeHour()` - priority: learned → profile → default
  - `getEffectiveSleepHour()` - priority: learned → profile → default
  - `calculateRelativeTimeInDay()` - 0.0 to 1.0 scale
  - `getTodayContext()` - task order, completion rates
  - `recordTaskCompletion()` - updates activity logs
- [x] Update providers for new services

### Part B: ML Service Enhancement ✅
- [x] Update `PatternBasedMLService` to use new features
- [x] Add weighted scoring for contextual factors:
  - Streak bonus (up to 15% for 30+ day streaks)
  - Task order impact (5% bonus for first task)
  - Momentum bonus (up to 5% for consecutive completions)
- [x] Added contextual scoring to `predictWithContext()` method

### Part C: Testing ✅
- [x] Write tests for `DailyActivityLog` model (9 tests)
- [x] Write tests for `DailyActivityLogRepository` (12 tests)
- [x] Write tests for `DailyActivityService` (30 tests)
- [x] Update existing ML service tests for new features
- [x] Validate prediction accuracy with enhanced features

### Files Created/Modified
- `lib/data/models/daily_activity_log.dart` (NEW)
- `lib/data/models/daily_activity_log.g.dart` (GENERATED)
- `lib/data/repositories/daily_activity_log_repository.dart` (NEW)
- `lib/core/services/daily_activity_service.dart` (NEW)
- `lib/core/services/database_service.dart` (MODIFIED - added schema & provider)
- `lib/core/services/productivity_data_collector.dart` (MODIFIED - contextual capture)
- `lib/core/services/pattern_based_ml_service.dart` (MODIFIED - contextual scoring)
- `lib/core/providers/productivity_providers.dart` (MODIFIED - new providers)
- `lib/core/providers/scheduler_providers.dart` (MODIFIED - ML service dependencies)
- `lib/data/models/productivity_data.dart` (MODIFIED - new fields)
- `test/data/models/daily_activity_log_test.dart` (NEW)
- `test/data/repositories/daily_activity_log_repository_test.dart` (NEW)
- `test/core/services/daily_activity_service_test.dart` (NEW)

### Deliverables
- ✅ Enhanced ProductivityData with 11 contextual features
- ✅ Dynamic wake/sleep tracking via DailyActivityLog
- ✅ DailyActivityService for pattern learning and context calculations
- ✅ Smarter ML predictions using contextual data (streak, momentum, task order)
- ✅ 51 new tests for Phase 8 components

### Test Coverage
- **Phase 8 Tests:** 51 tests (all passing)
- **Total Tests:** 330 tests (all passing)

---

## Phase 9: Scheduler v2 - Three-Tier Architecture
**Duration:** 4-5 days  
**Goal:** Implement the complete three-tier scheduling system with habit overlay
**Status:** NOT STARTED
**Dependencies:** Phase 5, 6, 7, 8

### Part A: Profile-Based Scheduler (Tier 2)
- [ ] Create `ProfileBasedScheduler` service
- [ ] Implement chrono-type time preferences:
  - Early Bird: High priority 6-10 AM
  - Normal: High priority 9 AM-12 PM
  - Night Owl: High priority 8 PM-12 AM
- [ ] Implement goal category optimal hours
- [ ] Combine chrono-type + category for smart defaults
- [ ] Handle work hour avoidance (if set)

### Part B: Dynamic Time Window Service
- [ ] Create `DynamicTimeWindowService`
- [ ] Use user profile wake/sleep hours as base
- [ ] Learn from successful completions (4+ rating)
- [ ] Adjust earliest/latest successful hours per day
- [ ] Handle weekday vs weekend differences
- [ ] Update window on each task completion

### Part C: HybridScheduler v2 Integration
- [ ] Update `HybridScheduler` with three-tier logic:
  1. ML-based (if ≥10 data, ≥60% confidence)
  2. Profile-based (if onboarding completed)
  3. Rule-based (fallback)
- [ ] Add habit formation overlay:
  - Prefer sticky times for goals with high consistency
  - Protect streaks (14+ days)
  - Apply 21-day habit lock
- [ ] Use dynamic time windows instead of hardcoded 6AM-11PM

### Part D: Testing & Validation
- [ ] Write unit tests for ProfileBasedScheduler
- [ ] Write unit tests for DynamicTimeWindowService
- [ ] Update HybridScheduler tests for three-tier logic
- [ ] Write integration tests for complete scheduling flow
- [ ] Validate scheduling quality with test scenarios

### Deliverables
- Three-tier scheduling system (ML → Profile → Rules)
- Dynamic time windows based on user behavior
- Habit formation overlay for consistency optimization
- Complete test coverage for scheduler v2

---

## Phase 10: Polish & Optimization
**Duration:** 3-4 days  
**Goal:** Refine UI/UX and optimize performance

### Tasks
- [ ] Finalize dark mode with neon accents
- [ ] Add micro-animations and transitions
- [ ] Optimize database queries
- [ ] Add loading states and skeleton screens
- [ ] Implement error boundaries and crash reporting
- [ ] Create app icon and splash screen
- [ ] Performance profiling and optimization
- [ ] Add "Redo Onboarding" option in settings

### Deliverables
- Polished, premium-feeling UI
- Smooth performance
- Complete user onboarding

---

## Phase 11: Testing & Bug Fixes
**Duration:** 3-5 days  
**Goal:** Comprehensive testing and quality assurance

### Tasks
- [ ] Write integration tests for full app flow
- [ ] Run data layer unit tests as integration tests on device/emulator
  - Goal repository tests (10 tests)
  - Task repository tests (6 tests)
  - Milestone repository tests (5 tests)
  - UserProfile repository tests
  - HabitMetrics repository tests
- [ ] Perform manual testing on various Android devices
- [ ] Test edge cases:
  - Empty states
  - Scheduling conflicts
  - Data persistence
  - ML model edge cases
  - Onboarding skip scenarios
  - Streak edge cases (timezone, missed days)
- [ ] Fix identified bugs
- [ ] Optimize battery usage
- [ ] Test offline functionality thoroughly

### Deliverables
- Stable, bug-free app
- Test coverage report
- Performance benchmarks

---

## Phase 12: Release Preparation
**Duration:** 2-3 days  
**Goal:** Prepare for initial release

### Tasks
- [ ] Create release build
- [ ] Set up Android signing
- [ ] Write app store description
- [ ] Create screenshots and promotional materials
- [ ] Prepare privacy policy (emphasize offline/privacy)
- [ ] Set up crash analytics (optional, privacy-focused)
- [ ] Create user documentation/help section
- [ ] Submit to Google Play Store (internal testing)

### Deliverables
- Release-ready APK/AAB
- Play Store listing
- User documentation

---

## Future Phases (V2+)

### Phase 13: Statistics Dashboard
- Productivity analytics
- Time-of-day heatmaps
- Streak tracking visualization
- Goal completion rates
- Weekly/monthly reports

### Phase 14: Advanced Features
- Habit stacking detection
- Smart notifications (streak reminders, optimal time suggestions)
- Widget support (today's schedule, streak counter)
- Backup/restore functionality
- iOS support
- TensorFlow Lite integration for advanced ML

---

## Development Timeline Summary

| Phase | Description | Duration | Cumulative |
|-------|-------------|----------|------------|
| Phase 0 | Setup | 1-2 days | 2 days |
| Phase 1 | Data Layer | 3-4 days | 6 days |
| Phase 2 | Goal Management | 4-5 days | 11 days |
| Phase 3 | One-Time Tasks | 2-3 days | 14 days |
| Phase 4 | Scheduler v1 (ML) | 2-3 weeks | ~35 days |
| **Phase 5** | **User Profile & Categories** | **3-4 days** | **39 days** |
| **Phase 6** | **Onboarding Flow** | **3-4 days** | **43 days** |
| **Phase 7** | **Habit Tracking** | **2-3 days** | **46 days** |
| **Phase 8** | **Enhanced ML Features** | **2-3 days** | **49 days** |
| **Phase 9** | **Scheduler v2** | **4-5 days** | **54 days** |
| Phase 10 | Polish | 3-4 days | 58 days |
| Phase 11 | Testing | 3-5 days | 63 days |
| Phase 12 | Release | 2-3 days | **66 days** |

**Estimated Total:** ~9-10 weeks for MVP with Smart Scheduling v2

---

## Implementation Order (Scheduler v2 Prerequisites)

```
Phase 5: User Profile & Categories (FOUNDATION)
    │
    ├─→ UserProfile model + repository
    ├─→ Goal category field + optimal hours
    │
    ▼
Phase 6: Onboarding Flow (USER DATA CAPTURE)
    │
    ├─→ 6-screen onboarding UI
    ├─→ Profile saved on completion
    │
    ▼
Phase 7: Habit Tracking (CONSISTENCY FOUNDATION)
    │
    ├─→ HabitMetrics model + service
    ├─→ Streak/consistency calculations
    │
    ▼
Phase 8: Enhanced ML Features (SMARTER PREDICTIONS)
    │
    ├─→ Context features in ProductivityData
    ├─→ Enhanced ML service
    │
    ▼
Phase 9: Scheduler v2 (INTEGRATION)
    │
    ├─→ ProfileBasedScheduler (Tier 2)
    ├─→ DynamicTimeWindowService
    ├─→ HybridScheduler v2 (3-tier)
    └─→ Habit formation overlay
```

---

## Notes

- **Phases 5-9 are the Scheduler v2 prerequisite chain** - must be done in order
- Each phase builds upon the previous one
- Phase 9 cannot start until Phases 5-8 are complete
- Timeline assumes single developer working full-time
- Add buffer time for unexpected challenges
- **Current Progress:** Phase 4 complete, ready to start Phase 5
