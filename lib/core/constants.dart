import 'dart:ui';

class AppColors {
  // Primary / Neon Colors
  static const Color primary = Color(0xFF00F0FF); // Electric Blue
  static const Color electricBlue = Color(0xFF00F0FF);
  static const Color neonFuchsia = Color(0xFFF0ABFC); // Accent
  static const Color neonPink = Color(0xFFD946EF);

  // Backgrounds
  static const Color darkBg = Color(0xFF0B0E14); // Deep Charcoal / Navy
  static const Color deepBackground = Color(0xFF0B0E14);
  static const Color surfaceDark = Color(
    0xFF161B28,
  ); // Slightly lighter for panels

  // Utility
  static const Color glassBorder = Color(
    0x14FFFFFF,
  ); // rgba(255, 255, 255, 0.08)
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xB3FFFFFF); // ~70% opacity

  // Light Mode Colors
  static const Color lightBg = Color(0xFFF8FAFC); // Slate-50
  static const Color surfaceLight = Color(0xFFFFFFFF); // White
  static const Color textPrimaryLight = Color(0xFF1E293B); // Slate-800
  static const Color textSecondaryLight = Color(0xFF64748B); // Slate-500
  static const Color glassBorderLight = Color(
    0x14000000,
  ); // rgba(0, 0, 0, 0.08)
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
