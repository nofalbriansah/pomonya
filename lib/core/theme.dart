import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: Colors.black,
        secondary: AppColors.accentPink,
        onSecondary: Colors.black,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textMainDark,
        surfaceContainer: AppColors.surfaceDark,
        outline: AppColors.borderDark,
        tertiary: AppColors.accentPurple,
      ),
      textTheme: _buildTextTheme(AppColors.textMainDark, AppColors.textSubDark),
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.borderDark, width: 1),
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderDark,
        thickness: 1,
        space: AppSpacing.m,
      ),
    );
  }

  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.primary,
        onSecondary: Colors.white,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textMainLight,
        surfaceContainer: AppColors.surfaceLight,
        outline: AppColors.borderLight,
      ),
      textTheme: _buildTextTheme(
        AppColors.textMainLight,
        AppColors.textSubLight,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.borderLight, width: 1),
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderLight,
        thickness: 1,
        space: AppSpacing.m,
      ),
    );
  }

  static TextTheme _buildTextTheme(Color primaryColor, Color secondaryColor) {
    return TextTheme(
      displayLarge: GoogleFonts.pressStart2p(color: primaryColor, fontSize: 48),
      displayMedium: GoogleFonts.pressStart2p(
        color: primaryColor,
        fontSize: 32,
      ),
      displaySmall: GoogleFonts.pressStart2p(color: primaryColor, fontSize: 14),
      headlineMedium: GoogleFonts.inter(
        color: primaryColor,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: GoogleFonts.inter(
        color: primaryColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: GoogleFonts.inter(
        color: primaryColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: GoogleFonts.inter(
        color: primaryColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.inter(color: primaryColor, fontSize: 16),
      bodyMedium: GoogleFonts.inter(color: secondaryColor, fontSize: 14),
      bodySmall: GoogleFonts.inter(color: secondaryColor, fontSize: 12),
      labelLarge: GoogleFonts.inter(
        color: primaryColor,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
