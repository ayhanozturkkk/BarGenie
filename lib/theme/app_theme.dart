import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// BarGenie master theme — dark-only, luxury editorial.
class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.surface,
      canvasColor: AppColors.surface,

      // ── Color Scheme ─────────────────────────────────
      colorScheme: const ColorScheme.dark(
        surface: AppColors.surface,
        primary: AppColors.primaryGold,
        primaryContainer: AppColors.primaryGoldDark,
        secondary: AppColors.surfaceContainer,
        onSurface: AppColors.primaryText,
        onPrimary: AppColors.surface,
        outline: AppColors.outlineVariant,
      ),

      // ── Typography ───────────────────────────────────
      textTheme: _buildTextTheme(),

      // ── AppBar ───────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.newsreader(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryGold,
          fontStyle: FontStyle.italic,
        ),
      ),

      // ── Bottom Nav ───────────────────────────────────
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceContainerLowest,
        selectedItemColor: AppColors.primaryGold,
        unselectedItemColor: AppColors.placeholderText,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showUnselectedLabels: true,
      ),

      // ── Cards ────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainer.withValues(alpha: 0.9),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // ── Input / Search Fields ────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerHighest,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryGold, width: 1),
        ),
        hintStyle: GoogleFonts.manrope(
          fontSize: 14,
          color: AppColors.placeholderText,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),

      // ── Divider — effectively hidden ─────────────────
      dividerTheme: DividerThemeData(
        color: AppColors.ghostBorder,
        thickness: 0.5,
        space: 32,
      ),

      // ── Splash / Ripple ──────────────────────────────
      splashColor: AppColors.primaryGold.withValues(alpha: 0.08),
      highlightColor: AppColors.primaryGold.withValues(alpha: 0.05),
    );
  }

  // ── Text Theme (Newsreader + Manrope) ──────────────────
  static TextTheme _buildTextTheme() {
    final headlineStyle = GoogleFonts.newsreader(color: AppColors.primaryText);
    final bodyStyle = GoogleFonts.manrope(color: AppColors.primaryText);

    return TextTheme(
      // Display — hero screens
      displayLarge: headlineStyle.copyWith(
        fontSize: 56,
        fontWeight: FontWeight.w700,
        height: 1.1,
      ),
      displayMedium: headlineStyle.copyWith(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        height: 1.15,
      ),
      displaySmall: headlineStyle.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),

      // Headlines — section headers, cocktail names
      headlineLarge: headlineStyle.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: headlineStyle.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: headlineStyle.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),

      // Titles — card titles
      titleLarge: bodyStyle.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: bodyStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: bodyStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),

      // Body text
      bodyLarge: bodyStyle.copyWith(fontSize: 16),
      bodyMedium: bodyStyle.copyWith(fontSize: 14),
      bodySmall: bodyStyle.copyWith(fontSize: 12),

      // Labels
      labelLarge: bodyStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
      ),
      labelMedium: bodyStyle.copyWith(
        fontSize: 12,
        color: AppColors.labelText,
      ),
      labelSmall: bodyStyle.copyWith(
        fontSize: 10,
        color: AppColors.labelText,
        letterSpacing: 0.6,
      ),
    );
  }
}
