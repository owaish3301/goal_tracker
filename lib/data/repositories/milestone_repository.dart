import 'package:isar/isar.dart';
import '../models/milestone.dart';
import '../models/goal.dart';

class MilestoneRepository {
  final Isar isar;

  MilestoneRepository(this.isar);

  // Create
  Future<int> createMilestone(Milestone milestone, int goalId) async {
    return await isar.writeTxn(() async {
      final goal = await isar.goals.get(goalId);
      if (goal != null) {
        // First, save the milestone to make it managed by Isar
        final milestoneId = await isar.milestones.put(milestone);

        // Then set the goal relationship and save it
        milestone.goal.value = goal;
        await milestone.goal.save();

        return milestoneId;
      }
      return await isar.milestones.put(milestone);
    });
  }

  // Read
  Future<Milestone?> getMilestone(int id) async {
    return await isar.milestones.get(id);
  }

  Future<List<Milestone>> getMilestonesForGoal(int goalId) async {
    final goal = await isar.goals.get(goalId);
    if (goal == null) return [];

    await goal.milestones.load();
    return goal.milestones.toList()
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
  }

  Future<List<Milestone>> getCompletedMilestones(int goalId) async {
    final milestones = await getMilestonesForGoal(goalId);
    return milestones.where((m) => m.isCompleted).toList();
  }

  Future<List<Milestone>> getPendingMilestones(int goalId) async {
    final milestones = await getMilestonesForGoal(goalId);
    return milestones.where((m) => !m.isCompleted).toList();
  }

  // Update
  Future<void> updateMilestone(Milestone milestone) async {
    await isar.writeTxn(() async {
      await isar.milestones.put(milestone);
    });
  }

  Future<void> markAsCompleted(int id) async {
    final milestone = await getMilestone(id);
    if (milestone != null) {
      milestone.isCompleted = true;
      milestone.completedAt = DateTime.now();
      await updateMilestone(milestone);
    }
  }

  Future<void> markAsIncomplete(int id) async {
    final milestone = await getMilestone(id);
    if (milestone != null) {
      milestone.isCompleted = false;
      milestone.completedAt = null;
      await updateMilestone(milestone);
    }
  }

  Future<void> reorderMilestones(List<Milestone> milestones) async {
    await isar.writeTxn(() async {
      for (int i = 0; i < milestones.length; i++) {
        milestones[i].orderIndex = i;
      }
      await isar.milestones.putAll(milestones);
    });
  }

  // Delete
  Future<bool> deleteMilestone(int id) async {
    return await isar.writeTxn(() async {
      return await isar.milestones.delete(id);
    });
  }

  // Count
  Future<int> getMilestoneCount(int goalId) async {
    final milestones = await getMilestonesForGoal(goalId);
    return milestones.length;
  }

  Future<int> getCompletedMilestoneCount(int goalId) async {
    final milestones = await getCompletedMilestones(goalId);
    return milestones.length;
  }
}
