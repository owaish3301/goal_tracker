import 'package:isar/isar.dart';
import '../models/goal.dart';

class GoalRepository {
  final Isar isar;

  GoalRepository(this.isar);

  // Create
  Future<int> createGoal(Goal goal) async {
    return await isar.writeTxn(() async {
      return await isar.goals.put(goal);
    });
  }

  // Read
  Future<Goal?> getGoal(int id) async {
    return await isar.goals.get(id);
  }

  Future<List<Goal>> getAllGoals() async {
    return await isar.goals.where().findAll();
  }

  Future<List<Goal>> getActiveGoals() async {
    return await isar.goals
        .filter()
        .isActiveEqualTo(true)
        .sortByPriorityIndex()
        .findAll();
  }

  Future<List<Goal>> getGoalsForDay(int dayOfWeek) async {
    return await isar.goals
        .filter()
        .isActiveEqualTo(true)
        .frequencyElementEqualTo(dayOfWeek)
        .sortByPriorityIndex()
        .findAll();
  }

  Future<List<Goal>> getGoalsByPriority() async {
    return await isar.goals
        .filter()
        .isActiveEqualTo(true)
        .sortByPriorityIndex()
        .findAll();
  }

  // Update
  Future<void> updateGoal(Goal goal) async {
    await isar.writeTxn(() async {
      goal.updatedAt = DateTime.now();
      await isar.goals.put(goal);
    });
  }

  Future<void> updatePriorityIndexes(List<Goal> goals) async {
    await isar.writeTxn(() async {
      for (int i = 0; i < goals.length; i++) {
        goals[i].priorityIndex = i;
        goals[i].updatedAt = DateTime.now();
      }
      await isar.goals.putAll(goals);
    });
  }

  Future<void> toggleGoalActive(int id, bool isActive) async {
    final goal = await getGoal(id);
    if (goal != null) {
      goal.isActive = isActive;
      await updateGoal(goal);
    }
  }

  // Delete
  Future<bool> deleteGoal(int id) async {
    return await isar.writeTxn(() async {
      return await isar.goals.delete(id);
    });
  }

  // Count
  Future<int> getGoalCount() async {
    return await isar.goals.count();
  }

  Future<int> getActiveGoalCount() async {
    return await isar.goals.filter().isActiveEqualTo(true).count();
  }
}
