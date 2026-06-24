import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cocktail.dart';
import '../theme/app_colors.dart';

/// Luxury cocktail card with glassmorphism and image bleed.
class CocktailCard extends StatelessWidget {
  final Cocktail cocktail;
  final VoidCallback? onTap;

  const CocktailCard({
    super.key,
    required this.cocktail,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 240,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.ghostBorder,
                width: 0.5,
              ),
            ),
            child: Stack(
              children: [
                // ── Network Image Background ──
                Positioned.fill(
                  child: cocktail.imagePath.isNotEmpty
                      ? Image.network(
                          cocktail.imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) =>
                              const Icon(Icons.broken_image, color: Colors.grey),
                        )
                      : Container(color: AppColors.surfaceContainer),
                ),
                // ── Dark Overlays for Text Readability ──
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.surface.withValues(alpha: 0.1),
                          AppColors.surface.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                ),
                // ── Category label ──
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGold.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      cocktail.category.toUpperCase(),
                      style: GoogleFonts.manrope(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryGold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                // ── Rating badge ──
                Positioned(
                  top: 12,
                  right: 12,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded,
                          size: 14, color: AppColors.primaryGold),
                      const SizedBox(width: 2),
                      Text(
                        cocktail.rating.toStringAsFixed(1),
                        style: GoogleFonts.newsreader(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryGold,
                        ),
                      ),
                    ],
                  ),
                ),
                // ── Bottom text section ──
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.surfaceContainer.withValues(alpha: 0.0),
                          AppColors.surfaceContainer.withValues(alpha: 0.95),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          cocktail.name,
                          style: GoogleFonts.newsreader(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryText,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cocktail.description,
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            color: AppColors.labelText,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
