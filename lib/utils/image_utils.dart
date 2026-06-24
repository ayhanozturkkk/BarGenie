import '../models/cocktail.dart';

class ImageUtils {
  static String getDynamicImageForIngredients(List<CocktailIngredient> ingredients) {
    if (ingredients.isEmpty) return 'https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b?w=600'; // Default bar
    
    final names = ingredients.map((i) => i.name.toLowerCase()).toList();
    
    if (names.any((n) => n.contains('çilek') || n.contains('kızılcık'))) {
      return 'https://images.unsplash.com/photo-1536935338788-846bb9981813?w=600'; // Red cocktail
    } else if (names.any((n) => n.contains('cin') || n.contains('tonik'))) {
      return 'https://images.unsplash.com/photo-1560512823-829485b8bf24?w=600'; // Clear cocktail
    } else if (names.any((n) => n.contains('viski') || n.contains('bourbon') || n.contains('viskisi'))) {
      return 'https://images.unsplash.com/photo-1597075687490-8f673c6c17f6?w=600'; // Amber whiskey
    } else if (names.any((n) => n.contains('kahve') || n.contains('espresso') || n.contains('likörü'))) {
      return 'https://images.unsplash.com/photo-1610889556528-9a59b9aa7b38?w=600'; // Dark espresso martini
    } else if (names.any((n) => n.contains('nane') || n.contains('yeşil'))) {
      return 'https://images.unsplash.com/photo-1551538827-9c037cb4f32a?w=600'; // Green mojito
    }
    
    return 'https://images.unsplash.com/photo-1470337458703-4f5a7a4cf028?w=600'; // Generic cocktail
  }
}
