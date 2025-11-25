/// Goal categories with research-backed scheduling preferences
enum GoalCategory {
  exercise,   // Physical activity, workout, sports
  learning,   // Study, reading, courses, skill building
  creative,   // Art, writing, music, design
  work,       // Professional tasks, career
  wellness,   // Meditation, journaling, self-care
  social,     // Family time, relationships
  chores,     // Household tasks, errands
  other,      // Uncategorized
}

/// Extension to add utility methods to GoalCategory
extension GoalCategoryExtension on GoalCategory {
  /// Get display name for the category
  String get displayName {
    switch (this) {
      case GoalCategory.exercise:
        return 'Exercise & Fitness';
      case GoalCategory.learning:
        return 'Learning & Study';
      case GoalCategory.creative:
        return 'Creative & Art';
      case GoalCategory.work:
        return 'Work & Career';
      case GoalCategory.wellness:
        return 'Wellness & Self-care';
      case GoalCategory.social:
        return 'Social & Relationships';
      case GoalCategory.chores:
        return 'Chores & Errands';
      case GoalCategory.other:
        return 'Other';
    }
  }

  /// Get icon name for the category
  String get iconName {
    switch (this) {
      case GoalCategory.exercise:
        return 'fitness_center';
      case GoalCategory.learning:
        return 'school';
      case GoalCategory.creative:
        return 'palette';
      case GoalCategory.work:
        return 'work';
      case GoalCategory.wellness:
        return 'self_improvement';
      case GoalCategory.social:
        return 'people';
      case GoalCategory.chores:
        return 'home';
      case GoalCategory.other:
        return 'category';
    }
  }

  /// Get emoji for the category
  String get emoji {
    switch (this) {
      case GoalCategory.exercise:
        return '🏋️';
      case GoalCategory.learning:
        return '📚';
      case GoalCategory.creative:
        return '🎨';
      case GoalCategory.work:
        return '💼';
      case GoalCategory.wellness:
        return '🧘';
      case GoalCategory.social:
        return '👥';
      case GoalCategory.chores:
        return '🏠';
      case GoalCategory.other:
        return '📌';
    }
  }

  /// Get optimal hours for this category (research-backed)
  /// Returns list of preferred hours (0-23) in order of preference
  List<int> get optimalHours {
    switch (this) {
      case GoalCategory.exercise:
        // Research: Morning exercise has highest completion rates
        // Alternative: After work for stress relief
        return [6, 7, 8, 17, 18, 19];
        
      case GoalCategory.learning:
        // Research: Learning best when well-rested (morning)
        // Alternative: Evening review for memory consolidation
        return [9, 10, 11, 20, 21];
        
      case GoalCategory.creative:
        // Research: Creative work often better when mind wanders
        // Peak creativity often in evening or after light physical activity
        return [20, 21, 22, 10, 11];
        
      case GoalCategory.work:
        // Standard productive hours, avoiding post-lunch dip
        return [9, 10, 11, 14, 15, 16];
        
      case GoalCategory.wellness:
        // Morning: Sets tone for the day
        // Evening: Wind-down, relaxation
        return [6, 7, 8, 21, 22];
        
      case GoalCategory.social:
        // After work hours when people are available
        return [18, 19, 20];
        
      case GoalCategory.chores:
        // Afternoon when energy dips (good for routine tasks)
        return [14, 15, 16, 17];
        
      case GoalCategory.other:
        // Default to standard working hours
        return [9, 10, 11, 14, 15, 16];
    }
  }

  /// Get the best single hour for this category
  int get bestHour => optimalHours.first;

  /// Check if a given hour is optimal for this category
  bool isOptimalHour(int hour) => optimalHours.contains(hour);

  /// Get a score (0-1) for how good a specific hour is for this category
  double getHourScore(int hour) {
    final index = optimalHours.indexOf(hour);
    if (index == -1) return 0.3; // Base score for non-optimal hours
    
    // Higher score for hours earlier in the preference list
    return 1.0 - (index * 0.1).clamp(0.0, 0.7);
  }
}

/// Service class for category-based scheduling logic
class GoalCategoryService {
  /// Get all categories as a list
  static List<GoalCategory> get allCategories => GoalCategory.values;

  /// Get category from index (for Isar storage)
  static GoalCategory fromIndex(int index) {
    if (index < 0 || index >= GoalCategory.values.length) {
      return GoalCategory.other;
    }
    return GoalCategory.values[index];
  }

  /// Find the best hour for a goal considering category and available slots
  static int? findBestHour({
    required GoalCategory category,
    required List<int> availableHours,
  }) {
    // First, try optimal hours in order of preference
    for (final hour in category.optimalHours) {
      if (availableHours.contains(hour)) {
        return hour;
      }
    }
    
    // If no optimal hour available, return first available
    return availableHours.isNotEmpty ? availableHours.first : null;
  }

  /// Score a time slot for a goal based on its category
  static double scoreTimeSlot({
    required GoalCategory category,
    required int hour,
    int? taskOrderInDay,
  }) {
    double score = category.getHourScore(hour);
    
    // Bonus/penalty based on task order
    if (taskOrderInDay != null) {
      switch (category) {
        case GoalCategory.exercise:
          // Exercise better as first task
          if (taskOrderInDay == 1) score += 0.1;
          break;
        case GoalCategory.creative:
          // Creative work can benefit from "warm up" tasks before
          if (taskOrderInDay >= 2) score += 0.05;
          break;
        case GoalCategory.chores:
          // Chores fine later in the day
          if (taskOrderInDay >= 3) score += 0.05;
          break;
        default:
          break;
      }
    }
    
    return score.clamp(0.0, 1.0);
  }
}
