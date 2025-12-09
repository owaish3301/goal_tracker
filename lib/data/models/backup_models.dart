import 'dart:convert';
import 'goal.dart';
import 'milestone.dart';
import 'one_time_task.dart';
import 'scheduled_task.dart';
import 'task.dart';
import 'productivity_data.dart';
import 'habit_metrics.dart';
import 'user_profile.dart';
import 'app_settings.dart';
import 'daily_activity_log.dart';
import 'goal_category.dart';

/// Container for all backup data
class BackupData {
  final String version;
  final DateTime createdAt;
  final List<GoalBackup> goals;
  final List<MilestoneBackup> milestones;
  final List<OneTimeTaskBackup> oneTimeTasks;
  final List<ScheduledTaskBackup> scheduledTasks;
  final List<TaskBackup> tasks;
  final List<ProductivityDataBackup> productivityData;
  final List<HabitMetricsBackup> habitMetrics;
  final UserProfileBackup? userProfile;
  final AppSettingsBackup? appSettings;
  final List<DailyActivityLogBackup> dailyActivityLogs;

  BackupData({
    required this.version,
    required this.createdAt,
    required this.goals,
    required this.milestones,
    required this.oneTimeTasks,
    required this.scheduledTasks,
    required this.tasks,
    required this.productivityData,
    required this.habitMetrics,
    this.userProfile,
    this.appSettings,
    required this.dailyActivityLogs,
  });

  Map<String, dynamic> toJson() => {
    'version': version,
    'createdAt': createdAt.toIso8601String(),
    'goals': goals.map((g) => g.toJson()).toList(),
    'milestones': milestones.map((m) => m.toJson()).toList(),
    'oneTimeTasks': oneTimeTasks.map((t) => t.toJson()).toList(),
    'scheduledTasks': scheduledTasks.map((t) => t.toJson()).toList(),
    'tasks': tasks.map((t) => t.toJson()).toList(),
    'productivityData': productivityData.map((p) => p.toJson()).toList(),
    'habitMetrics': habitMetrics.map((h) => h.toJson()).toList(),
    'userProfile': userProfile?.toJson(),
    'appSettings': appSettings?.toJson(),
    'dailyActivityLogs': dailyActivityLogs.map((d) => d.toJson()).toList(),
  };

  factory BackupData.fromJson(Map<String, dynamic> json) => BackupData(
    version: json['version'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    goals: (json['goals'] as List).map((g) => GoalBackup.fromJson(g)).toList(),
    milestones: (json['milestones'] as List)
        .map((m) => MilestoneBackup.fromJson(m))
        .toList(),
    oneTimeTasks: (json['oneTimeTasks'] as List)
        .map((t) => OneTimeTaskBackup.fromJson(t))
        .toList(),
    scheduledTasks: (json['scheduledTasks'] as List)
        .map((t) => ScheduledTaskBackup.fromJson(t))
        .toList(),
    tasks: (json['tasks'] as List).map((t) => TaskBackup.fromJson(t)).toList(),
    productivityData: (json['productivityData'] as List)
        .map((p) => ProductivityDataBackup.fromJson(p))
        .toList(),
    habitMetrics: (json['habitMetrics'] as List)
        .map((h) => HabitMetricsBackup.fromJson(h))
        .toList(),
    userProfile: json['userProfile'] != null
        ? UserProfileBackup.fromJson(json['userProfile'])
        : null,
    appSettings: json['appSettings'] != null
        ? AppSettingsBackup.fromJson(json['appSettings'])
        : null,
    dailyActivityLogs:
        (json['dailyActivityLogs'] as List?)
            ?.map((d) => DailyActivityLogBackup.fromJson(d))
            .toList() ??
        [],
  );

  String toJsonString() => const JsonEncoder.withIndent('  ').convert(toJson());

  factory BackupData.fromJsonString(String jsonString) =>
      BackupData.fromJson(json.decode(jsonString) as Map<String, dynamic>);
}

// ============ GOAL BACKUP ============

class GoalBackup {
  final int id;
  final String title;
  final List<int> frequency;
  final int targetDuration;
  final int priorityIndex;
  final String category;
  final String colorHex;
  final String iconName;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  GoalBackup({
    required this.id,
    required this.title,
    required this.frequency,
    required this.targetDuration,
    required this.priorityIndex,
    required this.category,
    required this.colorHex,
    required this.iconName,
    required this.createdAt,
    this.updatedAt,
    required this.isActive,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'frequency': frequency,
    'targetDuration': targetDuration,
    'priorityIndex': priorityIndex,
    'category': category,
    'colorHex': colorHex,
    'iconName': iconName,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'isActive': isActive,
  };

  factory GoalBackup.fromJson(Map<String, dynamic> json) => GoalBackup(
    id: json['id'] as int,
    title: json['title'] as String,
    frequency: (json['frequency'] as List).cast<int>(),
    targetDuration: json['targetDuration'] as int,
    priorityIndex: json['priorityIndex'] as int,
    category: json['category'] as String,
    colorHex: json['colorHex'] as String,
    iconName: json['iconName'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'] as String)
        : null,
    isActive: json['isActive'] as bool,
  );

  factory GoalBackup.fromModel(Goal goal) => GoalBackup(
    id: goal.id,
    title: goal.title,
    frequency: goal.frequency,
    targetDuration: goal.targetDuration,
    priorityIndex: goal.priorityIndex,
    category: goal.category.name,
    colorHex: goal.colorHex,
    iconName: goal.iconName,
    createdAt: goal.createdAt,
    updatedAt: goal.updatedAt,
    isActive: goal.isActive,
  );

  Goal toModel() {
    return Goal()
      ..id = id
      ..title = title
      ..frequency = frequency
      ..targetDuration = targetDuration
      ..priorityIndex = priorityIndex
      ..category = GoalCategory.values.firstWhere(
        (c) => c.name == category,
        orElse: () => GoalCategory.other,
      )
      ..colorHex = colorHex
      ..iconName = iconName
      ..createdAt = createdAt
      ..updatedAt = updatedAt
      ..isActive = isActive;
  }
}

// ============ MILESTONE BACKUP ============

class MilestoneBackup {
  final int id;
  final String title;
  final int orderIndex;
  final bool isCompleted;
  final DateTime? completedAt;
  final int? goalId;

  MilestoneBackup({
    required this.id,
    required this.title,
    required this.orderIndex,
    required this.isCompleted,
    this.completedAt,
    this.goalId,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'orderIndex': orderIndex,
    'isCompleted': isCompleted,
    'completedAt': completedAt?.toIso8601String(),
    'goalId': goalId,
  };

  factory MilestoneBackup.fromJson(Map<String, dynamic> json) =>
      MilestoneBackup(
        id: json['id'] as int,
        title: json['title'] as String,
        orderIndex: json['orderIndex'] as int,
        isCompleted: json['isCompleted'] as bool,
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'] as String)
            : null,
        goalId: json['goalId'] as int?,
      );

  factory MilestoneBackup.fromModel(Milestone milestone) => MilestoneBackup(
    id: milestone.id,
    title: milestone.title,
    orderIndex: milestone.orderIndex,
    isCompleted: milestone.isCompleted,
    completedAt: milestone.completedAt,
    goalId: milestone.goal.value?.id,
  );

  Milestone toModel() {
    return Milestone()
      ..id = id
      ..title = title
      ..orderIndex = orderIndex
      ..isCompleted = isCompleted
      ..completedAt = completedAt;
  }
}

// ============ ONE TIME TASK BACKUP ============

class OneTimeTaskBackup {
  final int id;
  final String title;
  final DateTime scheduledDate;
  final DateTime scheduledStartTime;
  final int duration;
  final String? notes;
  final String? colorHex;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? completedAt;

  OneTimeTaskBackup({
    required this.id,
    required this.title,
    required this.scheduledDate,
    required this.scheduledStartTime,
    required this.duration,
    this.notes,
    this.colorHex,
    required this.isCompleted,
    required this.createdAt,
    this.completedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'scheduledDate': scheduledDate.toIso8601String(),
    'scheduledStartTime': scheduledStartTime.toIso8601String(),
    'duration': duration,
    'notes': notes,
    'colorHex': colorHex,
    'isCompleted': isCompleted,
    'createdAt': createdAt.toIso8601String(),
    'completedAt': completedAt?.toIso8601String(),
  };

  factory OneTimeTaskBackup.fromJson(Map<String, dynamic> json) =>
      OneTimeTaskBackup(
        id: json['id'] as int,
        title: json['title'] as String,
        scheduledDate: DateTime.parse(json['scheduledDate'] as String),
        scheduledStartTime: DateTime.parse(
          json['scheduledStartTime'] as String,
        ),
        duration: json['duration'] as int,
        notes: json['notes'] as String?,
        colorHex: json['colorHex'] as String?,
        isCompleted: json['isCompleted'] as bool,
        createdAt: DateTime.parse(json['createdAt'] as String),
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'] as String)
            : null,
      );

  factory OneTimeTaskBackup.fromModel(OneTimeTask task) => OneTimeTaskBackup(
    id: task.id,
    title: task.title,
    scheduledDate: task.scheduledDate,
    scheduledStartTime: task.scheduledStartTime,
    duration: task.duration,
    notes: task.notes,
    colorHex: task.colorHex,
    isCompleted: task.isCompleted,
    createdAt: task.createdAt,
    completedAt: task.completedAt,
  );

  OneTimeTask toModel() {
    return OneTimeTask()
      ..id = id
      ..title = title
      ..scheduledDate = scheduledDate
      ..scheduledStartTime = scheduledStartTime
      ..duration = duration
      ..notes = notes
      ..colorHex = colorHex
      ..isCompleted = isCompleted
      ..createdAt = createdAt
      ..completedAt = completedAt;
  }
}

// ============ SCHEDULED TASK BACKUP ============

class ScheduledTaskBackup {
  final int id;
  final int goalId;
  final DateTime scheduledDate;
  final DateTime scheduledStartTime;
  final int duration;
  final String title;
  final String? colorHex;
  final String? iconName;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime originalScheduledTime;
  final String schedulingMethod;
  final double? mlConfidence;
  final DateTime? actualStartTime;
  final int? actualDuration;
  final int? productivityRating;
  final String? completionNotes;
  final bool wasRescheduled;
  final DateTime? rescheduledTo;
  final int rescheduleCount;
  final int? milestoneId;
  final bool? milestoneCompleted;
  final DateTime createdAt;
  final bool isAutoGenerated;
  final String? schedulingReason;

  ScheduledTaskBackup({
    required this.id,
    required this.goalId,
    required this.scheduledDate,
    required this.scheduledStartTime,
    required this.duration,
    required this.title,
    this.colorHex,
    this.iconName,
    required this.isCompleted,
    this.completedAt,
    required this.originalScheduledTime,
    required this.schedulingMethod,
    this.mlConfidence,
    this.actualStartTime,
    this.actualDuration,
    this.productivityRating,
    this.completionNotes,
    required this.wasRescheduled,
    this.rescheduledTo,
    required this.rescheduleCount,
    this.milestoneId,
    this.milestoneCompleted,
    required this.createdAt,
    required this.isAutoGenerated,
    this.schedulingReason,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'goalId': goalId,
    'scheduledDate': scheduledDate.toIso8601String(),
    'scheduledStartTime': scheduledStartTime.toIso8601String(),
    'duration': duration,
    'title': title,
    'colorHex': colorHex,
    'iconName': iconName,
    'isCompleted': isCompleted,
    'completedAt': completedAt?.toIso8601String(),
    'originalScheduledTime': originalScheduledTime.toIso8601String(),
    'schedulingMethod': schedulingMethod,
    'mlConfidence': mlConfidence,
    'actualStartTime': actualStartTime?.toIso8601String(),
    'actualDuration': actualDuration,
    'productivityRating': productivityRating,
    'completionNotes': completionNotes,
    'wasRescheduled': wasRescheduled,
    'rescheduledTo': rescheduledTo?.toIso8601String(),
    'rescheduleCount': rescheduleCount,
    'milestoneId': milestoneId,
    'milestoneCompleted': milestoneCompleted,
    'createdAt': createdAt.toIso8601String(),
    'isAutoGenerated': isAutoGenerated,
    'schedulingReason': schedulingReason,
  };

  factory ScheduledTaskBackup.fromJson(Map<String, dynamic> json) =>
      ScheduledTaskBackup(
        id: json['id'] as int,
        goalId: json['goalId'] as int,
        scheduledDate: DateTime.parse(json['scheduledDate'] as String),
        scheduledStartTime: DateTime.parse(
          json['scheduledStartTime'] as String,
        ),
        duration: json['duration'] as int,
        title: json['title'] as String,
        colorHex: json['colorHex'] as String?,
        iconName: json['iconName'] as String?,
        isCompleted: json['isCompleted'] as bool,
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'] as String)
            : null,
        originalScheduledTime: DateTime.parse(
          json['originalScheduledTime'] as String,
        ),
        schedulingMethod: json['schedulingMethod'] as String,
        mlConfidence: (json['mlConfidence'] as num?)?.toDouble(),
        actualStartTime: json['actualStartTime'] != null
            ? DateTime.parse(json['actualStartTime'] as String)
            : null,
        actualDuration: json['actualDuration'] as int?,
        productivityRating: json['productivityRating'] as int?,
        completionNotes: json['completionNotes'] as String?,
        wasRescheduled: json['wasRescheduled'] as bool,
        rescheduledTo: json['rescheduledTo'] != null
            ? DateTime.parse(json['rescheduledTo'] as String)
            : null,
        rescheduleCount: json['rescheduleCount'] as int,
        milestoneId: json['milestoneId'] as int?,
        milestoneCompleted: json['milestoneCompleted'] as bool?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        isAutoGenerated: json['isAutoGenerated'] as bool,
        schedulingReason: json['schedulingReason'] as String?,
      );

  factory ScheduledTaskBackup.fromModel(ScheduledTask task) =>
      ScheduledTaskBackup(
        id: task.id,
        goalId: task.goalId,
        scheduledDate: task.scheduledDate,
        scheduledStartTime: task.scheduledStartTime,
        duration: task.duration,
        title: task.title,
        colorHex: task.colorHex,
        iconName: task.iconName,
        isCompleted: task.isCompleted,
        completedAt: task.completedAt,
        originalScheduledTime: task.originalScheduledTime,
        schedulingMethod: task.schedulingMethod,
        mlConfidence: task.mlConfidence,
        actualStartTime: task.actualStartTime,
        actualDuration: task.actualDuration,
        productivityRating: task.productivityRating,
        completionNotes: task.completionNotes,
        wasRescheduled: task.wasRescheduled,
        rescheduledTo: task.rescheduledTo,
        rescheduleCount: task.rescheduleCount,
        milestoneId: task.milestoneId,
        milestoneCompleted: task.milestoneCompleted,
        createdAt: task.createdAt,
        isAutoGenerated: task.isAutoGenerated,
        schedulingReason: task.schedulingReason,
      );

  ScheduledTask toModel() {
    return ScheduledTask()
      ..id = id
      ..goalId = goalId
      ..scheduledDate = scheduledDate
      ..scheduledStartTime = scheduledStartTime
      ..duration = duration
      ..title = title
      ..colorHex = colorHex
      ..iconName = iconName
      ..isCompleted = isCompleted
      ..completedAt = completedAt
      ..originalScheduledTime = originalScheduledTime
      ..schedulingMethod = schedulingMethod
      ..mlConfidence = mlConfidence
      ..actualStartTime = actualStartTime
      ..actualDuration = actualDuration
      ..productivityRating = productivityRating
      ..completionNotes = completionNotes
      ..wasRescheduled = wasRescheduled
      ..rescheduledTo = rescheduledTo
      ..rescheduleCount = rescheduleCount
      ..milestoneId = milestoneId
      ..milestoneCompleted = milestoneCompleted
      ..createdAt = createdAt
      ..isAutoGenerated = isAutoGenerated
      ..schedulingReason = schedulingReason;
  }
}

// ============ TASK BACKUP ============

class TaskBackup {
  final int id;
  final DateTime scheduledDate;
  final DateTime scheduledStartTime;
  final int scheduledDuration;
  final DateTime? actualStartTime;
  final int? actualDuration;
  final double? productivityScore;
  final String? notes;
  final String status;
  final int? goalId;
  final DateTime createdAt;
  final DateTime? completedAt;
  final bool wasManuallyRescheduled;
  final DateTime? originalScheduledTime;

  TaskBackup({
    required this.id,
    required this.scheduledDate,
    required this.scheduledStartTime,
    required this.scheduledDuration,
    this.actualStartTime,
    this.actualDuration,
    this.productivityScore,
    this.notes,
    required this.status,
    this.goalId,
    required this.createdAt,
    this.completedAt,
    required this.wasManuallyRescheduled,
    this.originalScheduledTime,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'scheduledDate': scheduledDate.toIso8601String(),
    'scheduledStartTime': scheduledStartTime.toIso8601String(),
    'scheduledDuration': scheduledDuration,
    'actualStartTime': actualStartTime?.toIso8601String(),
    'actualDuration': actualDuration,
    'productivityScore': productivityScore,
    'notes': notes,
    'status': status,
    'goalId': goalId,
    'createdAt': createdAt.toIso8601String(),
    'completedAt': completedAt?.toIso8601String(),
    'wasManuallyRescheduled': wasManuallyRescheduled,
    'originalScheduledTime': originalScheduledTime?.toIso8601String(),
  };

  factory TaskBackup.fromJson(Map<String, dynamic> json) => TaskBackup(
    id: json['id'] as int,
    scheduledDate: DateTime.parse(json['scheduledDate'] as String),
    scheduledStartTime: DateTime.parse(json['scheduledStartTime'] as String),
    scheduledDuration: json['scheduledDuration'] as int,
    actualStartTime: json['actualStartTime'] != null
        ? DateTime.parse(json['actualStartTime'] as String)
        : null,
    actualDuration: json['actualDuration'] as int?,
    productivityScore: (json['productivityScore'] as num?)?.toDouble(),
    notes: json['notes'] as String?,
    status: json['status'] as String,
    goalId: json['goalId'] as int?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    completedAt: json['completedAt'] != null
        ? DateTime.parse(json['completedAt'] as String)
        : null,
    wasManuallyRescheduled: json['wasManuallyRescheduled'] as bool,
    originalScheduledTime: json['originalScheduledTime'] != null
        ? DateTime.parse(json['originalScheduledTime'] as String)
        : null,
  );

  factory TaskBackup.fromModel(Task task) => TaskBackup(
    id: task.id,
    scheduledDate: task.scheduledDate,
    scheduledStartTime: task.scheduledStartTime,
    scheduledDuration: task.scheduledDuration,
    actualStartTime: task.actualStartTime,
    actualDuration: task.actualDuration,
    productivityScore: task.productivityScore,
    notes: task.notes,
    status: task.status.name,
    goalId: task.goal.value?.id,
    createdAt: task.createdAt,
    completedAt: task.completedAt,
    wasManuallyRescheduled: task.wasManuallyRescheduled,
    originalScheduledTime: task.originalScheduledTime,
  );

  Task toModel() {
    return Task()
      ..id = id
      ..scheduledDate = scheduledDate
      ..scheduledStartTime = scheduledStartTime
      ..scheduledDuration = scheduledDuration
      ..actualStartTime = actualStartTime
      ..actualDuration = actualDuration
      ..productivityScore = productivityScore
      ..notes = notes
      ..status = TaskStatus.values.firstWhere(
        (s) => s.name == status,
        orElse: () => TaskStatus.pending,
      )
      ..createdAt = createdAt
      ..completedAt = completedAt
      ..wasManuallyRescheduled = wasManuallyRescheduled
      ..originalScheduledTime = originalScheduledTime;
  }
}

// ============ PRODUCTIVITY DATA BACKUP ============

class ProductivityDataBackup {
  final int id;
  final int goalId;
  final int hourOfDay;
  final int dayOfWeek;
  final int duration;
  final int timeSlotType;
  final bool hadPriorTask;
  final bool hadFollowingTask;
  final int weekOfYear;
  final bool isWeekend;
  final double productivityScore;
  final bool wasRescheduled;
  final bool wasCompleted;
  final int actualDurationMinutes;
  final int minutesFromScheduled;
  final DateTime recordedAt;
  final int scheduledTaskId;
  final int taskOrderInDay;
  final int totalTasksScheduledToday;
  final int tasksCompletedBeforeThis;
  final double relativeTimeInDay;
  final int minutesSinceFirstActivity;
  final double previousTaskRating;
  final double completionRateLast7Days;
  final int currentStreakAtCompletion;
  final double goalConsistencyScore;
  final int consecutiveTasksCompleted;
  final int minutesSinceLastCompletion;

  ProductivityDataBackup({
    required this.id,
    required this.goalId,
    required this.hourOfDay,
    required this.dayOfWeek,
    required this.duration,
    required this.timeSlotType,
    required this.hadPriorTask,
    required this.hadFollowingTask,
    required this.weekOfYear,
    required this.isWeekend,
    required this.productivityScore,
    required this.wasRescheduled,
    required this.wasCompleted,
    required this.actualDurationMinutes,
    required this.minutesFromScheduled,
    required this.recordedAt,
    required this.scheduledTaskId,
    required this.taskOrderInDay,
    required this.totalTasksScheduledToday,
    required this.tasksCompletedBeforeThis,
    required this.relativeTimeInDay,
    required this.minutesSinceFirstActivity,
    required this.previousTaskRating,
    required this.completionRateLast7Days,
    required this.currentStreakAtCompletion,
    required this.goalConsistencyScore,
    required this.consecutiveTasksCompleted,
    required this.minutesSinceLastCompletion,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'goalId': goalId,
    'hourOfDay': hourOfDay,
    'dayOfWeek': dayOfWeek,
    'duration': duration,
    'timeSlotType': timeSlotType,
    'hadPriorTask': hadPriorTask,
    'hadFollowingTask': hadFollowingTask,
    'weekOfYear': weekOfYear,
    'isWeekend': isWeekend,
    'productivityScore': productivityScore,
    'wasRescheduled': wasRescheduled,
    'wasCompleted': wasCompleted,
    'actualDurationMinutes': actualDurationMinutes,
    'minutesFromScheduled': minutesFromScheduled,
    'recordedAt': recordedAt.toIso8601String(),
    'scheduledTaskId': scheduledTaskId,
    'taskOrderInDay': taskOrderInDay,
    'totalTasksScheduledToday': totalTasksScheduledToday,
    'tasksCompletedBeforeThis': tasksCompletedBeforeThis,
    'relativeTimeInDay': relativeTimeInDay,
    'minutesSinceFirstActivity': minutesSinceFirstActivity,
    'previousTaskRating': previousTaskRating,
    'completionRateLast7Days': completionRateLast7Days,
    'currentStreakAtCompletion': currentStreakAtCompletion,
    'goalConsistencyScore': goalConsistencyScore,
    'consecutiveTasksCompleted': consecutiveTasksCompleted,
    'minutesSinceLastCompletion': minutesSinceLastCompletion,
  };

  factory ProductivityDataBackup.fromJson(
    Map<String, dynamic> json,
  ) => ProductivityDataBackup(
    id: json['id'] as int,
    goalId: json['goalId'] as int,
    hourOfDay: json['hourOfDay'] as int,
    dayOfWeek: json['dayOfWeek'] as int,
    duration: json['duration'] as int,
    timeSlotType: json['timeSlotType'] as int,
    hadPriorTask: json['hadPriorTask'] as bool,
    hadFollowingTask: json['hadFollowingTask'] as bool,
    weekOfYear: json['weekOfYear'] as int,
    isWeekend: json['isWeekend'] as bool,
    productivityScore: (json['productivityScore'] as num).toDouble(),
    wasRescheduled: json['wasRescheduled'] as bool,
    wasCompleted: json['wasCompleted'] as bool,
    actualDurationMinutes: json['actualDurationMinutes'] as int,
    minutesFromScheduled: json['minutesFromScheduled'] as int,
    recordedAt: DateTime.parse(json['recordedAt'] as String),
    scheduledTaskId: json['scheduledTaskId'] as int,
    taskOrderInDay: json['taskOrderInDay'] as int? ?? 1,
    totalTasksScheduledToday: json['totalTasksScheduledToday'] as int? ?? 1,
    tasksCompletedBeforeThis: json['tasksCompletedBeforeThis'] as int? ?? 0,
    relativeTimeInDay: (json['relativeTimeInDay'] as num?)?.toDouble() ?? 0.5,
    minutesSinceFirstActivity: json['minutesSinceFirstActivity'] as int? ?? 0,
    previousTaskRating: (json['previousTaskRating'] as num?)?.toDouble() ?? 0.0,
    completionRateLast7Days:
        (json['completionRateLast7Days'] as num?)?.toDouble() ?? 0.0,
    currentStreakAtCompletion: json['currentStreakAtCompletion'] as int? ?? 0,
    goalConsistencyScore:
        (json['goalConsistencyScore'] as num?)?.toDouble() ?? 0.0,
    consecutiveTasksCompleted: json['consecutiveTasksCompleted'] as int? ?? 0,
    minutesSinceLastCompletion: json['minutesSinceLastCompletion'] as int? ?? 0,
  );

  factory ProductivityDataBackup.fromModel(ProductivityData data) =>
      ProductivityDataBackup(
        id: data.id,
        goalId: data.goalId,
        hourOfDay: data.hourOfDay,
        dayOfWeek: data.dayOfWeek,
        duration: data.duration,
        timeSlotType: data.timeSlotType,
        hadPriorTask: data.hadPriorTask,
        hadFollowingTask: data.hadFollowingTask,
        weekOfYear: data.weekOfYear,
        isWeekend: data.isWeekend,
        productivityScore: data.productivityScore,
        wasRescheduled: data.wasRescheduled,
        wasCompleted: data.wasCompleted,
        actualDurationMinutes: data.actualDurationMinutes,
        minutesFromScheduled: data.minutesFromScheduled,
        recordedAt: data.recordedAt,
        scheduledTaskId: data.scheduledTaskId,
        taskOrderInDay: data.taskOrderInDay,
        totalTasksScheduledToday: data.totalTasksScheduledToday,
        tasksCompletedBeforeThis: data.tasksCompletedBeforeThis,
        relativeTimeInDay: data.relativeTimeInDay,
        minutesSinceFirstActivity: data.minutesSinceFirstActivity,
        previousTaskRating: data.previousTaskRating,
        completionRateLast7Days: data.completionRateLast7Days,
        currentStreakAtCompletion: data.currentStreakAtCompletion,
        goalConsistencyScore: data.goalConsistencyScore,
        consecutiveTasksCompleted: data.consecutiveTasksCompleted,
        minutesSinceLastCompletion: data.minutesSinceLastCompletion,
      );

  ProductivityData toModel() {
    return ProductivityData()
      ..id = id
      ..goalId = goalId
      ..hourOfDay = hourOfDay
      ..dayOfWeek = dayOfWeek
      ..duration = duration
      ..timeSlotType = timeSlotType
      ..hadPriorTask = hadPriorTask
      ..hadFollowingTask = hadFollowingTask
      ..weekOfYear = weekOfYear
      ..isWeekend = isWeekend
      ..productivityScore = productivityScore
      ..wasRescheduled = wasRescheduled
      ..wasCompleted = wasCompleted
      ..actualDurationMinutes = actualDurationMinutes
      ..minutesFromScheduled = minutesFromScheduled
      ..recordedAt = recordedAt
      ..scheduledTaskId = scheduledTaskId
      ..taskOrderInDay = taskOrderInDay
      ..totalTasksScheduledToday = totalTasksScheduledToday
      ..tasksCompletedBeforeThis = tasksCompletedBeforeThis
      ..relativeTimeInDay = relativeTimeInDay
      ..minutesSinceFirstActivity = minutesSinceFirstActivity
      ..previousTaskRating = previousTaskRating
      ..completionRateLast7Days = completionRateLast7Days
      ..currentStreakAtCompletion = currentStreakAtCompletion
      ..goalConsistencyScore = goalConsistencyScore
      ..consecutiveTasksCompleted = consecutiveTasksCompleted
      ..minutesSinceLastCompletion = minutesSinceLastCompletion;
  }
}

// ============ HABIT METRICS BACKUP ============

class HabitMetricsBackup {
  final int id;
  final int goalId;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastCompletedDate;
  final double consistencyScore;
  final double timeConsistency;
  final int? stickyHour;
  final int? stickyDayOfWeek;
  final int totalCompletions;
  final int totalScheduled;
  final DateTime createdAt;
  final DateTime updatedAt;

  HabitMetricsBackup({
    required this.id,
    required this.goalId,
    required this.currentStreak,
    required this.longestStreak,
    this.lastCompletedDate,
    required this.consistencyScore,
    required this.timeConsistency,
    this.stickyHour,
    this.stickyDayOfWeek,
    required this.totalCompletions,
    required this.totalScheduled,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'goalId': goalId,
    'currentStreak': currentStreak,
    'longestStreak': longestStreak,
    'lastCompletedDate': lastCompletedDate?.toIso8601String(),
    'consistencyScore': consistencyScore,
    'timeConsistency': timeConsistency,
    'stickyHour': stickyHour,
    'stickyDayOfWeek': stickyDayOfWeek,
    'totalCompletions': totalCompletions,
    'totalScheduled': totalScheduled,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory HabitMetricsBackup.fromJson(Map<String, dynamic> json) =>
      HabitMetricsBackup(
        id: json['id'] as int,
        goalId: json['goalId'] as int,
        currentStreak: json['currentStreak'] as int,
        longestStreak: json['longestStreak'] as int,
        lastCompletedDate: json['lastCompletedDate'] != null
            ? DateTime.parse(json['lastCompletedDate'] as String)
            : null,
        consistencyScore: (json['consistencyScore'] as num).toDouble(),
        timeConsistency: (json['timeConsistency'] as num).toDouble(),
        stickyHour: json['stickyHour'] as int?,
        stickyDayOfWeek: json['stickyDayOfWeek'] as int?,
        totalCompletions: json['totalCompletions'] as int,
        totalScheduled: json['totalScheduled'] as int,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );

  factory HabitMetricsBackup.fromModel(HabitMetrics metrics) =>
      HabitMetricsBackup(
        id: metrics.id,
        goalId: metrics.goalId,
        currentStreak: metrics.currentStreak,
        longestStreak: metrics.longestStreak,
        lastCompletedDate: metrics.lastCompletedDate,
        consistencyScore: metrics.consistencyScore,
        timeConsistency: metrics.timeConsistency,
        stickyHour: metrics.stickyHour,
        stickyDayOfWeek: metrics.stickyDayOfWeek,
        totalCompletions: metrics.totalCompletions,
        totalScheduled: metrics.totalScheduled,
        createdAt: metrics.createdAt,
        updatedAt: metrics.updatedAt,
      );

  HabitMetrics toModel() {
    return HabitMetrics()
      ..id = id
      ..goalId = goalId
      ..currentStreak = currentStreak
      ..longestStreak = longestStreak
      ..lastCompletedDate = lastCompletedDate
      ..consistencyScore = consistencyScore
      ..timeConsistency = timeConsistency
      ..stickyHour = stickyHour
      ..stickyDayOfWeek = stickyDayOfWeek
      ..totalCompletions = totalCompletions
      ..totalScheduled = totalScheduled
      ..createdAt = createdAt
      ..updatedAt = updatedAt;
  }
}

// ============ USER PROFILE BACKUP ============

class UserProfileBackup {
  final int id;
  final String chronoType;
  final int wakeUpHour;
  final int sleepHour;
  final bool hasWorkSchedule;
  final int? workStartHour;
  final int? workEndHour;
  final List<int> busyDays;
  final String preferredSessionLength;
  final bool prefersRoutine;
  final bool onboardingCompleted;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserProfileBackup({
    required this.id,
    required this.chronoType,
    required this.wakeUpHour,
    required this.sleepHour,
    required this.hasWorkSchedule,
    this.workStartHour,
    this.workEndHour,
    required this.busyDays,
    required this.preferredSessionLength,
    required this.prefersRoutine,
    required this.onboardingCompleted,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'chronoType': chronoType,
    'wakeUpHour': wakeUpHour,
    'sleepHour': sleepHour,
    'hasWorkSchedule': hasWorkSchedule,
    'workStartHour': workStartHour,
    'workEndHour': workEndHour,
    'busyDays': busyDays,
    'preferredSessionLength': preferredSessionLength,
    'prefersRoutine': prefersRoutine,
    'onboardingCompleted': onboardingCompleted,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  factory UserProfileBackup.fromJson(Map<String, dynamic> json) =>
      UserProfileBackup(
        id: json['id'] as int,
        chronoType: json['chronoType'] as String,
        wakeUpHour: json['wakeUpHour'] as int,
        sleepHour: json['sleepHour'] as int,
        hasWorkSchedule: json['hasWorkSchedule'] as bool,
        workStartHour: json['workStartHour'] as int?,
        workEndHour: json['workEndHour'] as int?,
        busyDays: (json['busyDays'] as List).cast<int>(),
        preferredSessionLength: json['preferredSessionLength'] as String,
        prefersRoutine: json['prefersRoutine'] as bool,
        onboardingCompleted: json['onboardingCompleted'] as bool,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'] as String)
            : null,
      );

  factory UserProfileBackup.fromModel(UserProfile profile) => UserProfileBackup(
    id: profile.id,
    chronoType: profile.chronoType.name,
    wakeUpHour: profile.wakeUpHour,
    sleepHour: profile.sleepHour,
    hasWorkSchedule: profile.hasWorkSchedule,
    workStartHour: profile.workStartHour,
    workEndHour: profile.workEndHour,
    busyDays: profile.busyDays,
    preferredSessionLength: profile.preferredSessionLength.name,
    prefersRoutine: profile.prefersRoutine,
    onboardingCompleted: profile.onboardingCompleted,
    createdAt: profile.createdAt,
    updatedAt: profile.updatedAt,
  );

  UserProfile toModel() {
    return UserProfile()
      ..id = id
      ..chronoType = ChronoType.values.firstWhere(
        (c) => c.name == chronoType,
        orElse: () => ChronoType.normal,
      )
      ..wakeUpHour = wakeUpHour
      ..sleepHour = sleepHour
      ..hasWorkSchedule = hasWorkSchedule
      ..workStartHour = workStartHour
      ..workEndHour = workEndHour
      ..busyDays = busyDays
      ..preferredSessionLength = SessionLength.values.firstWhere(
        (s) => s.name == preferredSessionLength,
        orElse: () => SessionLength.medium,
      )
      ..prefersRoutine = prefersRoutine
      ..onboardingCompleted = onboardingCompleted
      ..createdAt = createdAt
      ..updatedAt = updatedAt;
  }
}

// ============ APP SETTINGS BACKUP ============

class AppSettingsBackup {
  final int id;
  final int dayStartHour;
  final int dayEndHour;
  final bool mlEnabled;
  final int minTrainingDataPoints;
  final bool darkMode;
  final String accentColor;
  final bool notificationsEnabled;
  final int reminderMinutesBefore;
  final DateTime updatedAt;

  AppSettingsBackup({
    required this.id,
    required this.dayStartHour,
    required this.dayEndHour,
    required this.mlEnabled,
    required this.minTrainingDataPoints,
    required this.darkMode,
    required this.accentColor,
    required this.notificationsEnabled,
    required this.reminderMinutesBefore,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'dayStartHour': dayStartHour,
    'dayEndHour': dayEndHour,
    'mlEnabled': mlEnabled,
    'minTrainingDataPoints': minTrainingDataPoints,
    'darkMode': darkMode,
    'accentColor': accentColor,
    'notificationsEnabled': notificationsEnabled,
    'reminderMinutesBefore': reminderMinutesBefore,
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory AppSettingsBackup.fromJson(Map<String, dynamic> json) =>
      AppSettingsBackup(
        id: json['id'] as int,
        dayStartHour: json['dayStartHour'] as int,
        dayEndHour: json['dayEndHour'] as int,
        mlEnabled: json['mlEnabled'] as bool,
        minTrainingDataPoints: json['minTrainingDataPoints'] as int,
        darkMode: json['darkMode'] as bool,
        accentColor: json['accentColor'] as String,
        notificationsEnabled: json['notificationsEnabled'] as bool,
        reminderMinutesBefore: json['reminderMinutesBefore'] as int,
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );

  factory AppSettingsBackup.fromModel(AppSettings settings) =>
      AppSettingsBackup(
        id: settings.id,
        dayStartHour: settings.dayStartHour,
        dayEndHour: settings.dayEndHour,
        mlEnabled: settings.mlEnabled,
        minTrainingDataPoints: settings.minTrainingDataPoints,
        darkMode: settings.darkMode,
        accentColor: settings.accentColor,
        notificationsEnabled: settings.notificationsEnabled,
        reminderMinutesBefore: settings.reminderMinutesBefore,
        updatedAt: settings.updatedAt,
      );

  AppSettings toModel() {
    return AppSettings()
      ..id = id
      ..dayStartHour = dayStartHour
      ..dayEndHour = dayEndHour
      ..mlEnabled = mlEnabled
      ..minTrainingDataPoints = minTrainingDataPoints
      ..darkMode = darkMode
      ..accentColor = accentColor
      ..notificationsEnabled = notificationsEnabled
      ..reminderMinutesBefore = reminderMinutesBefore
      ..updatedAt = updatedAt;
  }
}

// ============ DAILY ACTIVITY LOG BACKUP ============

class DailyActivityLogBackup {
  final int id;
  final DateTime date;
  final DateTime? firstActivityAt;
  final DateTime? lastActivityAt;
  final int tasksCompleted;
  final int tasksScheduled;
  final int tasksSkipped;
  final double averageProductivity;
  final double productivitySum;
  final bool isWeekend;
  final int dayOfWeek;
  final DateTime updatedAt;

  DailyActivityLogBackup({
    required this.id,
    required this.date,
    this.firstActivityAt,
    this.lastActivityAt,
    required this.tasksCompleted,
    required this.tasksScheduled,
    required this.tasksSkipped,
    required this.averageProductivity,
    required this.productivitySum,
    required this.isWeekend,
    required this.dayOfWeek,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'firstActivityAt': firstActivityAt?.toIso8601String(),
    'lastActivityAt': lastActivityAt?.toIso8601String(),
    'tasksCompleted': tasksCompleted,
    'tasksScheduled': tasksScheduled,
    'tasksSkipped': tasksSkipped,
    'averageProductivity': averageProductivity,
    'productivitySum': productivitySum,
    'isWeekend': isWeekend,
    'dayOfWeek': dayOfWeek,
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory DailyActivityLogBackup.fromJson(Map<String, dynamic> json) =>
      DailyActivityLogBackup(
        id: json['id'] as int,
        date: DateTime.parse(json['date'] as String),
        firstActivityAt: json['firstActivityAt'] != null
            ? DateTime.parse(json['firstActivityAt'] as String)
            : null,
        lastActivityAt: json['lastActivityAt'] != null
            ? DateTime.parse(json['lastActivityAt'] as String)
            : null,
        tasksCompleted: json['tasksCompleted'] as int,
        tasksScheduled: json['tasksScheduled'] as int,
        tasksSkipped: json['tasksSkipped'] as int,
        averageProductivity: (json['averageProductivity'] as num).toDouble(),
        productivitySum: (json['productivitySum'] as num).toDouble(),
        isWeekend: json['isWeekend'] as bool,
        dayOfWeek: json['dayOfWeek'] as int,
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );

  factory DailyActivityLogBackup.fromModel(DailyActivityLog log) =>
      DailyActivityLogBackup(
        id: log.id,
        date: log.date,
        firstActivityAt: log.firstActivityAt,
        lastActivityAt: log.lastActivityAt,
        tasksCompleted: log.tasksCompleted,
        tasksScheduled: log.tasksScheduled,
        tasksSkipped: log.tasksSkipped,
        averageProductivity: log.averageProductivity,
        productivitySum: log.productivitySum,
        isWeekend: log.isWeekend,
        dayOfWeek: log.dayOfWeek,
        updatedAt: log.updatedAt,
      );

  DailyActivityLog toModel() {
    return DailyActivityLog()
      ..id = id
      ..date = date
      ..firstActivityAt = firstActivityAt
      ..lastActivityAt = lastActivityAt
      ..tasksCompleted = tasksCompleted
      ..tasksScheduled = tasksScheduled
      ..tasksSkipped = tasksSkipped
      ..averageProductivity = averageProductivity
      ..productivitySum = productivitySum
      ..isWeekend = isWeekend
      ..dayOfWeek = dayOfWeek
      ..updatedAt = updatedAt;
  }
}
