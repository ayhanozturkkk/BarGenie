class Cocktail {
  final String id;
  final String name;
  final String category;
  final String description;
  final String imagePath;
  final double rating;
  final double fpRatio;
  final int prepTimeMin;
  final String intensity;
  final List<CocktailIngredient> ingredients;
  final String preparation;
  
  final String? creatorNickname;
  final bool isCommunity;
  final int ratingsCount;

  const Cocktail({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.imagePath,
    required this.rating,
    required this.fpRatio,
    required this.prepTimeMin,
    required this.intensity,
    required this.ingredients,
    required this.preparation,
    this.creatorNickname,
    this.isCommunity = false,
    this.ratingsCount = 0,
  });

  Cocktail copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    String? imagePath,
    double? rating,
    double? fpRatio,
    int? prepTimeMin,
    String? intensity,
    List<CocktailIngredient>? ingredients,
    String? preparation,
    String? creatorNickname,
    bool? isCommunity,
    int? ratingsCount,
  }) {
    return Cocktail(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      rating: rating ?? this.rating,
      fpRatio: fpRatio ?? this.fpRatio,
      prepTimeMin: prepTimeMin ?? this.prepTimeMin,
      intensity: intensity ?? this.intensity,
      ingredients: ingredients ?? this.ingredients,
      preparation: preparation ?? this.preparation,
      creatorNickname: creatorNickname ?? this.creatorNickname,
      isCommunity: isCommunity ?? this.isCommunity,
      ratingsCount: ratingsCount ?? this.ratingsCount,
    );
  }
}

class CocktailIngredient {
  final String name;
  final String amount;

  const CocktailIngredient({
    required this.name,
    required this.amount,
  });
}
