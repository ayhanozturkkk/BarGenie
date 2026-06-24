import '../models/cocktail.dart';
import '../models/ingredient.dart';
import '../utils/image_utils.dart';

class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  ValidationResult(this.isValid, [this.errorMessage]);
}

class RecommendationResult {
  final Cocktail cocktail;
  final int matchedCount;
  final int missingCount;
  final double matchPercentage;

  RecommendationResult({
    required this.cocktail,
    required this.matchedCount,
    required this.missingCount,
    required this.matchPercentage,
  });
}

class RecommendationEngine {
  /// Analyzes the user's active bar ingredients and determines the best possible cocktail to make.
  /// If the inventory is completely empty, it defaults to the highest-rated cocktail.
  static RecommendationResult getBestMatch(
    List<Ingredient> myBar,
    List<Cocktail> database,
  ) {
    if (database.isEmpty) {
      throw Exception('Cocktail database is empty.');
    }

    final activeInventory = myBar.where((i) => i.isActive && i.quantity > 0).toList();

    // If completely empty, recommend first classic
    if (activeInventory.isEmpty) {
      return RecommendationResult(
        cocktail: database.first,
        matchedCount: 0,
        missingCount: database.first.ingredients.length,
        matchPercentage: 0.0,
      );
    }

    RecommendationResult? bestMatch;

    for (final cocktail in database) {
      int matched = 0;
      int missing = 0;

      for (final reqIng in cocktail.ingredients) {
        final hasIngredient = activeInventory.any((b) => 
            b.name.trim().toLowerCase() == reqIng.name.trim().toLowerCase());

        if (hasIngredient) {
          matched++;
        } else {
          missing++;
        }
      }

      final totalRequired = cocktail.ingredients.length;
      final percentage = totalRequired > 0 ? (matched / totalRequired) : 1.0;

      final currentRes = RecommendationResult(
        cocktail: cocktail,
        matchedCount: matched,
        missingCount: missing,
        matchPercentage: percentage,
      );

      if (bestMatch == null) {
        bestMatch = currentRes;
      } else {
        // Algorithm:
        // Priority 1: Highest Match Percentage
        // Priority 2: Highest Absolute Match Count (if percentages are equal)
        // Priority 3: Lowest Missing Count 
        if (currentRes.matchPercentage > bestMatch.matchPercentage) {
          bestMatch = currentRes;
        } else if (currentRes.matchPercentage == bestMatch.matchPercentage) {
          if (currentRes.matchedCount > bestMatch.matchedCount) {
             bestMatch = currentRes;
          } else if (currentRes.matchedCount == bestMatch.matchedCount) {
             if (currentRes.missingCount < bestMatch.missingCount) {
               bestMatch = currentRes;
             }
          }
        }
      }
    }

    return bestMatch!;
  }

  static ValidationResult checkClashes(List<Ingredient> myBar) {
    final active = myBar.where((i) => i.isActive && i.quantity > 0).toList();
    
    // Clash 1: Mixing Straight Whiskey and Vodka
    final hasWhiskey = active.any((i) => i.name.toLowerCase().contains('viski') || i.name.toLowerCase().contains('bourbon'));
    final hasVodka = active.any((i) => i.name.toLowerCase().contains('vodka'));
    
    if (hasWhiskey && hasVodka) {
      return ValidationResult(false, 'Uyumsuz Karışım: Viski ve Votka gibi temel içkileri doğrudan karıştırmak iyi bir tat profili oluşturmaz.');
    }

    // Clash 2: More than 2 Base Spirits without sufficient mixers can be dangerous/illogical
    final baseSpiritsCount = active.where((i) => i.category == 'Temel İçkiler').length;
    final mixersCount = active.where((i) => i.category == 'Karıştırıcılar' || i.category == 'Meyve Suları' || i.category == 'Şuruplar').length;

    if (baseSpiritsCount >= 2 && mixersCount == 0) {
      return ValidationResult(false, 'Tehlikeli Karışım: Birden fazla temel alkolü yumuşatıcı veya tatlandırıcı olmadan karıştırmak tavsiye edilmez.');
    }

    return ValidationResult(true);
  }

  static Cocktail generateCustomCocktail(List<Ingredient> myBar) {
    final active = myBar.where((i) => i.isActive && i.quantity > 0).toList();
    if (active.isEmpty) {
      throw Exception('Malzeme seçilmedi.');
    }

    // ── Category-based selection for a realistic cocktail ──
    final baseSpirits = active.where((i) => i.category == 'Temel İçkiler').toList();
    final liqueurs = active.where((i) => i.category == 'Likörler & Amari').toList();
    final juices = active.where((i) => i.category == 'Meyve Suları').toList();
    final syrups = active.where((i) => i.category == 'Şuruplar').toList();
    final mixers = active.where((i) => i.category == 'Karıştırıcılar').toList();
    final fruits = active.where((i) => i.category == 'Meyveler & Taze').toList();
    final garnishes = active.where((i) => i.category == 'Garnitürler').toList();
    final bitters = active.where((i) => i.category == 'Bitters').toList();

    // Build a curated ingredient list (3–5 items)
    final List<Ingredient> selected = [];

    // 1. Pick 1 base spirit (required — fall back to any available ingredient)
    if (baseSpirits.isNotEmpty) {
      baseSpirits.shuffle();
      selected.add(baseSpirits.first);
    } else if (liqueurs.isNotEmpty) {
      // No spirit? Use a liqueur as the base
      liqueurs.shuffle();
      selected.add(liqueurs.first);
    } else {
      // Last resort: use whatever is available
      selected.add(active.first);
    }

    // 2. Pick 1 modifier (liqueur, mixer, or syrup)
    final modifiers = <Ingredient>[
      ...liqueurs.where((i) => !selected.contains(i)),
      ...mixers,
    ];
    if (modifiers.isNotEmpty) {
      modifiers.shuffle();
      selected.add(modifiers.first);
    }

    // 3. Pick 1 citrus / juice
    final citrus = <Ingredient>[...juices, ...fruits];
    final availableCitrus = citrus.where((i) => !selected.contains(i)).toList();
    if (availableCitrus.isNotEmpty) {
      availableCitrus.shuffle();
      selected.add(availableCitrus.first);
    }

    // 4. Pick 1 sweetener (syrup) — optional, only if not already selected
    final availableSyrups = syrups.where((i) => !selected.contains(i)).toList();
    if (availableSyrups.isNotEmpty && selected.length < 5) {
      availableSyrups.shuffle();
      selected.add(availableSyrups.first);
    }

    // 5. Pick 1 garnish or bitters — optional accent
    final accents = <Ingredient>[
      ...garnishes.where((i) => !selected.contains(i)),
      ...bitters.where((i) => !selected.contains(i)),
    ];
    if (accents.isNotEmpty && selected.length < 5) {
      accents.shuffle();
      selected.add(accents.first);
    }

    // Determine preparation method
    String prep = "Malzemeleri buz dolu bir kadehte yavaşça karıştırın ve servis edin.";
    if (selected.any((i) => i.category == 'Meyve Suları' || i.category == 'Şuruplar' || i.category == 'Püreler & Reçeller')) {
      prep = "Tüm malzemeleri buzlu bir shaker'a alın. İyice soğuyana kadar güçlü bir şekilde çalkalayın ve ardından süzerek taze buzla servis edin.";
    }

    // Generate a nice name
    final mainSpirit = selected.first;
    final secondary = selected.length > 1 ? selected[1] : null;
    String cocktailName = "Özel Karışım: ${mainSpirit.name}";
    if (secondary != null && secondary.name != mainSpirit.name) {
      cocktailName += " & ${secondary.name}";
    }

    // Convert selected ingredients to cocktail ingredients with sensible amounts
    final cocktailIngs = selected.map((i) {
      String amt;
      if (i.category == 'Temel İçkiler') {
        amt = '50 ml';
      } else if (i.category == 'Likörler & Amari') {
        amt = '20 ml';
      } else if (i.category == 'Meyve Suları') {
        amt = '30 ml';
      } else if (i.category == 'Şuruplar') {
        amt = '15 ml';
      } else if (i.category == 'Karıştırıcılar') {
        amt = '60 ml';
      } else if (i.category == 'Bitters') {
        amt = '2 dash';
      } else if (i.category == 'Garnitürler' || i.category == 'Meyveler & Taze') {
        amt = '1 ${i.unit}';
      } else {
        amt = '${i.stepSize.toInt()} ${i.unit}';
      }
      return CocktailIngredient(name: i.name, amount: amt);
    }).toList();

    return Cocktail(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      name: cocktailName,
      description: 'Sizin tarafınızdan, elinizdeki malzemelerle özel olarak yaratıldı. Benzersiz ve yaratıcı bir tat profili.',
      category: 'Özel Tarif',
      prepTimeMin: 5,
      intensity: 'Bilinmiyor',
      rating: 5.0,
      fpRatio: 10.0,
      imagePath: ImageUtils.getDynamicImageForIngredients(cocktailIngs.toList()),
      preparation: prep,
      ingredients: cocktailIngs.toList(),
    );
  }

}
