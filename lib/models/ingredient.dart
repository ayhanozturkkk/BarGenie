class Ingredient {
  final String id;
  final String name;
  final String category;
  final String imagePath;
  final String unit;
  final double stepSize;
  final int quantity;
  final double stockPercent;
  final bool isActive;

  const Ingredient({
    required this.id,
    required this.name,
    this.category = 'Diğer',
    required this.imagePath,
    required this.unit,
    required this.stepSize,
    required this.quantity,
    required this.stockPercent,
    required this.isActive,
  });

  Ingredient copyWith({
    String? id,
    String? name,
    String? category,
    String? imagePath,
    String? unit,
    double? stepSize,
    int? quantity,
    double? stockPercent,
    bool? isActive,
  }) {
    return Ingredient(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      imagePath: imagePath ?? this.imagePath,
      unit: unit ?? this.unit,
      stepSize: stepSize ?? this.stepSize,
      quantity: quantity ?? this.quantity,
      stockPercent: stockPercent ?? this.stockPercent,
      isActive: isActive ?? this.isActive,
    );
  }
}
