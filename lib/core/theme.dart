import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.darkBg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.electricBlue,
        onPrimary: Colors.black,
        secondary: AppColors.neonFuchsia,
        onSecondary: Colors.black,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textPrimary,
        surfaceContainer: AppColors.surfaceDark,
        outline: AppColors.glassBorder,
        tertiary: AppColors.neonPink,
      ),
      textTheme: _buildTextTheme(
        AppColors.textPrimary,
        AppColors.textSecondary,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.glassBorder, width: 1),
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.glassBorder,
        thickness: 1,
        space: AppSpacing.m,
      ),
    );
  }

  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.lightBg,
      colorScheme: const ColorScheme.light(
        primary: AppColors.electricBlue,
        onPrimary: Colors.white,
        secondary: AppColors.neonFuchsia,
        onSecondary: Colors.white,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textPrimaryLight,
        surfaceContainer: AppColors.surfaceLight,
        outline: AppColors.glassBorderLight,
        tertiary: AppColors.neonPink,
      ),
      textTheme: _buildTextTheme(
        AppColors.textPrimaryLight,
        AppColors.textSecondaryLight,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.glassBorderLight, width: 1),
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.glassBorderLight,
        thickness: 1,
        space: AppSpacing.m,
      ),
    );
  }

  static TextTheme _buildTextTheme(Color primaryColor, Color secondaryColor) {
    return TextTheme(
      displayLarge: GoogleFonts.pressStart2p(color: primaryColor, fontSize: 24),
      displayMedium: GoogleFonts.pressStart2p(
        color: primaryColor,
        fontSize: 20,
      ),
      displaySmall: GoogleFonts.pressStart2p(color: primaryColor, fontSize: 14),
      headlineMedium: GoogleFonts.spaceGrotesk(
        color: primaryColor,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: GoogleFonts.spaceGrotesk(
        color: primaryColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: GoogleFonts.spaceGrotesk(
        color: primaryColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.spaceGrotesk(color: primaryColor, fontSize: 16),
      bodyMedium: GoogleFonts.spaceGrotesk(color: secondaryColor, fontSize: 14),
      bodySmall: GoogleFonts.spaceGrotesk(color: secondaryColor, fontSize: 12),
      labelLarge: GoogleFonts.pressStart2p(color: primaryColor, fontSize: 10),
    );
  }
}
