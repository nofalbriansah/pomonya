import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.electricBlue,
        secondary: AppColors.neonFuchsia,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textPrimary,
        tertiary: AppColors.neonPink,
      ),
      fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.pressStart2p(
          color: AppColors.textPrimary,
          fontSize: 24,
        ),
        displayMedium: GoogleFonts.pressStart2p(
          color: AppColors.textPrimary,
          fontSize: 20,
        ),
        displaySmall: GoogleFonts.pressStart2p(
          color: AppColors.textPrimary,
          fontSize: 14,
        ),
        bodyLarge: GoogleFonts.spaceGrotesk(
          color: AppColors.textPrimary,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.spaceGrotesk(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        bodySmall: GoogleFonts.spaceGrotesk(
          color: AppColors.textSecondary,
          fontSize: 12,
        ),
        labelLarge: GoogleFonts.pressStart2p(
          color: AppColors.textPrimary,
          fontSize: 10,
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
