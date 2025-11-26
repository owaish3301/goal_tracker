import 'package:flutter_test/flutter_test.dart';
import 'package:goal_tracker/data/models/daily_activity_log.dart';

void main() {
  group('DailyActivityLog', () {
    test('creates with correct initial values via factory', () {
      final log = DailyActivityLog.createForDate(DateTime(2024, 1, 15));
      
      expect(log.date, DateTime(2024, 1, 15));
      expect(log.firstActivityAt, isNull);
      expect(log.lastActivityAt, isNull);
      expect(log.tasksCompleted, 0);
      expect(log.tasksScheduled, 0);
      expect(log.tasksSkipped, 0);
      expect(log.averageProductivity, 0.0);
      expect(log.productivitySum, 0.0);
    });
    
    test('recordActivity sets first and last activity', () {
      final log = DailyActivityLog.createForDate(DateTime(2024, 1, 15));
      final activityTime = DateTime(2024, 1, 15, 8, 30);
      
      log.recordActivity(activityTime);
      
      expect(log.firstActivityAt, activityTime);
      expect(log.lastActivityAt, activityTime);
    });
    
    test('recordActivity only updates lastActivityAt for later times', () {
      final log = DailyActivityLog.createForDate(DateTime(2024, 1, 15));
      final firstTime = DateTime(2024, 1, 15, 8, 30);
      final secondTime = DateTime(2024, 1, 15, 14, 30);
      
      log.recordActivity(firstTime);
      log.recordActivity(secondTime);
      
      expect(log.firstActivityAt, firstTime);
      expect(log.lastActivityAt, secondTime);
    });
    
    test('recordTaskCompletion updates counters and productivity', () {
      final log = DailyActivityLog.createForDate(DateTime(2024, 1, 15));
      
      log.recordTaskCompletion(4.0);
      expect(log.tasksCompleted, 1);
      expect(log.productivitySum, 4.0);
      expect(log.averageProductivity, 4.0);
      
      log.recordTaskCompletion(5.0);
      expect(log.tasksCompleted, 2);
      expect(log.productivitySum, 9.0);
      expect(log.averageProductivity, 4.5);
    });
    
    test('recordTaskScheduled increments counter', () {
      final log = DailyActivityLog.createForDate(DateTime(2024, 1, 15));
      
      log.recordTaskScheduled();
      expect(log.tasksScheduled, 1);
      
      log.recordTaskScheduled();
      expect(log.tasksScheduled, 2);
    });
    
    test('recordTaskSkipped increments counter', () {
      final log = DailyActivityLog.createForDate(DateTime(2024, 1, 15));
      
      log.recordTaskSkipped();
      expect(log.tasksSkipped, 1);
      
      log.recordTaskSkipped();
      expect(log.tasksSkipped, 2);
    });
    
    test('completionRate calculates correctly', () {
      final log = DailyActivityLog.createForDate(DateTime(2024, 1, 15));
      
      // No scheduled = 0.0
      expect(log.completionRate, 0.0);
      
      log.tasksScheduled = 4;
      log.tasksCompleted = 2;
      expect(log.completionRate, 0.5); // 2/4
      
      log.tasksCompleted = 4;
      expect(log.completionRate, 1.0); // 4/4
    });
    
    test('isWeekend returns correct value', () {
      final weekday = DailyActivityLog.createForDate(DateTime(2024, 1, 15)); // Monday
      expect(weekday.isWeekend, false);
      
      final saturday = DailyActivityLog.createForDate(DateTime(2024, 1, 20)); // Saturday
      expect(saturday.isWeekend, true);
      
      final sunday = DailyActivityLog.createForDate(DateTime(2024, 1, 21)); // Sunday
      expect(sunday.isWeekend, true);
    });
    
    test('effectiveWakeHour returns hour from firstActivityAt', () {
      final log = DailyActivityLog.createForDate(DateTime(2024, 1, 15));
      expect(log.effectiveWakeHour, isNull);
      
      log.firstActivityAt = DateTime(2024, 1, 15, 7, 30);
      expect(log.effectiveWakeHour, 7);
    });
    
    test('effectiveSleepHour returns hour from lastActivityAt', () {
      final log = DailyActivityLog.createForDate(DateTime(2024, 1, 15));
      expect(log.effectiveSleepHour, isNull);
      
      log.lastActivityAt = DateTime(2024, 1, 15, 22, 45);
      expect(log.effectiveSleepHour, 22);
    });
    
    test('activeWindowHours calculates correctly', () {
      final log = DailyActivityLog.createForDate(DateTime(2024, 1, 15));
      
      // No activity
      expect(log.activeWindowHours, isNull);
      
      // Only first activity
      log.firstActivityAt = DateTime(2024, 1, 15, 8, 0);
      expect(log.activeWindowHours, isNull);
      
      // Both activities
      log.lastActivityAt = DateTime(2024, 1, 15, 17, 0);
      expect(log.activeWindowHours, closeTo(9.0, 0.01));
    });
    
    test('createForDate factory creates with correct values', () {
      final log = DailyActivityLog.createForDate(DateTime(2024, 1, 15));
      
      expect(log.date.year, 2024);
      expect(log.date.month, 1);
      expect(log.date.day, 15);
      expect(log.dayOfWeek, 0); // Monday
      expect(log.isWeekend, false);
    });
    
    test('createForDate sets weekend flag correctly', () {
      final saturday = DailyActivityLog.createForDate(DateTime(2024, 1, 20));
      expect(saturday.dayOfWeek, 5);
      expect(saturday.isWeekend, true);
      
      final sunday = DailyActivityLog.createForDate(DateTime(2024, 1, 21));
      expect(sunday.dayOfWeek, 6);
      expect(sunday.isWeekend, true);
    });
  });
}
