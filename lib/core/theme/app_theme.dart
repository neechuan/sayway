import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Brand
  static const primary = Color(0xFF5B4FE9);
  static const primaryLight = Color(0xFF8B82F0);
  static const primaryDark = Color(0xFF3D34C7);

  // Accent
  static const accent = Color(0xFFFF6B6B);
  static const accentGreen = Color(0xFF4ECDC4);
  static const accentYellow = Color(0xFFFFD93D);
  static const accentOrange = Color(0xFFFF9F43);

  // Category colours
  static const catFood = Color(0xFFFF9F43);
  static const catFeelings = Color(0xFFFF6B6B);
  static const catPeople = Color(0xFF4ECDC4);
  static const catActions = Color(0xFF5B4FE9);
  static const catPlaces = Color(0xFF26de81);
  static const catThings = Color(0xFFa29bfe);
  static const catTime = Color(0xFFfd79a8);
  static const catCore = Color(0xFF636e72);

  // Backgrounds
  static const bg = Color(0xFF0F0E1A);
  static const surface = Color(0xFF1A1928);
  static const surfaceCard = Color(0xFF232235);
  static const surfaceElevated = Color(0xFF2D2B45);

  // Text
  static const textPrimary = Color(0xFFF5F4FF);
  static const textSecondary = Color(0xFFAEABD0);
  static const textMuted = Color(0xFF6B6891);

  // Utility
  static const border = Color(0xFF2D2B45);
  static const success = Color(0xFF4ECDC4);
  static const error = Color(0xFFFF6B6B);
  static const white = Color(0xFFFFFFFF);
}

class AppTheme {
  static ThemeData get dark {
    final base = ThemeData.dark();
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: GoogleFonts.nunitoTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.nunito(
          color: AppColors.textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w800,
        ),
        titleLarge: GoogleFonts.nunito(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: GoogleFonts.nunito(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: GoogleFonts.nunito(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        labelSmall: GoogleFonts.nunito(
          color: AppColors.textMuted,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.nunito(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.textSecondary),
      dividerColor: AppColors.border,
      useMaterial3: true,
    );
  }
}
