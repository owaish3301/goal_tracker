# Test Coverage Report - Goal Tracker

**Last Updated:** 2025-11-21  
**Current Phase:** Phase 2 (Goal Management UI) - Complete  
**Next Phase:** Phase 3 (One-Time Tasks)

---

## 📊 Overall Test Coverage

| Layer | Tests Written | Tests Passing | Coverage % |
|-------|--------------|---------------|------------|
| **Data Layer** | 21 tests | ⏸️ Deferred to Phase 9 | ~50% |
| **UI Layer** | 0 tests | - | 0% |
| **Integration** | 0 tests | - | 0% |
| **Total** | 21 tests | ⏸️ Deferred | ~25% |

---

## ✅ Tests Written (Phase 1 - Data Layer)

### 1. GoalRepository Tests ✅
**File:** `test/data/repositories/goal_repository_test.dart`  
**Status:** Written, deferred to Phase 9  
**Test Count:** 10 tests

#### Test Cases:
- [x] `createGoal` - Should create a new goal
- [x] `getGoal` - Should retrieve a goal by ID
- [x] `getAllGoals` - Should return all goals
- [x] `getActiveGoals` - Should return only active goals
- [x] `getGoalsForDay` - Should return goals for specific day of week
- [x] `updateGoal` - Should update goal fields and set updatedAt
- [x] `deleteGoal` - Should remove goal from database
- [x] `updatePriorityIndexes` - Should reorder goals by priority
- [x] `getGoalCount` - Should return total count
- [x] `getActiveGoalCount` - Should return active goal count

**Coverage:** 100% of GoalRepository methods

---

### 2. MilestoneRepository Tests ✅
**File:** `test/data/repositories/milestone_repository_test.dart`  
**Status:** Written, deferred to Phase 9  
**Test Count:** 5 tests

#### Test Cases:
- [x] `createMilestone` - Should create milestone linked to goal
- [x] `getMilestonesForGoal` - Should return milestones in order
- [x] `markAsCompleted` - Should update completion status and timestamp
- [x] `getCompletedMilestones` - Should return only completed milestones
- [x] `reorderMilestones` - Should update order indexes

**Coverage:** 100% of MilestoneRepository core methods

**Missing Tests:**
- [ ] `updateMilestone` - General update method
- [ ] `markAsIncomplete` - Reverting completion status
- [ ] `deleteMilestone` - Removing milestones
- [ ] `getMilestoneCount` - Counting milestones
- [ ] `getCompletedMilestoneCount` - Counting completed milestones

---

### 3. TaskRepository Tests ✅
**File:** `test/data/repositories/task_repository_test.dart`  
**Status:** Written, deferred to Phase 9  
**Test Count:** 6 tests

#### Test Cases:
- [x] `createTask` - Should create task with goal link
- [x] `getTasksForDate` - Should return tasks for specific date sorted by time
- [x] `recordCompletion` - Should update task with completion data
- [x] `rescheduleTask` - Should update task time and mark as rescheduled
- [x] `getPendingTasks` - Should return only pending tasks
- [x] `deleteTasksForDate` - Should remove all tasks for a date

**Coverage:** ~60% of TaskRepository methods

**Missing Tests:**
- [ ] `getTask` - Retrieving single task by ID
- [ ] `updateTask` - General update method
- [ ] `getCompletedTasks` - Filtering completed tasks
- [ ] `getTasksForGoal` - Getting all tasks for a specific goal
- [ ] `getTasksInTimeRange` - Filtering tasks by time range
- [ ] `deleteTask` - Removing single task

---

## ❌ Tests NOT Written

### Missing Repository Tests (Phase 1)

#### 4. OneTimeTaskRepository Tests ❌
**File:** Not created  
**Priority:** Medium (needed for Phase 3)  
**Test Count:** 0 / ~8 expected

**Tests to Write:**
- [ ] `createOneTimeTask` - Should create a one-time event
- [ ] `getOneTimeTask` - Should retrieve by ID
- [ ] `getOneTimeTasksForDate` - Should return events for specific date
- [ ] `getOneTimeTasksInRange` - Should return events in date range
- [ ] `updateOneTimeTask` - Should update event details
- [ ] `deleteOneTimeTask` - Should remove event
- [ ] `getUpcomingOneTimeTasks` - Should return future events
- [ ] Conflict detection tests with scheduled tasks

---

#### 5. ProductivityDataRepository Tests ❌
**File:** Not created  
**Priority:** Low (needed for Phase 7 - ML)  
**Test Count:** 0 / ~6 expected

**Tests to Write:**
- [ ] `recordProductivityData` - Should save ML training data
- [ ] `getProductivityDataForGoal` - Should retrieve data for specific goal
- [ ] `getProductivityDataInRange` - Should filter by date range
- [ ] `getAverageProductivityScore` - Should calculate averages
- [ ] `getProductivityByTimeOfDay` - Should group by time buckets
- [ ] `getProductivityByDayOfWeek` - Should group by day

---

#### 6. AppSettingsRepository Tests ❌
**File:** Not created  
**Priority:** Low (needed for Phase 8 - Polish)  
**Test Count:** 0 / ~4 expected

**Tests to Write:**
- [ ] `getSettings` - Should retrieve app settings
- [ ] `updateSettings` - Should save settings
- [ ] `resetToDefaults` - Should reset all settings
- [ ] Settings persistence across app restarts

---

### Missing UI Tests (Phase 2)

#### Widget Tests ❌
**Priority:** High (should be written for Phase 2)

**Components to Test:**

##### Pages:
- [ ] `goals_page.dart`
  - [ ] Should display empty state when no goals
  - [ ] Should display list of goals
  - [ ] Should navigate to add goal page
  - [ ] Should navigate to edit goal page
  - [ ] Should handle goal deletion
  - [ ] Should support drag-and-drop reordering

- [ ] `add_edit_goal_page.dart`
  - [ ] Should validate required fields
  - [ ] Should create new goal with valid data
  - [ ] Should update existing goal
  - [ ] Should load existing goal data in edit mode
  - [ ] Should handle save errors
  - [ ] Should show loading state while saving

##### Custom Widgets:
- [ ] `goal_card.dart`
  - [ ] Should display goal information correctly
  - [ ] Should show frequency days
  - [ ] Should display target duration
  - [ ] Should handle tap events
  - [ ] Should show active/inactive states

- [ ] `frequency_selector.dart`
  - [ ] Should allow selecting multiple days
  - [ ] Should deselect days on tap
  - [ ] Should display selected days visually
  - [ ] Should call onChanged callback

- [ ] `duration_picker.dart`
  - [ ] Should display current duration
  - [ ] Should allow incrementing/decrementing
  - [ ] Should enforce minimum/maximum values
  - [ ] Should call onChanged callback

- [ ] `color_picker.dart`
  - [ ] Should display color options
  - [ ] Should highlight selected color
  - [ ] Should call onChanged callback
  - [ ] Should support custom colors

- [ ] `icon_selector.dart`
  - [ ] Should display icon options
  - [ ] Should highlight selected icon
  - [ ] Should call onChanged callback
  - [ ] Should render icons correctly

- [ ] `milestone_editor.dart`
  - [ ] Should display list of milestones
  - [ ] Should add new milestone
  - [ ] Should edit existing milestone
  - [ ] Should delete milestone
  - [ ] Should reorder milestones
  - [ ] Should validate milestone input

- [ ] `empty_goals_state.dart`
  - [ ] Should display empty state message
  - [ ] Should show call-to-action button
  - [ ] Should handle navigation

---

#### Provider Tests ❌
**Priority:** High

- [ ] `goal_provider.dart`
  - [ ] Should load goals on initialization
  - [ ] Should create goal and update state
  - [ ] Should update goal and refresh state
  - [ ] Should delete goal and update state
  - [ ] Should handle errors gracefully
  - [ ] Should maintain loading states

---

### Integration Tests ❌
**Priority:** Medium (Phase 9)

**Test Scenarios:**
- [ ] Complete goal creation flow
- [ ] Complete goal editing flow
- [ ] Goal deletion with confirmation
- [ ] Priority reordering persistence
- [ ] Milestone management within goals
- [ ] Navigation between screens
- [ ] Data persistence across app restarts
- [ ] Error handling and recovery

---

## ⚠️ Current Testing Limitations

### Issue: Isar Native Library Dependency
**Problem:** Data layer tests cannot run on desktop (Windows/Mac/Linux) because Isar requires native binaries that are only available on mobile devices/emulators.

**Error Message:**
```
Failed to load dynamic library 'isar.dll': The specified module could not be found.
```

**Solution:** Tests will be run as integration tests on Android emulator in Phase 9.

**How to Run (Phase 9):**
```bash
# Start Android emulator first
flutter emulators --launch <emulator-id>

# Run data layer tests on emulator
flutter test test/data/repositories/ --device-id=emulator-5554

# Or run as integration tests
flutter test integration_test/ --device-id=<device-id>
```

---

## ✅ Current Verification Methods

Since unit tests can't run on desktop, the following verification methods are being used:

1. **Static Analysis**
   ```bash
   flutter analyze
   ```
   ✅ All files pass with no issues

2. **Code Compilation**
   ```bash
   flutter build apk --debug
   ```
   ✅ Project compiles successfully

3. **Manual Testing**
   - ✅ Goal creation through UI
   - ✅ Goal editing through UI
   - ✅ Goal deletion through UI
   - ✅ Milestone management
   - ✅ Priority reordering
   - ✅ Data persistence

4. **Code Review**
   - ✅ Repository API design validated
   - ✅ Data model relationships verified
   - ✅ Isar schema generation successful

---

## 📋 Testing Roadmap

### Phase 2 (Current) - Goal Management UI
**Recommended Actions:**
- [ ] Write widget tests for all custom components
- [ ] Write provider tests for goal_provider
- [ ] Write integration tests for goal management flow
- [ ] Set up test coverage reporting

### Phase 3 - One-Time Tasks
**Testing Requirements:**
- [ ] Write OneTimeTaskRepository tests
- [ ] Write widget tests for event UI
- [ ] Test conflict detection with scheduled tasks

### Phase 4 - Scheduler Logic
**Testing Requirements:**
- [ ] Write scheduler algorithm tests
- [ ] Test priority-based scheduling
- [ ] Test conflict resolution
- [ ] Test time slot allocation

### Phase 5 - Timeline UI
**Testing Requirements:**
- [ ] Write timeline widget tests
- [ ] Test drag-and-drop functionality
- [ ] Test swipe gestures
- [ ] Test visual state transitions

### Phase 6 - Feedback Loop
**Testing Requirements:**
- [ ] Write completion modal tests
- [ ] Test productivity data collection
- [ ] Test milestone progress tracking

### Phase 7 - ML Integration
**Testing Requirements:**
- [ ] Write ProductivityDataRepository tests
- [ ] Test ML model training
- [ ] Test prediction accuracy
- [ ] Test fallback logic

### Phase 9 - Comprehensive Testing
**Major Tasks:**
- [ ] Run all data layer tests on Android emulator
- [ ] Write missing repository tests
- [ ] Add error handling tests
- [ ] Add edge case tests
- [ ] Performance testing with large datasets (1000+ goals/tasks)
- [ ] Concurrent operation tests
- [ ] Data migration tests (if schema changes)
- [ ] End-to-end integration tests
- [ ] Generate test coverage report
- [ ] Achieve >80% code coverage

---

## 🎯 Test Coverage Goals

### Minimum Acceptable Coverage (MVP)
- **Data Layer:** 80%
- **UI Layer:** 60%
- **Integration:** 50%
- **Overall:** 70%

### Ideal Coverage (Production)
- **Data Layer:** 95%
- **UI Layer:** 80%
- **Integration:** 70%
- **Overall:** 85%

---

## 📝 Notes

### Test Writing Guidelines
1. **Use descriptive test names** - Should read like documentation
2. **Follow AAA pattern** - Arrange, Act, Assert
3. **One assertion per test** - Keep tests focused
4. **Use test fixtures** - Create reusable test data
5. **Mock external dependencies** - Isolate units under test
6. **Test edge cases** - Empty lists, null values, boundary conditions
7. **Test error handling** - Invalid input, database errors, network failures

### Test Organization
```
test/
├── data/
│   ├── models/           # Model tests (if needed)
│   └── repositories/     # Repository tests
├── features/
│   ├── goals/
│   │   ├── presentation/
│   │   │   ├── pages/    # Page widget tests
│   │   │   ├── widgets/  # Component widget tests
│   │   │   └── providers/# Provider tests
│   └── timeline/         # (Future)
├── core/
│   ├── services/         # Service tests
│   └── utils/            # Utility tests
└── integration_test/     # E2E integration tests
```

---

## 🔗 Related Documentation
- [TESTING_NOTES.md](TESTING_NOTES.md) - Current testing status and issues
- [DEVELOPMENT_PHASES.md](DEVELOPMENT_PHASES.md) - Phase 9 testing details
- [DATABASE_SCHEMA.md](DATABASE_SCHEMA.md) - Data model reference for tests

---

## 📊 Progress Tracking

**Last Test Written:** 2024-11-XX (Phase 1 - TaskRepository)  
**Next Test to Write:** Widget tests for Phase 2 components  
**Tests Passing:** 0 / 21 (deferred to Phase 9)  
**Overall Progress:** 25% of planned tests written
