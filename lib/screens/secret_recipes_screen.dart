import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../providers/secret_recipe_provider.dart';
import '../providers/xp_provider.dart';
import '../models/cocktail.dart';

class SecretRecipesScreen extends ConsumerWidget {
  const SecretRecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipes = ref.watch(secretRecipeProvider);
    final unlocked = ref.watch(unlockedRecipesProvider);
    final xpState = ref.watch(xpProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primaryGold),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Gizli Reçeteler',
          style: GoogleFonts.newsreader(
            fontSize: 22, fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic, color: AppColors.primaryGold,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          final isUnlocked = unlocked[index];
          return _buildRecipeCard(context, recipe, isUnlocked, xpState.level);
        },
      ),
    );
  }

  Widget _buildRecipeCard(BuildContext context, SecretRecipe recipe, bool isUnlocked, int currentLevel) {
    return GestureDetector(
      onTap: isUnlocked ? () => _showRecipeDetail(context, recipe.cocktail) : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUnlocked
              ? AppColors.surfaceContainer.withValues(alpha: 0.9)
              : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnlocked
                ? AppColors.primaryGold.withValues(alpha: 0.4)
                : AppColors.ghostBorder,
            width: isUnlocked ? 1 : 0.5,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? AppColors.primaryGold.withValues(alpha: 0.15)
                    : AppColors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isUnlocked ? Icons.auto_awesome : Icons.lock_outline_rounded,
                color: isUnlocked ? AppColors.primaryGold : AppColors.placeholderText,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isUnlocked ? recipe.cocktail.name : '??? Gizli Reçete',
                    style: GoogleFonts.newsreader(
                      fontSize: 18, fontWeight: FontWeight.w600,
                      color: isUnlocked ? AppColors.primaryGold : AppColors.placeholderText,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isUnlocked
                        ? recipe.cocktail.description
                        : 'Seviye ${recipe.requiredLevel} gerekli',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: isUnlocked ? AppColors.labelText : AppColors.placeholderText,
                    ),
                    maxLines: 2, overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isUnlocked
                    ? AppColors.primaryGold.withValues(alpha: 0.2)
                    : AppColors.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Lv.${recipe.requiredLevel}',
                style: GoogleFonts.manrope(
                  fontSize: 12, fontWeight: FontWeight.w700,
                  color: isUnlocked ? AppColors.primaryGold : AppColors.placeholderText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRecipeDetail(BuildContext context, Cocktail cocktail) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: Container(width: 40, height: 4,
                  decoration: BoxDecoration(color: AppColors.ghostBorder, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(cocktail.imagePath, height: 200, width: double.infinity, fit: BoxFit.cover,
                  errorBuilder: (c,e,s) => Container(height: 200, color: AppColors.surface,
                    child: const Icon(Icons.local_bar, color: AppColors.primaryGold, size: 48)),
                ),
              ),
              const SizedBox(height: 20),
              Text(cocktail.name, style: GoogleFonts.newsreader(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.primaryGold, fontStyle: FontStyle.italic)),
              const SizedBox(height: 8),
              Text(cocktail.description, style: GoogleFonts.manrope(fontSize: 14, color: AppColors.labelText)),
              const SizedBox(height: 20),
              Text('Malzemeler', style: GoogleFonts.newsreader(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.primaryText)),
              const SizedBox(height: 12),
              ...cocktail.ingredients.map((ing) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(children: [
                  const Icon(Icons.circle, size: 6, color: AppColors.primaryGold),
                  const SizedBox(width: 10),
                  Text('${ing.amount} ${ing.name}', style: GoogleFonts.manrope(fontSize: 14, color: AppColors.primaryText)),
                ]),
              )),
              const SizedBox(height: 20),
              Text('Hazırlanışı', style: GoogleFonts.newsreader(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.primaryText)),
              const SizedBox(height: 12),
              Text(cocktail.preparation, style: GoogleFonts.manrope(fontSize: 14, color: AppColors.labelText, height: 1.6)),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
