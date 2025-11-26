import '../../../data/models/one_time_task.dart';
import '../../../data/models/scheduled_task.dart';
import '../../../data/models/goal.dart';

/// Unified timeline item that can be either a OneTimeTask or ScheduledTask
class TimelineItem {
  final String id;
  final String title;
  final DateTime scheduledTime;
  final int duration;
  final String colorHex;
  final String? iconName;
  final bool isCompleted;
  final TimelineItemType type;
  final dynamic originalTask; // Stores the original task object

  TimelineItem({
    required this.id,
    required this.title,
    required this.scheduledTime,
    required this.duration,
    required this.colorHex,
    this.iconName,
    required this.isCompleted,
    required this.type,
    required this.originalTask,
  });

  /// Create from OneTimeTask
  factory TimelineItem.fromOneTimeTask(OneTimeTask task) {
    return TimelineItem(
      id: 'ott_${task.id}',
      title: task.title,
      scheduledTime: task.scheduledStartTime,
      duration: task.duration,
      colorHex: task.colorHex ?? '#C6F432',
      iconName: null,
      isCompleted: task.isCompleted,
      type: TimelineItemType.oneTime,
      originalTask: task,
    );
  }

  /// Create from ScheduledTask
  factory TimelineItem.fromScheduledTask(ScheduledTask task) {
    return TimelineItem(
      id: 'st_${task.id}',
      title: task.title,
      scheduledTime: task.scheduledStartTime,
      duration: task.duration,
      colorHex: task.colorHex ?? '#C6F432',
      iconName: task.iconName,
      isCompleted: task.isCompleted,
      type: TimelineItemType.scheduled,
      originalTask: task,
    );
  }

  /// Get the original task as OneTimeTask (if applicable)
  OneTimeTask? get asOneTimeTask =>
      type == TimelineItemType.oneTime ? originalTask as OneTimeTask : null;

  /// Get the original task as ScheduledTask (if applicable)
  ScheduledTask? get asScheduledTask =>
      type == TimelineItemType.scheduled ? originalTask as ScheduledTask : null;

  /// Get the original goal (for preview items)
  Goal? get asGoal =>
      type == TimelineItemType.preview ? originalTask as Goal : null;

  /// Create from Goal for future date preview (no schedule generated yet)
  factory TimelineItem.fromGoalPreview(Goal goal) {
    return TimelineItem(
      id: 'preview_${goal.id}',
      title: goal.title,
      scheduledTime: DateTime(2099), // Placeholder - preview items have no time
      duration: goal.targetDuration,
      colorHex: goal.colorHex,
      iconName: goal.iconName,
      isCompleted: false,
      type: TimelineItemType.preview,
      originalTask: goal,
    );
  }
}

enum TimelineItemType { oneTime, scheduled, preview }
