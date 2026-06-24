import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cocktail.dart';
import '../theme/app_colors.dart';
import '../providers/cocktail_provider.dart';
import '../providers/inventory_provider.dart';
import '../utils/recommendation_engine.dart';
import 'my_bar_screen.dart';
import 'results_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isAnaIckilerActive = false;

  void _triggerMixingAnimation(bool isClassic) {
    // RUN RECOMMENDATION ENGINE
    final myBar = ref.read(inventoryProvider);
    final cocktails = ref.read(cocktailProvider);

    // Validation Check
    final validation = RecommendationEngine.checkClashes(myBar);
    if (!validation.isValid) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.surfaceContainer,
          title: Text(
            'Uyarı',
            style: GoogleFonts.newsreader(color: AppColors.primaryGold, fontWeight: FontWeight.bold, fontSize: 24),
          ),
          content: Text(
            validation.errorMessage ?? 'Geçersiz Karışım',
            style: GoogleFonts.manrope(color: AppColors.primaryText, fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Anladım', style: GoogleFonts.manrope(color: AppColors.primaryGold, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      );
      return;
    }

    RecommendationResult result;
    if (isClassic) {
      result = RecommendationEngine.getBestMatch(myBar, cocktails);
    } else {
      try {
        final customCocktail = RecommendationEngine.generateCustomCocktail(myBar);
        result = RecommendationResult(
          cocktail: customCocktail,
          matchedCount: customCocktail.ingredients.length,
          missingCount: 0,
          matchPercentage: 1.0,
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppColors.surfaceContainer,
            title: Text('Uyarı', style: GoogleFonts.newsreader(color: AppColors.primaryGold)),
            content: Text(e.toString().replaceAll('Exception: ', ''), style: GoogleFonts.manrope(color: AppColors.primaryText)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('Anladım', style: GoogleFonts.manrope(color: AppColors.primaryGold)),
              )
            ],
          ),
        );
        return;
      }
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Mix',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          backgroundColor: AppColors.surface.withValues(alpha: 0.95),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assest/barmen karistirma.png',
                    width: 300,
                    height: 400,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      width: 300,
                      height: 400,
                      color: AppColors.surfaceContainer,
                      child: const Center(
                        child: CircularProgressIndicator(color: AppColors.primaryGold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Simya Devam Ediyor...',
                  style: GoogleFonts.newsreader(
                    fontSize: 24,
                    color: AppColors.primaryGold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 200,
                  height: 2,
                  child: LinearProgressIndicator(
                    backgroundColor: AppColors.surfaceContainerHighest,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryGold),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: child,
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ResultsScreen(result: result)),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cocktails = ref.watch(cocktailProvider);
    final classicCocktails = cocktails.where((c) => c.category == 'Klasik').toList();

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // ── Logo ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Center(
                child: Text(
                  'BarGenie',
                  style: GoogleFonts.newsreader(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    color: AppColors.primaryGold,
                  ),
                ),
              ),
            ),
          ),

          // Search bar removed as per requirement

          // ── Action Buttons (Barımdakiler & Ana İçkiler) ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const MyBarScreen()),
                        );
                      },
                      icon: const Icon(Icons.wine_bar, size: 18),
                      label: Text(
                        'Barımdakiler',
                        style: GoogleFonts.manrope(fontSize: 12),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryGold,
                        side: BorderSide(
                            color: AppColors.primaryGold.withValues(alpha: 0.5)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isAnaIckilerActive = !_isAnaIckilerActive;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isAnaIckilerActive
                          ? AppColors.primaryGold
                          : AppColors.surfaceContainerHighest,
                      foregroundColor: _isAnaIckilerActive
                          ? AppColors.surface
                          : AppColors.primaryText,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Text(
                      'Ana İçkiler',
                      style: GoogleFonts.manrope(
                          fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),



          // ── 3 Squares & Kurasyon ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSquareImage(
                          'https://images.unsplash.com/photo-1542848590-e88944519961?auto=format&fit=crop&w=200&q=80'),
                      _buildSquareImage(
                          'https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b?auto=format&fit=crop&w=200&q=80',
                          isCenter: true),
                      _buildSquareImage(
                          'https://images.unsplash.com/photo-1551024709-8f23befc6f87?auto=format&fit=crop&w=200&q=80'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 40, height: 1, color: AppColors.ghostBorder),
                      const SizedBox(width: 12),
                      Text(
                        'KÜRASYON HAZIRLANIYOR',
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryGold,
                          letterSpacing: 2.0,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                          width: 40, height: 1, color: AppColors.ghostBorder),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── KOKTEYLİMİ GÖR Helper Text ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.arrow_downward_rounded, color: AppColors.primaryGold, size: 16),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Barımdakiler listesindeki malzemeler baz alınacaktır',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            color: AppColors.primaryGold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          
          // ── Cocktail Action Buttons ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _triggerMixingAnimation(true),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: AppColors.goldGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryGold.withValues(alpha: 0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'BANA BİR KLASİK ÖNER',
                          style: GoogleFonts.manrope(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0E0E0E),
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _triggerMixingAnimation(false),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppColors.surfaceContainerLowest,
                        border: Border.all(color: AppColors.primaryGold.withValues(alpha: 0.5)),
                      ),
                      child: Center(
                        child: Text(
                          'ÖZEL KOKTEYL YARAT',
                          style: GoogleFonts.manrope(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryGold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_isAnaIckilerActive) ...[
            // ── Ana Ickiler Recipe List ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: Text(
                  'Klasik Kokteyller',
                  style: GoogleFonts.newsreader(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    color: AppColors.primaryText,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _buildRecipeListItem(classicCocktails[index]);
                  },
                  childCount: classicCocktails.length,
                ),
              ),
            ),
          ] else if (cocktails.isNotEmpty) ...[
            // ── Günün Seçkisi (Massive Card) ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: Text(
                  'Günün Seçkisi',
                  style: GoogleFonts.newsreader(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    color: AppColors.primaryText,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  height: 480,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: AppColors.surfaceContainer,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGold.withValues(alpha: 0.1),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.network(
                          cocktails[0].imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => Container(
                            color: AppColors.surfaceContainer,
                            child: const Center(
                              child: Icon(Icons.local_bar, color: AppColors.primaryGold, size: 64),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.surface.withValues(alpha: 0.95),
                        ],
                        stops: const [0.4, 1.0],
                      ),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.primaryGold.withValues(alpha: 0.5)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            cocktails[0].category.toUpperCase(),
                            style: GoogleFonts.manrope(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryGold,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          cocktails[0].name,
                          style: GoogleFonts.newsreader(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic,
                            color: AppColors.primaryText,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cocktails[0].description,
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            color: AppColors.labelText,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: AppColors.primaryGold, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              cocktails[0].rating.toStringAsFixed(1),
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryText,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Icon(Icons.timer_outlined,
                                color: AppColors.placeholderText, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              '${cocktails[0].prepTimeMin} dk',
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                color: AppColors.labelText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                    ],
                  ),
                ),
              ),
            ),
          ],

          const SliverToBoxAdapter(
            child: SizedBox(height: 48),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeListItem(Cocktail cocktail) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.ghostBorder, width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              cocktail.imagePath,
              width: 100,
              height: 140,
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, stack) => Container(
                width: 100,
                height: 140,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.local_bar, color: AppColors.primaryGold, size: 32),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cocktail.name,
                  style: GoogleFonts.newsreader(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    color: AppColors.primaryGold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  cocktail.preparation,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: cocktail.ingredients.map((ing) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHighest.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${ing.amount} ${ing.name}',
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          color: AppColors.labelText,
                        ),
                      ),
                    );
                  }).toList(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.ghostBorder, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 13,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.add,
            size: 14,
            color: AppColors.primaryGold,
          )
        ],
      ),
    );
  }

  Widget _buildSquareImage(String url, {bool isCenter = false}) {
    final size = isCenter ? 100.0 : 80.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.surfaceContainer,
        border: isCenter
            ? Border.all(color: AppColors.primaryGold.withValues(alpha: 0.5), width: 1)
            : null,
        boxShadow: isCenter
            ? [
                BoxShadow(
                  color: AppColors.primaryGold.withValues(alpha: 0.2),
                  blurRadius: 20,
                )
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, stack) => Container(
                color: AppColors.surfaceContainer,
                child: Icon(Icons.local_bar, color: AppColors.primaryGold.withValues(alpha: 0.3), size: 24),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.surface.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
