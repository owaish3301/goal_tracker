import 'package:isar/isar.dart';
import 'goal.dart';

part 'milestone.g.dart';

@collection
class Milestone {
  Id id = Isar.autoIncrement;

  late String title; // e.g., "Chapter 1: Variables"

  late int orderIndex; // For maintaining sequence

  @Index()
  late bool isCompleted;

  DateTime? completedAt;

  // Relationship
  final goal = IsarLink<Goal>();
}
