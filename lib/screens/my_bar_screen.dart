import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../providers/inventory_provider.dart';
import '../models/ingredient.dart';
import '../widgets/inventory_item_card.dart';

class MyBarScreen extends ConsumerStatefulWidget {
  const MyBarScreen({super.key});

  @override
  ConsumerState<MyBarScreen> createState() => _MyBarScreenState();
}

class _MyBarScreenState extends ConsumerState<MyBarScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final allIngredients = ref.watch(inventoryProvider);
    final activeCount = allIngredients.where((i) => i.isActive).length;

    final filteredIngredients = allIngredients.where((i) {
      if (_searchQuery.isEmpty) return true;
      return i.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    final displayedIngredients = filteredIngredients.take(30).toList();

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primaryGold),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Column(
                children: [
                  Text(
                    'BENİM BARIM',
                    style: GoogleFonts.newsreader(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$activeCount Aktif Malzeme Listesi',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      color: AppColors.primaryGold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Search Bar ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                style: GoogleFonts.manrope(color: AppColors.primaryText),
                decoration: InputDecoration(
                  hintText: 'Malzemelerimde Ara...',
                  hintStyle: GoogleFonts.manrope(color: AppColors.placeholderText),
                  filled: true,
                  fillColor: AppColors.surfaceContainerLowest,
                  prefixIcon: const Icon(Icons.search, color: AppColors.placeholderText),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.ghostBorder, width: 0.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.ghostBorder, width: 0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.primaryGold, width: 1),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Ingredient List ──
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: displayedIngredients.length,
                separatorBuilder: (_, _) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final item = displayedIngredients[index];
                  return InventoryItemCard(
                    ingredient: item,
                    onIncrement: () =>
                        ref.read(inventoryProvider.notifier).increment(item.id),
                    onDecrement: () =>
                        ref.read(inventoryProvider.notifier).decrement(item.id),
                  );
                },
              ),
            ),

            // ── Add button ──
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: GestureDetector(
                onTap: () => _showAddIngredientSheet(context, ref),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primaryGold.withValues(alpha: 0.5),
                      width: 1,
                    ),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryGold.withValues(alpha: 0.12),
                        AppColors.primaryGoldDark.withValues(alpha: 0.06),
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add, color: AppColors.primaryGold, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'YENİ MALZEME EKLE',
                        style: GoogleFonts.manrope(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryGold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddIngredientSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _AddIngredientContent(ref: ref);
      },
    );
  }
}

class _AddIngredientContent extends StatefulWidget {
  final WidgetRef ref;
  const _AddIngredientContent({required this.ref});

  @override
  State<_AddIngredientContent> createState() => _AddIngredientContentState();
}

class _AddIngredientContentState extends State<_AddIngredientContent> {
  String _addSearchQuery = '';

  @override
  Widget build(BuildContext context) {
    // 500-item full database
    final fullDb = widget.ref.read(fullDatabaseProvider);
    final myBar = widget.ref.watch(inventoryProvider);

    // Filter database
    final searchResults = fullDb.where((i) {
      if (_addSearchQuery.isEmpty) return true;
      return i.name.toLowerCase().contains(_addSearchQuery.toLowerCase());
    }).take(50).toList(); // Show up to 50 results at a time

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.placeholderText.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primaryGold, size: 20),
                  ),
                  const Spacer(),
                  Text(
                    'Geri Dön',
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      color: AppColors.primaryGold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Malzeme Veritabanı',
                style: GoogleFonts.newsreader(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryGold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '500+ malzemeden hemen ekleyin.',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  color: AppColors.labelText,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                autofocus: true,
                onChanged: (val) => setState(() => _addSearchQuery = val),
                style: GoogleFonts.manrope(color: AppColors.primaryText),
                decoration: InputDecoration(
                  hintText: 'Şurup, taze meyve, baz içki...',
                  hintStyle: GoogleFonts.manrope(color: AppColors.placeholderText),
                  filled: true,
                  fillColor: AppColors.surfaceContainerLowest,
                  prefixIcon: const Icon(Icons.search, color: AppColors.placeholderText),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.ghostBorder, width: 0.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.ghostBorder, width: 0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.primaryGold, width: 1),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: searchResults.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final dbItem = searchResults[index];
                    final alreadyInBar = myBar.any((i) => i.name == dbItem.name);

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.ghostBorder, width: 0.5),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.liquor, color: AppColors.primaryGold, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dbItem.name,
                                  style: GoogleFonts.manrope(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryText,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryGold.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    dbItem.category,
                                    style: GoogleFonts.manrope(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryGold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (alreadyInBar)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Eklendi',
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.placeholderText,
                                ),
                              ),
                            )
                          else
                            ElevatedButton(
                              onPressed: () {
                                widget.ref.read(inventoryProvider.notifier).addFromDatabase(dbItem);
                                Navigator.pop(context); // Close the sheet after adding
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryGold,
                                foregroundColor: AppColors.surface,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                elevation: 0,
                              ),
                              child: Text(
                                'Ekle',
                                style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w700),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
