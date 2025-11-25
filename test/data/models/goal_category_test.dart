import 'package:flutter_test/flutter_test.dart';
import 'package:goal_tracker/data/models/goal_category.dart';

void main() {
  group('GoalCategory', () {
    group('displayName', () {
      test('returns correct display names for all categories', () {
        expect(GoalCategory.exercise.displayName, 'Exercise & Fitness');
        expect(GoalCategory.learning.displayName, 'Learning & Study');
        expect(GoalCategory.creative.displayName, 'Creative & Art');
        expect(GoalCategory.work.displayName, 'Work & Career');
        expect(GoalCategory.wellness.displayName, 'Wellness & Self-care');
        expect(GoalCategory.social.displayName, 'Social & Relationships');
        expect(GoalCategory.chores.displayName, 'Chores & Errands');
        expect(GoalCategory.other.displayName, 'Other');
      });
    });

    group('iconName', () {
      test('returns correct icon names for all categories', () {
        expect(GoalCategory.exercise.iconName, 'fitness_center');
        expect(GoalCategory.learning.iconName, 'school');
        expect(GoalCategory.creative.iconName, 'palette');
        expect(GoalCategory.work.iconName, 'work');
        expect(GoalCategory.wellness.iconName, 'self_improvement');
        expect(GoalCategory.social.iconName, 'people');
        expect(GoalCategory.chores.iconName, 'home');
        expect(GoalCategory.other.iconName, 'category');
      });
    });

    group('emoji', () {
      test('returns correct emojis for all categories', () {
        expect(GoalCategory.exercise.emoji, '🏋️');
        expect(GoalCategory.learning.emoji, '📚');
        expect(GoalCategory.creative.emoji, '🎨');
        expect(GoalCategory.work.emoji, '💼');
        expect(GoalCategory.wellness.emoji, '🧘');
        expect(GoalCategory.social.emoji, '👥');
        expect(GoalCategory.chores.emoji, '🏠');
        expect(GoalCategory.other.emoji, '📌');
      });
    });

    group('optimalHours', () {
      test('exercise has morning and after-work optimal hours', () {
        final hours = GoalCategory.exercise.optimalHours;
        expect(hours, containsAll([6, 7, 8, 17, 18, 19]));
      });

      test('learning has morning and evening optimal hours', () {
        final hours = GoalCategory.learning.optimalHours;
        expect(hours, containsAll([9, 10, 11, 20, 21]));
      });

      test('creative has evening and late morning optimal hours', () {
        final hours = GoalCategory.creative.optimalHours;
        expect(hours, containsAll([20, 21, 22, 10, 11]));
      });

      test('work has standard working hours', () {
        final hours = GoalCategory.work.optimalHours;
        expect(hours, containsAll([9, 10, 11, 14, 15, 16]));
      });

      test('wellness has morning and evening hours', () {
        final hours = GoalCategory.wellness.optimalHours;
        expect(hours, containsAll([6, 7, 8, 21, 22]));
      });

      test('social has after-work hours', () {
        final hours = GoalCategory.social.optimalHours;
        expect(hours, containsAll([18, 19, 20]));
      });

      test('chores has afternoon hours', () {
        final hours = GoalCategory.chores.optimalHours;
        expect(hours, containsAll([14, 15, 16, 17]));
      });

      test('other has standard working hours', () {
        final hours = GoalCategory.other.optimalHours;
        expect(hours, containsAll([9, 10, 11, 14, 15, 16]));
      });

      test('all optimal hours are valid (0-23)', () {
        for (final category in GoalCategory.values) {
          for (final hour in category.optimalHours) {
            expect(hour, greaterThanOrEqualTo(0));
            expect(hour, lessThanOrEqualTo(23));
          }
        }
      });
    });

    group('bestHour', () {
      test('returns first optimal hour for each category', () {
        expect(GoalCategory.exercise.bestHour, 6);
        expect(GoalCategory.learning.bestHour, 9);
        expect(GoalCategory.creative.bestHour, 20);
        expect(GoalCategory.work.bestHour, 9);
        expect(GoalCategory.wellness.bestHour, 6);
        expect(GoalCategory.social.bestHour, 18);
        expect(GoalCategory.chores.bestHour, 14);
        expect(GoalCategory.other.bestHour, 9);
      });
    });

    group('isOptimalHour', () {
      test('returns true for optimal hours', () {
        expect(GoalCategory.exercise.isOptimalHour(6), true);
        expect(GoalCategory.exercise.isOptimalHour(7), true);
        expect(GoalCategory.learning.isOptimalHour(10), true);
      });

      test('returns false for non-optimal hours', () {
        expect(GoalCategory.exercise.isOptimalHour(12), false);
        expect(GoalCategory.exercise.isOptimalHour(23), false);
        expect(GoalCategory.learning.isOptimalHour(22), false);
      });
    });

    group('getHourScore', () {
      test('returns high score for first optimal hour', () {
        final score = GoalCategory.exercise.getHourScore(6);
        expect(score, 1.0);
      });

      test('returns decreasing scores for later optimal hours', () {
        // Hour 6 is first (index 0), score = 1.0
        // Hour 7 is second (index 1), score = 0.9
        // Hour 8 is third (index 2), score = 0.8
        final score6 = GoalCategory.exercise.getHourScore(6);
        final score7 = GoalCategory.exercise.getHourScore(7);
        final score8 = GoalCategory.exercise.getHourScore(8);
        
        expect(score6, greaterThan(score7));
        expect(score7, greaterThan(score8));
      });

      test('returns base score for non-optimal hours', () {
        // Hour 12 is not in exercise optimal hours [6,7,8,17,18,19]
        final score = GoalCategory.exercise.getHourScore(12);
        expect(score, 0.3);
      });

      test('handles edge cases (hour 0 and 23)', () {
        final score0 = GoalCategory.exercise.getHourScore(0);
        final score23 = GoalCategory.exercise.getHourScore(23);

        expect(score0, greaterThanOrEqualTo(0.0));
        expect(score0, lessThanOrEqualTo(1.0));
        expect(score23, greaterThanOrEqualTo(0.0));
        expect(score23, lessThanOrEqualTo(1.0));
      });
    });
  });

  group('GoalCategoryService', () {
    group('allCategories', () {
      test('returns all category values', () {
        expect(GoalCategoryService.allCategories.length, 8);
        expect(GoalCategoryService.allCategories, GoalCategory.values);
      });
    });

    group('fromIndex', () {
      test('returns correct category for valid index', () {
        expect(GoalCategoryService.fromIndex(0), GoalCategory.exercise);
        expect(GoalCategoryService.fromIndex(1), GoalCategory.learning);
        expect(GoalCategoryService.fromIndex(7), GoalCategory.other);
      });

      test('returns other for invalid index', () {
        expect(GoalCategoryService.fromIndex(-1), GoalCategory.other);
        expect(GoalCategoryService.fromIndex(100), GoalCategory.other);
      });
    });

    group('findBestHour', () {
      test('returns optimal hour when available', () {
        final availableHours = [6, 7, 8, 12, 14, 18]; // 6,7,8,18 are optimal for exercise
        final best = GoalCategoryService.findBestHour(
          category: GoalCategory.exercise,
          availableHours: availableHours,
        );

        // Should return 6 (first optimal hour)
        expect(best, 6);
      });

      test('returns second optimal hour when first not available', () {
        final availableHours = [10, 12, 14, 17, 18, 19];
        final best = GoalCategoryService.findBestHour(
          category: GoalCategory.exercise,
          availableHours: availableHours,
        );

        // Should return 17 (first available from optimal hours)
        expect(best, 17);
      });

      test('returns first available when no optimal hours available', () {
        final availableHours = [12, 13, 14]; // None are optimal for exercise
        final best = GoalCategoryService.findBestHour(
          category: GoalCategory.exercise,
          availableHours: availableHours,
        );

        expect(best, 12); // First available hour
      });

      test('returns null when no hours available', () {
        final best = GoalCategoryService.findBestHour(
          category: GoalCategory.exercise,
          availableHours: [],
        );

        expect(best, isNull);
      });
    });

    group('scoreTimeSlot', () {
      test('returns base score for hour', () {
        final score = GoalCategoryService.scoreTimeSlot(
          category: GoalCategory.exercise,
          hour: 6,
        );
        expect(score, closeTo(1.0, 0.01));
      });

      test('gives exercise bonus for first task of day', () {
        final baseScore = GoalCategoryService.scoreTimeSlot(
          category: GoalCategory.exercise,
          hour: 6,
        );
        final firstTaskScore = GoalCategoryService.scoreTimeSlot(
          category: GoalCategory.exercise,
          hour: 6,
          taskOrderInDay: 1,
        );
        
        // First task gets 0.1 bonus, clamped to 1.0
        expect(firstTaskScore, greaterThanOrEqualTo(baseScore));
      });

      test('gives creative bonus after warm-up tasks', () {
        // Use a non-optimal hour so base score is lower and bonus can be seen
        final baseScore = GoalCategoryService.scoreTimeSlot(
          category: GoalCategory.creative,
          hour: 14, // Not optimal for creative
        );
        final laterTaskScore = GoalCategoryService.scoreTimeSlot(
          category: GoalCategory.creative,
          hour: 14,
          taskOrderInDay: 3,
        );
        
        expect(laterTaskScore, greaterThan(baseScore));
      });

      test('score is always between 0 and 1', () {
        for (final category in GoalCategory.values) {
          for (var hour = 0; hour < 24; hour++) {
            final score = GoalCategoryService.scoreTimeSlot(
              category: category,
              hour: hour,
              taskOrderInDay: 1,
            );
            expect(score, greaterThanOrEqualTo(0.0));
            expect(score, lessThanOrEqualTo(1.0));
          }
        }
      });
    });
  });
}
