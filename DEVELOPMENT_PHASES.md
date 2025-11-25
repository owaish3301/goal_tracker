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

## Phase 8: Polish & Optimization
**Duration:** 3-4 days  
**Goal:** Refine UI/UX and optimize performance

### Tasks
- [ ] Implement dark mode with neon accents
- [ ] Add micro-animations and transitions
- [ ] Optimize database queries
- [ ] Add loading states and skeleton screens
- [ ] Implement error boundaries and crash reporting
- [ ] Add onboarding flow for new users
- [ ] Create app icon and splash screen
- [ ] Performance profiling and optimization

### Deliverables
- Polished, premium-feeling UI
- Smooth performance
- Complete user onboarding

---

## Phase 9: Testing & Bug Fixes
**Duration:** 3-5 days  
**Goal:** Comprehensive testing and quality assurance

### Tasks
- [ ] Write integration tests
- [ ] Run data layer unit tests as integration tests on device/emulator
  - Goal repository tests (10 tests)
  - Task repository tests (6 tests)
  - Milestone repository tests (5 tests)
  - Note: These tests exist in `test/data/repositories/` but require Isar native libraries to run
- [ ] Perform manual testing on various Android devices
- [ ] Test edge cases:
  - Empty states
  - Scheduling conflicts
  - Data persistence
  - ML model edge cases
- [ ] Fix identified bugs
- [ ] Optimize battery usage
- [ ] Test offline functionality thoroughly

### Deliverables
- Stable, bug-free app
- Test coverage report
- Performance benchmarks

---

## Phase 10: Release Preparation
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

### Phase 11: Statistics Dashboard
- Productivity analytics
- Time-of-day heatmaps
- Streak tracking
- Goal completion rates

### Phase 12: Advanced Features
- Habit stacking detection
- Smart notifications
- Widget support
- Backup/restore functionality
- iOS support

---

## Development Timeline Summary

| Phase | Duration | Cumulative |
|-------|----------|------------|
| Phase 0: Setup | 1-2 days | 2 days |
| Phase 1: Data Layer | 3-4 days | 6 days |
| Phase 2: Goal Management | 4-5 days | 11 days |
| Phase 3: One-Time Tasks | 2-3 days | 14 days |
| Phase 4: Scheduler Logic | 4-5 days | 19 days |
| Phase 5: Timeline UI | 5-6 days | 25 days |
| Phase 6: Feedback Loop | 3-4 days | 29 days |
| Phase 7: ML Integration | 6-8 days | 37 days |
| Phase 8: Polish | 3-4 days | 41 days |
| Phase 9: Testing | 3-5 days | 46 days |
| Phase 10: Release | 2-3 days | **49 days** |

**Estimated Total:** ~7-8 weeks for MVP with ML

---

## Notes

- Each phase builds upon the previous one
- Phases 2-6 can have some parallel development
- ML integration (Phase 7) is the most complex and may require iteration
- Timeline assumes single developer working full-time
- Add buffer time for unexpected challenges, especially in ML phase
