import 'dart:ui';

class AppColors {
  // Deep Background: #0B0E14
  static const Color deepBackground = Color(0xFF0B0E14);

  // Surface Dark: #161B28
  static const Color surfaceDark = Color(0xFF161B28);

  // Electric Blue: #00F0FF (Primary)
  static const Color electricBlue = Color(0xFF00F0FF);

  // Neon Fuchsia: #F0ABFC (Accent)
  static const Color neonFuchsia = Color(0xFFF0ABFC);

  // Glass Border: rgba(255,255,255,0.08)
  static const Color glassBorder = Color(0x14FFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xB3FFFFFF);
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
