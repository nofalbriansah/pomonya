import 'dart:ui';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF00F0FF); // Neon Cyan
  static const Color primaryDark = Color(0xFF0891B2); // Cyan-600

  // Background & Surface - Light
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(
    0xFFF3F4FB,
  ); // Slightly bluish gray for contrast
  static const Color textMainLight = Color(0xFF1F2937); // Gray-800
  static const Color textSubLight = Color(0xFF6B7280); // Gray-500
  static const Color borderLight = Color(0xFFE5E7EB); // Gray-200

  // Background & Surface - Dark
  static const Color backgroundDark = Color(0xFF0B0E14); // Deep Navy/Black
  static const Color surfaceDark = Color(0xFF151A23); // Dark Slate
  static const Color textMainDark = Color(0xFFF8FAFC); // Slate-50
  static const Color textSubDark = Color(0xFF94A3B8); // Slate-400
  static const Color borderDark = Color(0x1AFFFFFF); // White with 10% opacity

  // Accent Colors (Neon Arcade)
  static const Color accentPink = Color(0xFFE879F9);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentYellow = Color(0xFFFBFF00);

  // Legacy / Utility (Updated primary to Neon Cyan)
  static const Color electricBlue = Color(0xFF00F0FF);
  static const Color neonFuchsia = Color(0xFFE879F9);
  static const Color neonPink = Color(0xFFE879F9);
  static const Color glassBorder = Color(0x14FFFFFF);
}

class AppConstants {
  static const String appName = 'Pomonya';
  static const String slogan = 'Mpus siap bantu kamu terus fokus dan produktif';

  // Default Timers (in seconds)
  static const int defaultFocusDuration = 25 * 60;
  static const int defaultShortBreakDuration = 5 * 60;
  static const int defaultLongBreakDuration = 15 * 60;

  // Database Boxes
  static const String userBox = 'userBox';
  static const String settingsBox = 'settingsBox';
}

class AppSpacing {
  static const double xs = 4.0;
  static const double s = 8.0;
  static const double m = 16.0;
  static const double l = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  static const double borderRadiusS = 8.0;
  static const double borderRadiusM = 16.0;
  static const double borderRadiusL = 24.0;
}
