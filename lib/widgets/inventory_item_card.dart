import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/ingredient.dart';
import '../theme/app_colors.dart';

/// Inventory item card with +/- quantity controls.
class InventoryItemCard extends StatelessWidget {
  final Ingredient ingredient;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const InventoryItemCard({
    super.key,
    required this.ingredient,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // ── Thumbnail placeholder ──
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.liquor_rounded,
              color: AppColors.labelText.withValues(alpha: 0.5),
              size: 32,
            ),
          ),
          const SizedBox(width: 16),

          // ── Name & stock ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ingredient.name.toUpperCase(),
                  style: GoogleFonts.newsreader(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryGold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.activeGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Stok: %${(ingredient.stockPercent * 100).toInt()} • ${ingredient.isActive ? "Aktif" : "Pasif"}',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: AppColors.activeGreen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Quantity & controls ──
          Column(
            children: [
              _buildCircleButton(Icons.remove, onDecrement),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  '${ingredient.quantity}${ingredient.unit == "adet" ? "" : " ${ingredient.unit}"}',
                  style: GoogleFonts.newsreader(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                ),
              ),
              _buildCircleButton(Icons.add, onIncrement),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHighest.withValues(alpha: 0.8),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          color: AppColors.primaryText,
        ),
      ),
    );
  }
}
