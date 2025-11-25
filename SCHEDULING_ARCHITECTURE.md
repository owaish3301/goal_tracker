# 🧠 Goal Tracker Scheduling System - Detailed Architecture

## Overview

Your app uses a **Hybrid Scheduling Architecture** that combines **Rule-Based Scheduling** (for new users or goals without enough data) and **Pattern-Based Machine Learning** (for goals with sufficient historical data). This creates an intelligent system that starts with sensible defaults and learns from user behavior over time.

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                      HybridScheduler                             │
│  (Orchestrator - decides which strategy to use)                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   ┌─────────────────────┐      ┌─────────────────────────┐      │
│   │  RuleBasedScheduler │      │  PatternBasedMLService  │      │
│   │  (Fallback - Day 1) │      │  (Smart - After 10+     │      │
│   │                     │      │   completions)          │      │
│   └─────────────────────┘      └─────────────────────────┘      │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                   ProductivityDataCollector                      │
│  (Records every completion, reschedule, skip for ML training)    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      ProductivityData                            │
│  (ML Training Database - stores features & labels)               │
└─────────────────────────────────────────────────────────────────┘
```

---

## Component 1: HybridScheduler

**File:** `lib/core/services/hybrid_scheduler.dart`

### Purpose
The brain of the scheduling system. It decides **when** and **how** to schedule each goal.

### Key Constants
```dart
static const double minMLConfidence = 0.6;  // Requires 60% confidence to use ML
```

### Main Flow: `scheduleForDate(DateTime date)`

```
1. Get active goals for this day
   └── Filter by frequency (e.g., Mon/Wed/Fri goals)
   └── Sort by priority (lower index = higher priority)

2. Get blockers (one-time tasks/events)
   └── These are time slots that cannot be used

3. Calculate available time slots
   └── Day runs from 6 AM to 11 PM
   └── Subtract blocker times

4. For each goal (in priority order):
   └── Check: Does ML have enough data? (≥10 completions)
       ├── YES → Try ML-based scheduling first
       │         └── If ML confidence ≥ 60% → Use ML prediction
       │         └── If ML fails/low confidence → Fall back to rules
       └── NO → Use rule-based scheduling
```

### Decision Logic
```dart
Future<ScheduledTask?> _scheduleGoalHybrid({...}) async {
  // Check if ML has enough data
  final hasMLData = await mlPredictor.hasEnoughData(goal.id);

  if (hasMLData) {
    // Try ML first
    final mlTask = await _scheduleWithML(...);
    if (mlTask != null) return mlTask;
    // ML failed, fall back to rules
  }
  
  // Use rule-based scheduling
  return _scheduleWithRules(...);
}
```

---

## Component 2: RuleBasedScheduler

**File:** `lib/core/services/rule_based_scheduler.dart`

### Purpose
Provides sensible defaults for new users or goals without ML data. Uses **priority-based time slot assignment**.

### Key Constants
```dart
static const int dayStartHour = 6;        // 6 AM
static const int dayEndHour = 23;         // 11 PM  
static const int minTaskGapMinutes = 15;  // 15-min buffer between tasks
```

### Time Slot Allocation Strategy

```
Priority Index 0-2 (High Priority)  → Morning   (6 AM - 12 PM)
Priority Index 3-5 (Medium Priority)→ Afternoon (12 PM - 6 PM)
Priority Index 6+  (Low Priority)   → Evening   (6 PM - 11 PM)
```

**Why this logic?**
- High priority tasks get the morning when most people have peak mental energy
- Medium priority tasks go in the afternoon
- Low priority tasks fill evening slots

### Slot Calculation Algorithm

```dart
List<TimeSlot> calculateAvailableSlots(DateTime date, List<OneTimeTask> blockers) {
  // Start with full day: 6 AM → 11 PM
  
  // For each blocker (sorted by start time):
  //   1. Add free slot BEFORE the blocker
  //   2. Skip the blocker time
  //   3. Continue from after the blocker
  
  // Add remaining time after last blocker
}
```

**Example:**
```
Day: 6 AM ────────────────────────────── 11 PM
Blocker: Meeting 2-3 PM

Available Slots:
  [6 AM - 2 PM] [3 PM - 11 PM]
```

---

## Component 3: PatternBasedMLService

**File:** `lib/core/services/pattern_based_ml_service.dart`

### Purpose
Learns from user behavior to predict the **optimal time** for each goal. Uses statistical pattern matching (pluggable architecture allows TensorFlow Lite integration later).

### Key Constant
```dart
final int minDataPoints = 10;  // Need 10+ completions before using ML
```

### Prediction Algorithm: `predictProductivity()`

The ML service calculates a **weighted score** based on 5 factors:

| Factor | Weight | Description |
|--------|--------|-------------|
| Exact Match (hour + day) | 3.0 | Same hour on same day of week |
| Hour Match | 2.0 | Same hour, any day |
| Day Match | 1.5 | Same day of week, any hour |
| Time Slot Type Match | 1.0 | Same period (morning/afternoon/evening/night) |
| Overall Average | 0.5 | Baseline productivity for this goal |

### Confidence Calculation

```dart
double _calculateConfidence({dataCount, exactMatches, hourMatches}) {
  // Base confidence from data volume
  double confidence = (dataCount / 50).clamp(0.0, 1.0);
  
  // Boost for exact matches (+30%)
  if (exactMatches > 0) confidence += 0.3;
  
  // Boost for hour matches (+20%)
  if (hourMatches >= 3) confidence += 0.2;
  
  return confidence.clamp(0.0, 1.0);
}
```

### Reschedule Penalty

If a user frequently reschedules a goal, the ML penalizes that time slot:

```dart
final rescheduleRate = wasRescheduledCount / totalCount;
final adjustedScore = weightedScore * (1.0 - (rescheduleRate * 0.2));
// 20% penalty per reschedule rate
```

**Why?** If a user always moves "Exercise" from 7 AM to 6 PM, the app learns that 7 AM isn't good for Exercise.

---

## Component 4: ProductivityDataCollector

**File:** `lib/core/services/productivity_data_collector.dart`

### Purpose
The **learning loop** - collects all user interactions to train the ML model.

### Data Collection Points

| Event | What's Recorded | ML Signal |
|-------|-----------------|-----------|
| Task Completed | Actual time, duration, productivity rating | Positive signal for that time slot |
| Task Rescheduled | Original time, new time | Negative signal for original time |
| Task Skipped | Scheduled time | Strong negative signal |

### Key Method: `recordTaskCompletion()`

When user completes a task and rates productivity (1-5 stars):

```dart
await _createProductivityData(
  task: task,
  actualStartTime: actualStartTime,           // When they actually started
  actualDurationMinutes: actualDurationMinutes, // How long it took
  productivityRating: productivityRating,     // 1-5 star rating
);
```

---

## Component 5: ProductivityData Model

**File:** `lib/data/models/productivity_data.dart`

### Feature Engineering

The ML model uses these **features** to learn:

```dart
// Time Features
late int hourOfDay;      // 0-23
late int dayOfWeek;      // 0=Monday, 6=Sunday
late int duration;       // Planned duration
late int timeSlotType;   // 0=morning, 1=afternoon, 2=evening, 3=night

// Context Features  
late bool hadPriorTask;      // Task before this one?
late bool hadFollowingTask;  // Task after this one?
late int weekOfYear;         // For seasonal patterns
late bool isWeekend;         // Saturday/Sunday?

// Behavioral Signals (IMPORTANT!)
late bool wasRescheduled;    // Did they move this task?
late bool wasCompleted;      // Did they finish it?
late int actualDurationMinutes;
late int minutesFromScheduled;  // How late/early did they start?
```

### The Label (What ML Predicts)
```dart
late double productivityScore;  // 1.0 - 5.0 (user's rating)
```

---

## Complete Scheduling Flow

Here's what happens when the app generates a schedule:

```
┌──────────────────────────────────────────────────────────────────┐
│  1. App Launch or Date Change                                     │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  2. HybridScheduler.scheduleForDate(today)                       │
│     │                                                             │
│     ├─→ Get goals matching today's day-of-week                   │
│     │   (e.g., Monday goals if today is Monday)                  │
│     │                                                             │
│     ├─→ Sort by priority (priorityIndex: 0 = highest)            │
│     │                                                             │
│     ├─→ Get one-time tasks (blockers) for today                  │
│     │                                                             │
│     └─→ Calculate available time slots (6 AM - 11 PM minus blockers)│
│                                                                   │
│  3. For each goal:                                                │
│     │                                                             │
│     ├─→ Check: mlPredictor.hasEnoughData(goalId) ≥ 10?           │
│     │     │                                                       │
│     │     ├─→ YES: Try ML scheduling                             │
│     │     │     │                                                 │
│     │     │     ├─→ For each free slot:                          │
│     │     │     │     └─→ predictProductivity(goalId, hour, day) │
│     │     │     │                                                 │
│     │     │     ├─→ Pick slot with highest score (if conf ≥ 60%) │
│     │     │     │                                                 │
│     │     │     └─→ If no good ML prediction → fall back to rules│
│     │     │                                                       │
│     │     └─→ NO: Use rule-based scheduling                      │
│     │           └─→ Assign based on priority:                    │
│     │               High → Morning, Med → Afternoon, Low → Evening│
│     │                                                             │
│     └─→ Mark time slot as used (with 15-min buffer)              │
│                                                                   │
│  4. Save ScheduledTasks to database                               │
│                                                                   │
│  5. Display in Timeline UI                                        │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

---

## Learning Loop Flow

```
┌──────────────────────────────────────────────────────────────────┐
│  User Action                      ML Learning                     │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ✅ Complete Task                                                 │
│  └─→ Rate productivity (1-5 ⭐)                                   │
│  └─→ ProductivityDataCollector.recordTaskCompletion()            │
│  └─→ Creates ProductivityData record with:                        │
│      • goalId, hourOfDay, dayOfWeek                              │
│      • productivityScore (the label!)                            │
│      • wasRescheduled = false                                    │
│                                                                   │
│  🔄 Reschedule Task                                               │
│  └─→ ProductivityDataCollector.recordTaskReschedule()            │
│  └─→ Updates task with:                                          │
│      • wasRescheduled = true                                     │
│      • rescheduleCount++                                         │
│  └─→ ML learns: "User doesn't like this time for this goal"      │
│                                                                   │
│  ⏭️ Skip Task                                                     │
│  └─→ ProductivityDataCollector.recordTaskSkipped()               │
│  └─→ Creates ProductivityData with:                              │
│      • wasCompleted = false                                      │
│  └─→ ML learns: "This time slot doesn't work"                    │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

---

## Real-World Example

**User Profile:** Sarah, who works out and studies coding

### Goals:
1. **Exercise** - Mon/Wed/Fri, 45 min, Priority 0 (high)
2. **Learn Flutter** - Mon-Fri, 60 min, Priority 1 (high)
3. **Read Book** - Daily, 30 min, Priority 5 (medium)

### Day 1 (No ML data yet):
```
📅 Monday Schedule (Rule-Based):

6:00 AM - Exercise (45 min)      [High priority → Morning]
6:45 AM - 15 min buffer
7:00 AM - Learn Flutter (60 min) [High priority → Morning]
8:00 AM - 15 min buffer
12:00 PM - Read Book (30 min)    [Medium priority → Afternoon]
```

### After 2 weeks (ML kicks in for Exercise - 10+ completions):

Sarah's pattern: She always rates Exercise higher when done at 7 PM, and frequently reschedules morning workouts.

```
📅 Monday Schedule (Hybrid):

7:00 AM - Learn Flutter (60 min)  [ML: 7 AM works well, confidence 72%]
12:00 PM - Read Book (30 min)     [Rule-based: not enough data]
7:00 PM - Exercise (45 min)       [ML: User prefers evening, confidence 85%]
```

The ML learned that Sarah is NOT a morning workout person!

---

## Key Design Decisions

### 1. **Why 60% confidence threshold?**
Lower threshold = more aggressive ML usage (might be wrong)
Higher threshold = more conservative, falls back to rules often
60% is a balance between learning and reliability.

### 2. **Why 10 data points minimum?**
Statistical significance - with fewer data points, patterns might be noise.

### 3. **Why priority-based time slots for rules?**
Mimics common productivity advice: "Eat the frog first" (do hard tasks early).

### 4. **Why track reschedules?**
Reschedules are the strongest signal that a time slot doesn't work for that user.

### 5. **Pluggable ML Architecture**
```dart
abstract class MLPredictor {
  Future<MLPrediction?> predictProductivity(...);
  Future<bool> hasEnoughData(int goalId);
}
```
This interface allows swapping `PatternBasedMLService` with `TFLiteMLService` later without changing the scheduler.

---

## File Reference

| File | Purpose |
|------|---------|
| `lib/core/services/hybrid_scheduler.dart` | Main orchestrator |
| `lib/core/services/rule_based_scheduler.dart` | Fallback scheduler |
| `lib/core/services/pattern_based_ml_service.dart` | ML predictions |
| `lib/core/services/ml_predictor.dart` | Abstract ML interface |
| `lib/core/services/productivity_data_collector.dart` | Learning loop |
| `lib/data/models/productivity_data.dart` | ML training data model |
| `lib/data/models/scheduled_task.dart` | Scheduled task model |

---

## Summary

| Component | Role |
|-----------|------|
| **HybridScheduler** | Orchestrator - decides ML vs Rules |
| **RuleBasedScheduler** | Fallback - priority-based time slots |
| **PatternBasedMLService** | Smart scheduling using historical patterns |
| **ProductivityDataCollector** | Learning loop - records all user actions |
| **ProductivityData** | Training database for ML |

The beauty of this system is that it **starts smart** (rule-based) and **gets smarter** (ML-based) as the user uses the app. After about 10 task completions per goal, the ML takes over and starts optimizing based on when the user is actually most productive.
