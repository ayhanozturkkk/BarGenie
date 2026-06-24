import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ingredient.dart';
import '../data/ingredient_database.dart';

final inventoryProvider =
    StateNotifierProvider<InventoryNotifier, List<Ingredient>>((ref) {
  return InventoryNotifier();
});

/// Provides the full database for searching/adding new ingredients
final fullDatabaseProvider = Provider<List<Ingredient>>((ref) {
  return generateFullDatabase();
});

class InventoryNotifier extends StateNotifier<List<Ingredient>> {
  InventoryNotifier() : super(_getInitialIngredients());

  static List<Ingredient> _getInitialIngredients() {
    // Start with an empty bar — user adds ingredients manually
    return [];
  }

  void increment(String id) {
    state = state.map((item) {
      if (item.id == id) {
        final newQty = item.quantity + item.stepSize.toInt();
        return item.copyWith(
          quantity: newQty,
          isActive: newQty > 0,
          stockPercent: (newQty / (item.stepSize * 10)).clamp(0.0, 1.0),
        );
      }
      return item;
    }).toList();
  }

  void decrement(String id) {
    state = state.map((item) {
      if (item.id == id && item.quantity > 0) {
        final newQty = item.quantity - item.stepSize.toInt();
        return item.copyWith(
          quantity: newQty < 0 ? 0 : newQty,
          isActive: newQty > 0,
          stockPercent: ((newQty < 0 ? 0 : newQty) / (item.stepSize * 10)).clamp(0.0, 1.0),
        );
      }
      return item;
    }).toList();
  }

  void addIngredient(String name, {String category = 'Diğer', String unit = 'adet', double stepSize = 1.0}) {
    // Prevent duplicates
    if (state.any((i) => i.name.toLowerCase() == name.toLowerCase())) return;
    state = [
      ...state,
      Ingredient(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        category: category,
        imagePath: 'https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b?w=200',
        unit: unit,
        stepSize: stepSize,
        quantity: stepSize.toInt(),
        stockPercent: 0.1,
        isActive: true,
      )
    ];
  }

  void addFromDatabase(Ingredient dbItem) {
    if (state.any((i) => i.name.toLowerCase() == dbItem.name.toLowerCase())) return;
    state = [
      ...state,
      dbItem.copyWith(
        quantity: dbItem.stepSize.toInt(),
        stockPercent: 0.1,
        isActive: true,
      ),
    ];
  }

  void removeIngredient(String id) {
    state = state.where((i) => i.id != id).toList();
  }
}
