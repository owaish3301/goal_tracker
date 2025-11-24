import 'package:flutter/material.dart';

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
