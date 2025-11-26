import 'package:flutter/material.dart';
import 'package:goal_tracker/data/models/goal_category.dart';

class AppConstants {
  // Goal Colors
  static const List<Color> goalColors = [
    Color(0xFFFF453A), // Red
    Color(0xFFFF9F0A), // Orange
    Color(0xFFFFD60A), // Yellow
    Color(0xFF32D74B), // Green
    Color(0xFF64D2FF), // Blue
    Color(0xFFBF5AF2), // Purple
    Color(0xFFFF375F), // Pink
    Color(0xFF5AC8FA), // Teal
  ];

  // Category-specific colors for better visual distinction
  static const Map<GoalCategory, List<Color>> categoryColors = {
    GoalCategory.exercise: [
      Color(0xFFFF453A), // Red
      Color(0xFFFF9F0A), // Orange
      Color(0xFFFF6B35), // Coral
    ],
    GoalCategory.learning: [
      Color(0xFF64D2FF), // Blue
      Color(0xFF5AC8FA), // Teal
      Color(0xFF007AFF), // System Blue
    ],
    GoalCategory.creative: [
      Color(0xFFBF5AF2), // Purple
      Color(0xFFFF375F), // Pink
      Color(0xFFAF52DE), // Magenta
    ],
    GoalCategory.work: [
      Color(0xFF32D74B), // Green
      Color(0xFF30D158), // Bright Green
      Color(0xFF34C759), // System Green
    ],
    GoalCategory.wellness: [
      Color(0xFF5E5CE6), // Indigo
      Color(0xFF8E8E93), // Gray
      Color(0xFF48CAE4), // Sky
    ],
    GoalCategory.social: [
      Color(0xFFFFD60A), // Yellow
      Color(0xFFFFCC00), // Gold
      Color(0xFFFFC107), // Amber
    ],
    GoalCategory.chores: [
      Color(0xFF8E8E93), // Gray
      Color(0xFF636366), // Dark Gray
      Color(0xFFAEAEB2), // Light Gray
    ],
    GoalCategory.other: [
      Color(0xFF64D2FF), // Blue
      Color(0xFFBF5AF2), // Purple
      Color(0xFF32D74B), // Green
    ],
  };

  // Category-specific icons with multiple options per category
  static const Map<GoalCategory, List<String>> categoryIcons = {
    GoalCategory.exercise: [
      'fitness_center',
      'directions_run',
      'sports_gymnastics',
      'pool',
      'sports_tennis',
      'sports_basketball',
    ],
    GoalCategory.learning: [
      'school',
      'menu_book',
      'science',
      'calculate',
      'language',
      'computer',
    ],
    GoalCategory.creative: [
      'palette',
      'music_note',
      'camera_alt',
      'brush',
      'design_services',
      'auto_awesome',
    ],
    GoalCategory.work: [
      'work',
      'business_center',
      'laptop_mac',
      'code',
      'analytics',
      'trending_up',
    ],
    GoalCategory.wellness: [
      'self_improvement',
      'spa',
      'bedtime',
      'favorite',
      'local_hospital',
      'psychology',
    ],
    GoalCategory.social: [
      'people',
      'groups',
      'family_restroom',
      'celebration',
      'emoji_people',
      'handshake',
    ],
    GoalCategory.chores: [
      'home',
      'cleaning_services',
      'local_laundry_service',
      'shopping_cart',
      'build',
      'handyman',
    ],
    GoalCategory.other: [
      'star',
      'emoji_events',
      'flag',
      'lightbulb',
      'rocket_launch',
      'auto_awesome',
    ],
  };

  // Goal Icons
  static const Map<String, List<IconData>> goalIcons = {
    'Fitness': [
      Icons.fitness_center,
      Icons.directions_run,
      Icons.sports_gymnastics,
      Icons.pool,
      Icons.sports_tennis,
      Icons.sports_basketball,
    ],
    'Education': [
      Icons.school,
      Icons.menu_book,
      Icons.science,
      Icons.calculate,
      Icons.language,
      Icons.computer,
    ],
    'Work': [
      Icons.work,
      Icons.business_center,
      Icons.laptop_mac,
      Icons.code,
      Icons.design_services,
      Icons.analytics,
    ],
    'Hobbies': [
      Icons.palette,
      Icons.music_note,
      Icons.camera_alt,
      Icons.videogame_asset,
      Icons.sports_esports,
      Icons.brush,
    ],
    'Health': [
      Icons.favorite,
      Icons.local_hospital,
      Icons.self_improvement,
      Icons.spa,
      Icons.bedtime,
      Icons.restaurant,
    ],
    'Other': [
      Icons.star,
      Icons.emoji_events,
      Icons.flag,
      Icons.lightbulb,
      Icons.rocket_launch,
      Icons.auto_awesome,
    ],
  };

  // Icon name mapping (for storage)
  static final Map<IconData, String> iconNames = {
    Icons.fitness_center: 'fitness_center',
    Icons.directions_run: 'directions_run',
    Icons.sports_gymnastics: 'sports_gymnastics',
    Icons.pool: 'pool',
    Icons.sports_tennis: 'sports_tennis',
    Icons.sports_basketball: 'sports_basketball',
    Icons.school: 'school',
    Icons.menu_book: 'menu_book',
    Icons.science: 'science',
    Icons.calculate: 'calculate',
    Icons.language: 'language',
    Icons.computer: 'computer',
    Icons.work: 'work',
    Icons.business_center: 'business_center',
    Icons.laptop_mac: 'laptop_mac',
    Icons.code: 'code',
    Icons.design_services: 'design_services',
    Icons.analytics: 'analytics',
    Icons.palette: 'palette',
    Icons.music_note: 'music_note',
    Icons.camera_alt: 'camera_alt',
    Icons.videogame_asset: 'videogame_asset',
    Icons.sports_esports: 'sports_esports',
    Icons.brush: 'brush',
    Icons.favorite: 'favorite',
    Icons.local_hospital: 'local_hospital',
    Icons.self_improvement: 'self_improvement',
    Icons.spa: 'spa',
    Icons.bedtime: 'bedtime',
    Icons.restaurant: 'restaurant',
    Icons.star: 'star',
    Icons.emoji_events: 'emoji_events',
    Icons.flag: 'flag',
    Icons.lightbulb: 'lightbulb',
    Icons.rocket_launch: 'rocket_launch',
    Icons.auto_awesome: 'auto_awesome',
    // Additional icons for categories
    Icons.trending_up: 'trending_up',
    Icons.psychology: 'psychology',
    Icons.people: 'people',
    Icons.groups: 'groups',
    Icons.family_restroom: 'family_restroom',
    Icons.celebration: 'celebration',
    Icons.emoji_people: 'emoji_people',
    Icons.handshake: 'handshake',
    Icons.home: 'home',
    Icons.cleaning_services: 'cleaning_services',
    Icons.local_laundry_service: 'local_laundry_service',
    Icons.shopping_cart: 'shopping_cart',
    Icons.build: 'build',
    Icons.handyman: 'handyman',
  };

  // Reverse mapping (for retrieval)
  static IconData getIconFromName(String name) {
    return iconNames.entries
        .firstWhere(
          (entry) => entry.value == name,
          orElse: () => const MapEntry(Icons.star, 'star'),
        )
        .key;
  }

  /// Get the next available icon for a category based on existing goals
  /// Uses round-robin to cycle through icons if all are used
  static String getNextIconForCategory(
    GoalCategory category,
    List<String> usedIcons,
  ) {
    final icons = categoryIcons[category] ?? categoryIcons[GoalCategory.other]!;
    
    // Find first unused icon in category
    for (final icon in icons) {
      if (!usedIcons.contains(icon)) {
        return icon;
      }
    }
    
    // All icons used, cycle through (round-robin)
    final categoryUsedCount = usedIcons
        .where((icon) => icons.contains(icon))
        .length;
    return icons[categoryUsedCount % icons.length];
  }

  /// Get the next available color for a category based on existing goals
  /// Uses round-robin to cycle through colors if all are used
  static Color getNextColorForCategory(
    GoalCategory category,
    List<Color> usedColors,
  ) {
    final colors = categoryColors[category] ?? categoryColors[GoalCategory.other]!;
    
    // Find first unused color in category
    for (final color in colors) {
      if (!usedColors.contains(color)) {
        return color;
      }
    }
    
    // All colors used, cycle through (round-robin)
    final categoryUsedCount = usedColors
        .where((color) => colors.contains(color))
        .length;
    return colors[categoryUsedCount % colors.length];
  }

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Defaults
  static const int minDurationMinutes = 15;
  static const int defaultDurationMinutes = 60;
  static const Color defaultGoalColor = Color(0xFF64D2FF); // Blue
  static const String defaultIconName = 'star';

  // Day Names
  static const List<String> dayNames = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  static const List<String> dayFullNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
}
