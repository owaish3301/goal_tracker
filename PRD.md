# Project Name: Goal Tracker - Intelligent Offline Scheduler

## 1. Executive Summary
An offline-first, privacy-centric productivity app that uses on-device Machine Learning to automatically generate daily schedules based on user goals. Unlike standard to-do lists, this app **learns** from the user's completion habits and productivity ratings to optimize *when* tasks are scheduled, without ever sending data to the cloud.

**Core Philosophy:** Privacy + Adaptation. The app adapts to the user, not the other way around.

---

## 2. Core Feature Modules

### Module A: Goal Management (The Input)
Users define "Macro Goals" which the app uses to generate "Micro Todos."

* **Create Goal:**
    * **Title:** (e.g., "Learn Java", "Gym")
    * **Frequency:** Days of the week (e.g., Mon-Sat, or Everyday).
    * **Target Duration:** How long per session? (e.g., 3 hours, 1 hour).
    * **Color/Icon:** For UI categorization.
    * **Priority:** A draggable list where top items take precedence in scheduling.
* **Syllabus/Milestones (Offline Breakdown):**
    * Since we have no AI API to break goals down, allow users to create a manual checklist inside a Goal (e.g., "Chapter 1", "Chapter 2").
    * *Logic:* The daily todo displays the next unchecked item from this list as the "Focus" for that session.

### Module B: The Daily Scheduler (The Engine)
The app automatically populates the "Today" view every morning (or at midnight).

* **Input:** Active Goals + One-time Tasks + Historical User Data.
* **Logic Flow:**
    1.  **Hard Constraints:** Place "One-time Tasks" (e.g., Laundry at 2 PM) first. These slots are locked.
    2.  **Priority Sort:** Rank remaining Goals based on the user's drag-and-drop preference.
    3.  **ML Assignment:** For the highest priority goal, find the available time slot with the highest predicted "Productivity Score."
    4.  **Conflict Resolution:** If no slot fits the full duration, notify the user or split the session (optional V2 feature).

### Module C: The Feedback Loop (The Training)
This is how the app gets smarter. This modal triggers when a user marks a task as "Done."

* **Trigger:** Swipe right or tap checkbox on a task.
* **Data Entry Modal (Bottom Sheet):**
    * **Actual Start Time:** Pre-fill based on current time minus duration. *Editable.*
    * **Actual Duration:** Pre-fill based on goal setting. *Editable.*
    * **Productivity Rating:** A simple input (1 to 5 stars/emojis) answering: "How focused were you?"
    * **Notes:** A text field for "What I learned today" or session notes. These are saved locally under the specific Goal's history.
    * **Next Milestone:** Option to check off the specific sub-task (e.g., "Finished Chapter 1").

### Module D: One-Time Tasks (The Exceptions)
Users can add tasks that are *not* goals.

* **Feature:** "Add Event" button.
* **Fields:** Title (e.g., Laundry), Date, Start Time, Duration.
* **Impact:** These act as "Blockers" for the auto-scheduler. The app knows *not* to schedule Gym during Laundry time.

---

## 3. The "Offline Brain" (ML & Logic Specification)

*Note to Developers: This system uses On-Device Learning (e.g., TensorFlow Lite or CoreML).*

### The Model
A lightweight Regression Model or weighted scoring algorithm.
* **Inputs (Features):**
    * Time of Day (Hour buckets: 0-23).
    * Day of Week (0-6).
    * Goal Type ID.
* **Output (Label):**
    * Productivity Score (0.0 - 5.0).

### The "Auto-Correction" Behavior
* **Scenario:** User drags an auto-scheduled "Gym" task from 8:00 AM to 6:00 PM.
* **Logic:** The app records this move. If the user completes it at 6:00 PM and rates it "High Productivity," the model updates weights to prefer Evening slots for "Gym" in the future.
* **Pre-filling:** When the user opens the "Done" modal, pre-fill the start time based on when they clicked the button. (e.g., Clicked at 9:00 PM for a 1hr task -> Pre-fill Start Time: 8:00 PM).

---

## 4. UI/UX Guidelines
*Reference: The dark-mode timeline concept provided.*

* **Visual Style:** High contrast, dark mode, neon accents for active tasks.
* **Home Screen (Timeline):**
    * Vertical scrolling timeline.
    * **Past Tasks:** Dimmed/Grayed out.
    * **Current Task:** Highlighted/Expanded.
    * **Future Tasks:** Visible but standard contrast.
* **Drag & Drop:**
    * **Priority Screen:** List view where users drag goals up/down to set hierarchy.
    * **Timeline:** Long-press a task to drag it to a new time slot.
* **Gestures:**
    * Swipe Right on Task: Mark Done.
    * Swipe Left on Task: Edit/Reschedule.

---

## 5. Data & Tech Stack (Offline Architecture)

### Database (Local Only)
* **Technology:** Room (Android) / CoreData (iOS) / Isar or Hive (Flutter).
* **Privacy:** No cloud sync. All data stays in the app's sandbox. Backup is handled by the OS standard backup (iCloud/Google Drive) as a binary file, not a database sync.

### Data Structure
1.  **Goals Table:** (ID, Name, DefaultDuration, PriorityIndex, FrequencyArr)
2.  **Tasks Table:** (ID, GoalID, ScheduledTime, ActualTime, ProductivityScore, Note, Status)
3.  **ModelWeights:** (Binary file or table storing the learned preferences for time slots).

---

## 6. Future Roadmap (V2 Ideas)
* **Statistics Dashboard:** Graphs showing "Most Productive Time of Day" or "Streak Counter."
* **Habit Stacking:** If a user always does Goal B immediately after Goal A, the app learns to schedule them back-to-back.

---

## 7. Platform & Technology Stack

### Platform
* **Primary Target:** Android (Flutter)
* **Database:** Isar (high-performance local database for Flutter)
* **ML Framework:** TensorFlow Lite for Flutter
* **State Management:** Riverpod or Bloc
* **UI Framework:** Flutter Material Design 3

### Development Approach
* Offline-first architecture
* Privacy-focused (no cloud dependencies)
* On-device machine learning
* Responsive dark-mode UI with modern aesthetics
