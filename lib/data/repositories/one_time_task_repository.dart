import 'package:isar/isar.dart';
import '../models/one_time_task.dart';

class OneTimeTaskRepository {
  final Isar isar;

  OneTimeTaskRepository(this.isar);

  // Create
  Future<int> createOneTimeTask(OneTimeTask task) async {
    return await isar.writeTxn(() async {
      return await isar.oneTimeTasks.put(task);
    });
  }

  // Read
  Future<OneTimeTask?> getOneTimeTask(int id) async {
    return await isar.oneTimeTasks.get(id);
  }

  Future<List<OneTimeTask>> getOneTimeTasksForDate(DateTime date) async {
    final normalizedDate = _normalizeDate(date);
    return await isar.oneTimeTasks
        .filter()
        .scheduledDateEqualTo(normalizedDate)
        .sortByScheduledStartTime()
        .findAll();
  }

  Future<List<OneTimeTask>> getPendingOneTimeTasks(DateTime date) async {
    final normalizedDate = _normalizeDate(date);
    return await isar.oneTimeTasks
        .filter()
        .scheduledDateEqualTo(normalizedDate)
        .isCompletedEqualTo(false)
        .sortByScheduledStartTime()
        .findAll();
  }

  Future<List<OneTimeTask>> getCompletedOneTimeTasks(DateTime date) async {
    final normalizedDate = _normalizeDate(date);
    return await isar.oneTimeTasks
        .filter()
        .scheduledDateEqualTo(normalizedDate)
        .isCompletedEqualTo(true)
        .sortByScheduledStartTime()
        .findAll();
  }

  Future<List<OneTimeTask>> getAllPendingOneTimeTasks() async {
    return await isar.oneTimeTasks
        .filter()
        .isCompletedEqualTo(false)
        .sortByScheduledStartTime()
        .findAll();
  }

  // Update
  Future<void> updateOneTimeTask(OneTimeTask task) async {
    await isar.writeTxn(() async {
      await isar.oneTimeTasks.put(task);
    });
  }

  Future<void> markAsCompleted(int id) async {
    final task = await getOneTimeTask(id);
    if (task != null) {
      task.isCompleted = true;
      task.completedAt = DateTime.now();
      await updateOneTimeTask(task);
    }
  }

  Future<void> markAsIncomplete(int id) async {
    final task = await getOneTimeTask(id);
    if (task != null) {
      task.isCompleted = false;
      task.completedAt = null;
      await updateOneTimeTask(task);
    }
  }

  // Delete
  Future<bool> deleteOneTimeTask(int id) async {
    return await isar.writeTxn(() async {
      return await isar.oneTimeTasks.delete(id);
    });
  }

  // Count
  Future<int> getOneTimeTaskCount(DateTime date) async {
    final normalizedDate = _normalizeDate(date);
    return await isar.oneTimeTasks
        .filter()
        .scheduledDateEqualTo(normalizedDate)
        .count();
  }

  Future<int> getPendingOneTimeTaskCount(DateTime date) async {
    final normalizedDate = _normalizeDate(date);
    return await isar.oneTimeTasks
        .filter()
        .scheduledDateEqualTo(normalizedDate)
        .isCompletedEqualTo(false)
        .count();
  }

  // Helper
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
