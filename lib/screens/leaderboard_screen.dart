import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../providers/cocktail_provider.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cocktails = ref.watch(cocktailProvider);
    final communityCocktails = cocktails.where((c) => c.isCommunity).toList();
    final sorted = [...communityCocktails]..sort((a, b) => b.fpRatio.compareTo(a.fpRatio));
    final top3 = sorted.take(3).toList();
    final rest = sorted.skip(3).take(7).toList();
    final bestCocktail = sorted.isNotEmpty ? sorted.first : null;
    final bartenderName = bestCocktail?.creatorNickname ?? '@barmen';

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // ── Header ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Center(
                child: Text(
                  'BarGenie',
                  style: GoogleFonts.newsreader(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    color: AppColors.primaryGold,
                  ),
                ),
              ),
            ),
          ),

          // ── Hero banner ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.surfaceContainerHighest.withValues(alpha: 0.6),
                      AppColors.surfaceContainer,
                    ],
                  ),
                ),
                child: Center(
                  child: ShaderMask(
                    shaderCallback: (bounds) =>
                        AppColors.goldGradient.createShader(bounds),
                    child: Text(
                      'İlk 10 Kokteyl',
                      style: GoogleFonts.newsreader(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              child: Text(
                'Topluluğun en çok beğendiği ilk 10 kokteyl özenle seçildi.',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  color: AppColors.labelText,
                ),
              ),
            ),
          ),

          // ── User Showcase ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.surfaceContainerLowest,
                  border: Border.all(color: AppColors.primaryGold.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.surfaceContainerHighest,
                      backgroundImage: NetworkImage('https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Günün Barmeni',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              color: AppColors.primaryGold,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            bartenderName,
                            style: GoogleFonts.newsreader(
                              fontSize: 18,
                              color: AppColors.primaryText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        const Icon(Icons.star, color: AppColors.primaryGold, size: 20),
                        Text(
                          'Lv. 42',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── #1 Spotlight ──
          if (top3.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                child: GestureDetector(
                  onTap: () => _showCocktailModal(context, ref, top3[0]),
                  child: Container(
                    height: 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.surfaceContainer.withValues(alpha: 0.9),
                      border: Border.all(
                        color: AppColors.ghostBorder,
                        width: 0.5,
                      ),
                    ),
                  child: Stack(
                    children: [
                      // Image Background
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: top3[0].imagePath.isNotEmpty
                              ? _buildImage(
                                  top3[0].imagePath,
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                      ),
                      // Background dark gradient layer
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.surface.withValues(alpha: 0.2),
                                AppColors.surface.withValues(alpha: 0.9),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Trophy icon
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.emoji_events,
                            color: AppColors.primaryGold,
                            size: 20,
                          ),
                        ),
                      ),
                      // Cocktail icon center
                      Positioned(
                        top: 30,
                        right: 30,
                        child: Icon(
                          Icons.local_bar_rounded,
                          size: 100,
                          color: AppColors.primaryGold.withValues(alpha: 0.15),
                        ),
                      ),
                      // Bottom content
                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 70,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              top3[0].name,
                              style: GoogleFonts.newsreader(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic,
                                color: AppColors.primaryText,
                              ),
                            ),
                            Text(
                              top3[0].creatorNickname ?? '',
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                color: AppColors.primaryGold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                ...List.generate(
                                  5,
                                  (i) => Icon(
                                    Icons.star_rounded,
                                    size: 16,
                                    color: i < top3[0].rating.round()
                                        ? AppColors.primaryGold
                                        : AppColors.placeholderText,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  top3[0].rating.toStringAsFixed(1),
                                  style: GoogleFonts.manrope(
                                    fontSize: 12,
                                    color: AppColors.primaryText,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // F/P badge
                      Positioned(
                        bottom: 20,
                        right: 16,
                        child: Column(
                          children: [
                            Text(
                              'F/P',
                              style: GoogleFonts.manrope(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.labelText,
                              ),
                            ),
                            Text(
                              'ORANI',
                              style: GoogleFonts.manrope(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.labelText,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                gradient: AppColors.goldGradient,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                top3[0].fpRatio.toStringAsFixed(1),
                                style: GoogleFonts.newsreader(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.surface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── #2 & #3 row ──
          if (top3.length >= 3)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                child: Row(
                  children: [
                    Expanded(child: _buildRunnerUp(context, ref, top3[1], 2)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildRunnerUp(context, ref, top3[2], 3)),
                  ],
                ),
              ),
            ),

          // ── "Sıralama" header ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sıralama',
                    style: GoogleFonts.newsreader(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      color: AppColors.primaryText,
                    ),
                  ),
                  Icon(Icons.filter_list_rounded,
                      color: AppColors.primaryText, size: 22),
                ],
              ),
            ),
          ),

          // ── #4 - #10 list ──
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final cocktail = rest[index];
                  final rank = index + 4;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () => _showCocktailModal(context, ref, cocktail),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainer.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 28,
                            child: Text(
                              '$rank',
                              style: GoogleFonts.newsreader(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.labelText,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: _buildImage(
                              cocktail.imagePath,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cocktail.name,
                                  style: GoogleFonts.manrope(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryText,
                                  ),
                                ),
                                Text(
                                  cocktail.creatorNickname ?? '',
                                  style: GoogleFonts.manrope(
                                    fontSize: 11,
                                    color: AppColors.primaryGold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: List.generate(
                                    5,
                                    (i) => Icon(
                                      Icons.star_rounded,
                                      size: 13,
                                      color: i < cocktail.rating.round()
                                          ? AppColors.primaryGold
                                          : AppColors.placeholderText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'F/P ORANI',
                                style: GoogleFonts.manrope(
                                  fontSize: 10,
                                  color: AppColors.labelText,
                                ),
                              ),
                              Text(
                                cocktail.fpRatio.toStringAsFixed(1),
                                style: GoogleFonts.newsreader(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryGold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
                },
                childCount: rest.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildImage(String path, {double? width, double? height, BoxFit fit = BoxFit.cover}) {
    if (path.isEmpty) return SizedBox(width: width, height: height);
    if (path.startsWith('http')) {
      return Image.network(
        path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (c, e, s) => Container(width: width, height: height, color: AppColors.surface),
      );
    } else {
      return Image.file(
        File(path),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (c, e, s) => Container(width: width, height: height, color: AppColors.surface),
      );
    }
  }

  Widget _buildRunnerUp(BuildContext context, WidgetRef ref, dynamic cocktail, int rank) {
    return GestureDetector(
      onTap: () => _showCocktailModal(context, ref, cocktail),
      child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '#$rank',
                style: GoogleFonts.newsreader(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryGold,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.emoji_events_outlined,
                color: AppColors.labelText.withValues(alpha: 0.4),
                size: 32,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            cocktail.name,
            style: GoogleFonts.newsreader(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
            maxLines: 2,
          ),
          Text(
            cocktail.creatorNickname ?? '',
            style: GoogleFonts.manrope(
              fontSize: 12,
              color: AppColors.primaryGold,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: List.generate(
              5,
              (i) => Icon(
                Icons.star_rounded,
                size: 14,
                color: i < cocktail.rating.round()
                    ? AppColors.primaryGold
                    : AppColors.placeholderText,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'F/P ORANI',
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  color: AppColors.labelText,
                ),
              ),
              const Spacer(),
              Text(
                cocktail.fpRatio.toStringAsFixed(1),
                style: GoogleFonts.newsreader(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryGold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: _buildImage(
              cocktail.imagePath,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    ),
  );
}
  void _showCocktailModal(BuildContext context, WidgetRef ref, dynamic cocktail) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
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
              const SizedBox(height: 24),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _buildImage(
                  cocktail.imagePath,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                cocktail.name,
                style: GoogleFonts.newsreader(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryGold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                cocktail.description ?? '',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  color: AppColors.labelText,
                ),
              ),
              const SizedBox(height: 24),
              // Rating stars
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primaryGold.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      Text('Puan Ver', style: GoogleFonts.manrope(fontWeight: FontWeight.bold, color: AppColors.primaryGold)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(5, (index) {
                          final ratingValue = index + 1;
                          return GestureDetector(
                            onTap: () {
                              ref.read(cocktailProvider.notifier).rateCocktail(cocktail.id, ratingValue.toDouble());
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Puanınız eklendi!', style: GoogleFonts.manrope()),
                                  backgroundColor: AppColors.primaryGoldDark,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(Icons.star_border_rounded, size: 36, color: AppColors.primaryGold),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: [
                    Text(
                      'Malzemeler',
                      style: GoogleFonts.newsreader(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...cocktail.ingredients.map<Widget>((ing) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle_outline, color: AppColors.primaryGold, size: 20),
                            const SizedBox(width: 12),
                            Text(
                              '${ing.amount} ${ing.name}',
                              style: GoogleFonts.manrope(fontSize: 15, color: AppColors.primaryText),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 24),
                    Text(
                      'Hazırlanışı',
                      style: GoogleFonts.newsreader(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      cocktail.preparation ?? '',
                      style: GoogleFonts.manrope(
                        fontSize: 15,
                        color: AppColors.primaryText,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
