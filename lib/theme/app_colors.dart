import 'package:flutter/material.dart';

/// BarGenie Design System — "The Cinematic Alchemist" color tokens.
class AppColors {
  AppColors._();

  // ── Surface Hierarchy ──────────────────────────────────
  static const Color surface = Color(0xFF131313);
  static const Color surfaceContainerLowest = Color(0xFF0E0E0E);
  static const Color surfaceContainer = Color(0xFF201F1F);
  static const Color surfaceContainerHigh = Color(0xFF2A2A2A);
  static const Color surfaceContainerHighest = Color(0xFF353534);
  static const Color surfaceVariant = Color(0xFF201F1F); // for glass overlays

  // ── Text ───────────────────────────────────────────────
  static const Color primaryText = Color(0xFFEAEAEA);
  static const Color labelText = Color(0xFFD1C5B2);
  static const Color placeholderText = Color(0xFF6B6B6B);

  // ── Accent: Gold ───────────────────────────────────────
  static const Color primaryGold = Color(0xFFEBC165);
  static const Color primaryGoldDark = Color(0xFFC9A24A);

  // ── Accent: Green ──────────────────────────────────────
  static const Color successGreen = Color(0xFF004B23);
  static const Color activeGreen = Color(0xFF2DC653);

  // ── Borders / Ghost Lines ──────────────────────────────
  static const Color outlineVariant = Color(0xFF6B6B6B);
  static Color ghostBorder = outlineVariant.withValues(alpha: 0.15);

  // ── Gradients ──────────────────────────────────────────
  static const LinearGradient goldGradient = LinearGradient(
    colors: [primaryGold, primaryGoldDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradientHorizontal = LinearGradient(
    colors: [primaryGold, primaryGoldDark],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
