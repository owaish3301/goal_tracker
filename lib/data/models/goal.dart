import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'milestone.dart';
import 'task.dart';

part 'goal.g.dart';

@collection
class Goal {
  Id id = Isar.autoIncrement;

  late String title;

  // Frequency: Array of day indices (0=Monday, 6=Sunday)
  // Example: [0,1,2,3,4] = Mon-Fri
  late List<int> frequency;

  // Target duration in minutes
  late int targetDuration;

  // Priority index (lower = higher priority)
  @Index()
  late int priorityIndex;

  // UI customization
  late String colorHex; // e.g., "#FF5733"
  late String iconName; // e.g., "fitness_center"

  // Timestamps
  late DateTime createdAt;
  DateTime? updatedAt;

  // Status
  @Index()
  late bool isActive; // Can be paused/archived

  // Relationships
  @Backlink(to: 'goal')
  final milestones = IsarLinks<Milestone>();

  @Backlink(to: 'goal')
  final tasks = IsarLinks<Task>();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Goal &&
        other.id == id &&
        other.title == title &&
        listEquals(other.frequency, frequency) &&
        other.targetDuration == targetDuration &&
        other.priorityIndex == priorityIndex &&
        other.colorHex == colorHex &&
        other.iconName == iconName &&
        other.isActive == isActive &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        Object.hashAll(frequency) ^
        targetDuration.hashCode ^
        priorityIndex.hashCode ^
        colorHex.hashCode ^
        iconName.hashCode ^
        isActive.hashCode ^
        updatedAt.hashCode;
  }
}
