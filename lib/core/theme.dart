import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.deepBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.electricBlue,
        secondary: AppColors.neonFuchsia,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textPrimary,
      ),
      fontFamily: GoogleFonts.lexend().fontFamily,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.pressStart2p(
          color: AppColors.textPrimary,
          fontSize: 24,
        ),
        displayMedium: GoogleFonts.pressStart2p(
          color: AppColors.textPrimary,
          fontSize: 20,
        ),
        bodyLarge: GoogleFonts.lexend(
          color: AppColors.textPrimary,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.lexend(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.glassBorder, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
