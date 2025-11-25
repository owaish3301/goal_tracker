# 🧠 Goal Tracker Scheduling System - Architecture Document

## Version History
- **v1.0** (Current) - Hybrid scheduler with ML + Rule-based fallback
- **v2.0** (Planned) - Three-tier scheduler with User Profiling + Habit Formation

---

# CURRENT IMPLEMENTATION (v1.0)

## Overview

The app uses a **Hybrid Scheduling Architecture** that combines **Rule-Based Scheduling** (for new users or goals without enough data) and **Pattern-Based Machine Learning** (for goals with sufficient historical data).

## Architecture Diagram (v1.0)

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
```

## Current Limitations

| Issue | Impact |
|-------|--------|
| **Cold start problem** | Day 1 experience is generic (priority-based only) |
| **Fixed active hours (6AM-11PM)** | Doesn't adapt to night owls or early birds |
| **No user profiling** | Treats everyone the same initially |
| **No habit formation logic** | Doesn't optimize for consistency/streaks |

---

# PLANNED IMPLEMENTATION (v2.0)

## Goals for v2.0
1. **Wow from Day 1** - Personalized scheduling from first launch
2. **Adaptive Hours** - Learn and adjust to user's actual active hours
3. **Habit Formation** - Optimize for consistency and streak building
4. **Context Awareness** - Consider task order, energy levels, patterns

---

## Architecture Diagram (v2.0)

```
┌──────────────────────────────────────────────────────────────────────────┐
│                         HybridScheduler v2                                │
│                    (Three-Tier Decision Engine)                           │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                           │
│   ┌──────────────────┐   ┌───────────────────┐   ┌──────────────────┐   │
│   │   ML-Based       │   │  Profile-Based    │   │   Rule-Based     │   │
│   │   Scheduler      │ → │  Scheduler        │ → │   Scheduler      │   │
│   │                  │   │                   │   │                  │   │
│   │ • ≥10 completions│   │ • Chrono-type     │   │ • Priority-based │   │
│   │ • ≥60% confidence│   │ • Goal categories │   │ • Time-of-day    │   │
│   │ • Learned prefs  │   │ • User profile    │   │ • Simple fallback│   │
│   └──────────────────┘   └───────────────────┘   └──────────────────┘   │
│            ↑                       ↑                                      │
│   ┌──────────────────┐   ┌───────────────────┐                           │
│   │ ProductivityData │   │   UserProfile     │                           │
│   │ (ML Training)    │   │   (Onboarding)    │                           │
│   └──────────────────┘   └───────────────────┘                           │
│                                                                           │
│   ┌──────────────────────────────────────────────────────────────────┐   │
│   │                    HabitFormationService                          │   │
│   │  • Streak tracking    • Consistency scoring    • Anchor detection │   │
│   └──────────────────────────────────────────────────────────────────┘   │
│                                                                           │
│   ┌──────────────────────────────────────────────────────────────────┐   │
│   │                    DynamicTimeWindowService                       │   │
│   │  • Learns actual wake/sleep times    • Adapts active hours        │   │
│   └──────────────────────────────────────────────────────────────────┘   │
│                                                                           │
└──────────────────────────────────────────────────────────────────────────┘
```

---

## New Component 1: User Profile System

### Purpose
Know the user BEFORE scheduling. Enables "Wow from Day 1" personalization.

### UserProfile Model
```dart
class UserProfile {
  Id id = Isar.autoIncrement;
  
  // Chronotype (from onboarding)
  late int chronoType;  // 0=earlyBird, 1=normal, 2=nightOwl, 3=flexible
  
  // Sleep schedule
  late int wakeUpHour;      // Typical wake time (e.g., 7)
  late int sleepHour;       // Typical sleep time (e.g., 23)
  
  // Work/life boundaries
  int? workStartHour;       // Optional: when work starts
  int? workEndHour;         // Optional: when work ends
  List<int> busyDays = [];  // Days with less free time
  
  // Preferences
  late int preferredSessionLength;  // 0=short(15-30), 1=medium(30-60), 2=long(60+)
  late bool prefersRoutine;         // Likes same time daily vs variety
  
  // Onboarding completion
  late bool onboardingCompleted;
  late DateTime createdAt;
  DateTime? updatedAt;
}
```

### ChronoType Enum
```dart
enum ChronoType {
  earlyBird,    // Peak productivity: 6-10 AM
  normal,       // Peak productivity: 9 AM - 12 PM  
  nightOwl,     // Peak productivity: 8 PM - 12 AM
  flexible,     // No strong preference
}
```

### Time Preferences by ChronoType
```
Early Bird:
  High Priority   → 6:00 AM - 10:00 AM (peak focus)
  Medium Priority → 10:00 AM - 2:00 PM
  Low Priority    → 2:00 PM - 8:00 PM

Normal:
  High Priority   → 9:00 AM - 12:00 PM (peak focus)
  Medium Priority → 2:00 PM - 6:00 PM
  Low Priority    → 6:00 PM - 10:00 PM

Night Owl:
  High Priority   → 8:00 PM - 12:00 AM (peak focus)
  Medium Priority → 4:00 PM - 8:00 PM
  Low Priority    → 10:00 AM - 4:00 PM
```

---

## New Component 2: Goal Categories

### Purpose
Research-backed scheduling defaults based on goal type. Even without user data, we can make smart decisions.

### GoalCategory Enum
```dart
enum GoalCategory {
  exercise,      // Physical activity, workout, sports
  learning,      // Study, reading, courses, skill building
  creative,      // Art, writing, music, design
  work,          // Professional tasks, career
  wellness,      // Meditation, journaling, self-care
  social,        // Family time, relationships
  chores,        // Household tasks, errands
  other,         // Uncategorized
}
```

### Research-Backed Optimal Times
```dart
Map<GoalCategory, List<int>> categoryOptimalHours = {
  // Exercise: Morning has highest completion rates
  GoalCategory.exercise: [6, 7, 8, 17, 18, 19],
  
  // Learning: Best when well-rested, or evening review
  GoalCategory.learning: [9, 10, 11, 20, 21],
  
  // Creative: Often better in evening when mind wanders
  GoalCategory.creative: [20, 21, 22, 10, 11],
  
  // Work: Standard productive hours
  GoalCategory.work: [9, 10, 11, 14, 15, 16],
  
  // Wellness: Morning sets tone, or evening wind-down
  GoalCategory.wellness: [6, 7, 8, 21, 22],
  
  // Social: After work hours
  GoalCategory.social: [18, 19, 20],
  
  // Chores: Afternoon when energy dips anyway
  GoalCategory.chores: [14, 15, 16, 17],
};
```

---

## New Component 3: Dynamic Time Window

### Purpose
Adapt active hours based on actual user behavior, not just onboarding answers.

### DynamicTimeWindow Model
```dart
class DynamicTimeWindow {
  // Base from onboarding
  int baseWakeUpHour;
  int baseSleepHour;
  
  // Learned from behavior
  int? earliestSuccessfulHour;  // Earliest completion with 4+ rating
  int? latestSuccessfulHour;    // Latest completion with 4+ rating
  
  // Per-day adjustments (weekday vs weekend)
  Map<int, TimeWindow> daySpecificWindows;
  
  // Get active window for a specific day
  TimeWindow getActiveWindow(int dayOfWeek) {
    // Weekend might have different hours
    // Use learned data if available, else base
  }
}
```

### Learning Logic
```dart
void updateFromCompletion(ProductivityData data) {
  if (data.productivityScore >= 4.0) {
    // User was productive at this hour - valid active time
    if (data.hourOfDay < earliestSuccessfulHour) {
      earliestSuccessfulHour = data.hourOfDay;
    }
    if (data.hourOfDay > latestSuccessfulHour) {
      latestSuccessfulHour = data.hourOfDay;
    }
  }
}
```

---

## New Component 4: Habit Formation Service

### Purpose
Optimize for **consistency** and **habit building**, not just productivity scores.

### Key Metrics
```dart
class HabitMetrics {
  int goalId;
  
  // Streak tracking
  int currentStreak;           // Consecutive days completed
  int longestStreak;           // All-time best
  DateTime? lastCompletedDate;
  
  // Consistency scoring
  double consistencyScore;     // % of scheduled days completed
  double timeConsistency;      // How often completed at same time
  
  // Stickiness analysis
  int? stickyHour;            // Hour with highest completion rate
  int? stickyDayOfWeek;       // Day with highest completion rate
}
```

### Habit Formation Rules

1. **Consistency Over Optimization**
   ```
   IF user completes goal at 7 AM with 3.5 rating
   AND completion rate at 7 AM is 90%
   THEN keep scheduling at 7 AM
   
   WHY: A consistent habit beats an "optimal" time they skip
   ```

2. **Streak Protection**
   ```
   IF user has 14+ day streak
   THEN prioritize that goal's preferred time slot
   AND warn before breaking streak
   ```

3. **Anchor Detection**
   ```
   IF Exercise always completed within 30 min of waking
   THEN anchor Exercise to wake-up time (not fixed hour)
   
   IF Reading always completed after dinner
   THEN anchor Reading to evening (flexible slot)
   ```

4. **21-Day Habit Lock**
   ```
   IF goal completed 21+ days consecutively at same time
   THEN "lock" that time slot (require confirmation to change)
   AND badge: "Habit Formed! 🎯"
   ```

---

## New Component 5: Enhanced ML Features

### Additional ProductivityData Fields
```dart
// Add to ProductivityData model
late int taskOrderInDay;           // 1st, 2nd, 3rd task of the day
late int minutesSinceWakeUp;       // More meaningful than raw hour
late double? previousTaskRating;   // How did the task before go?
late int currentStreak;            // Motivation from streak
late double completionRateLast7Days;  // Recent momentum
late int totalTasksScheduledToday; // Load factor
late int tasksCompletedBeforeThis; // Fatigue factor
```

### Why These Matter
| Feature | Insight |
|---------|---------|
| `taskOrderInDay` | Some people excel at task #1 but struggle with task #4 |
| `minutesSinceWakeUp` | 9 AM means different things to early birds vs night owls |
| `previousTaskRating` | Bad task → lower energy for next task |
| `currentStreak` | Psychological momentum boosts completion |
| `completionRateLast7Days` | Recent slump? Schedule easier tasks |

---

## Three-Tier Scheduling Flow

```
┌──────────────────────────────────────────────────────────────────┐
│  For each goal to schedule:                                       │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  1. CHECK ML AVAILABILITY                                         │
│     └─→ hasEnoughData(goalId) >= 10?                             │
│         └─→ YES: Get ML prediction                               │
│             └─→ confidence >= 60%?                               │
│                 └─→ YES: ✅ Use ML-based scheduling              │
│                 └─→ NO: Continue to Tier 2                       │
│         └─→ NO: Continue to Tier 2                               │
│                                                                   │
│  2. CHECK USER PROFILE                                            │
│     └─→ onboardingCompleted?                                     │
│         └─→ YES: Get profile-based time preference               │
│             └─→ Consider: chronoType + goalCategory              │
│             └─→ ✅ Use Profile-based scheduling                  │
│         └─→ NO: Continue to Tier 3                               │
│                                                                   │
│  3. RULE-BASED FALLBACK                                          │
│     └─→ Use priority-based scheduling                            │
│         └─→ High priority → Morning                              │
│         └─→ Medium priority → Afternoon                          │
│         └─→ Low priority → Evening                               │
│         └─→ ✅ Use Rule-based scheduling                         │
│                                                                   │
│  4. HABIT FORMATION OVERLAY                                       │
│     └─→ After scheduling, check HabitFormationService            │
│         └─→ Has sticky time? → Prefer that slot                  │
│         └─→ Has active streak? → Protect that slot               │
│         └─→ 21+ day habit? → Lock that slot                      │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

---

## Onboarding Flow

### Screen 1: Welcome
```
"Let's personalize your schedule!"
"Answer a few quick questions so we can help you 
build habits that stick."
[Get Started]
```

### Screen 2: Chronotype
```
"When do you feel most productive?"

🌅 Early Bird (I'm most alert in the morning)
☀️ Daytime (I peak mid-morning to early afternoon)  
🌙 Night Owl (I come alive in the evening)
🔄 Flexible (It varies day to day)
```

### Screen 3: Sleep Schedule
```
"What time do you usually..."

Wake up: [7:00 AM ▼]
Go to sleep: [11:00 PM ▼]

(We'll avoid scheduling during your sleep hours!)
```

### Screen 4: Session Preference
```
"How do you prefer to work?"

⚡ Short bursts (15-30 minutes)
⏱️ Medium sessions (30-60 minutes)
🎯 Long focus blocks (60+ minutes)
```

### Screen 5: Work Schedule (Optional)
```
"Do you have fixed work/school hours?"

[ ] Yes, I have a regular schedule
    Start: [9:00 AM ▼]  End: [5:00 PM ▼]
    
[ ] No, my schedule is flexible
```

### Screen 6: Completion
```
"Perfect! You're all set. 🎉"

"Your schedule will be optimized for:
✓ [ChronoType] productivity patterns
✓ [Session length] focus sessions
✓ Avoiding [work hours] conflicts

As you use the app, we'll learn even more 
about when you work best!"

[Start Using Goal Tracker]
```

---

## File Reference (v2.0 - Planned)

### New Files to Create
| File | Purpose |
|------|---------|
| `lib/data/models/user_profile.dart` | UserProfile Isar model |
| `lib/data/models/habit_metrics.dart` | HabitMetrics Isar model |
| `lib/data/repositories/user_profile_repository.dart` | Profile CRUD |
| `lib/data/repositories/habit_metrics_repository.dart` | Habits CRUD |
| `lib/core/services/profile_based_scheduler.dart` | Tier 2 scheduler |
| `lib/core/services/habit_formation_service.dart` | Streak/consistency |
| `lib/core/services/dynamic_time_window_service.dart` | Adaptive hours |
| `lib/features/onboarding/` | Onboarding UI screens |

### Files to Modify
| File | Changes |
|------|---------|
| `lib/data/models/goal.dart` | Add `category` field |
| `lib/data/models/productivity_data.dart` | Add new ML features |
| `lib/core/services/hybrid_scheduler.dart` | Add Tier 2, habit overlay |
| `lib/features/goals/presentation/widgets/goal_form.dart` | Category selector |

---

## Summary: v1.0 vs v2.0

| Aspect | v1.0 (Current) | v2.0 (Planned) |
|--------|----------------|----------------|
| Day 1 Experience | Generic (priority-based) | Personalized (chrono-type + category) |
| Active Hours | Fixed 6AM-11PM | Dynamic, learned from behavior |
| Scheduling Tiers | 2 (ML → Rules) | 3 (ML → Profile → Rules) |
| Habit Support | None | Streaks, consistency, anchors |
| User Knowledge | None until 10+ completions | Onboarding + continuous learning |
| Goal Categories | None | 8 categories with research-backed times |

---

## Implementation Priority

| Priority | Component | Impact | Dependencies |
|----------|-----------|--------|--------------|
| 🔴 P0 | UserProfile model + repository | Foundation | None |
| 🔴 P0 | Goal category field | Smart defaults | None |
| 🔴 P0 | Onboarding UI flow | Day 1 personalization | UserProfile |
| 🟡 P1 | ProfileBasedScheduler | Tier 2 scheduling | UserProfile, Categories |
| 🟡 P1 | HabitMetrics model + service | Streak tracking | None |
| 🟡 P1 | Enhanced ProductivityData fields | Better ML | None |
| 🟢 P2 | DynamicTimeWindowService | Adaptive hours | ProductivityData |
| 🟢 P2 | Habit Formation overlay | Consistency optimization | HabitMetrics |
| 🟢 P2 | 21-day habit lock feature | Retention | HabitMetrics |
