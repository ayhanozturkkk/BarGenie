import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_colors.dart';
import '../utils/recommendation_engine.dart';
import '../utils/image_utils.dart';
import '../providers/auth_provider.dart';
import '../providers/cocktail_provider.dart';

class ResultsScreen extends ConsumerStatefulWidget {
  final RecommendationResult result;

  const ResultsScreen({super.key, required this.result});

  @override
  ConsumerState<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends ConsumerState<ResultsScreen> {
  final ImagePicker _picker = ImagePicker();

  void _shareToCommunity() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Fotoğraf Yükle',
                  style: GoogleFonts.newsreader(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryGold,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: AppColors.primaryGold),
                  title: Text('Kameradan Çek', style: GoogleFonts.manrope(color: AppColors.primaryText)),
                  onTap: () async {
                    Navigator.pop(ctx);
                    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
                    if (photo != null) {
                      _finalizeSharing(photo.path);
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library, color: AppColors.primaryGold),
                  title: Text('Galeriden Seç', style: GoogleFonts.manrope(color: AppColors.primaryText)),
                  onTap: () async {
                    Navigator.pop(ctx);
                    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      _finalizeSharing(image.path);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _finalizeSharing(String imagePath) {
    final nickname = ref.read(authProvider).nickname ?? 'MixMaster';
    final dynamicId = '${widget.result.cocktail.id}_${DateTime.now().millisecondsSinceEpoch}';
    
    final sharedCocktail = widget.result.cocktail.copyWith(
      id: dynamicId,
      name: '${nickname}\'s ${widget.result.cocktail.name}',
      isCommunity: true,
      creatorNickname: nickname,
      imagePath: imagePath,
      rating: 5.0, 
      ratingsCount: 1,
    );
    
    ref.read(cocktailProvider.notifier).addCommunityCocktail(sharedCocktail);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kokteylin başarıyla topluluğa katıldı!', style: GoogleFonts.manrope()),
        backgroundColor: AppColors.activeGreen,
      )
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryGold),
        centerTitle: true,
        title: Text(
          'Kürasyon Sonucu',
          style: GoogleFonts.newsreader(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
            color: AppColors.primaryGold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Hero Image
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGold.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
                image: DecorationImage(
                  image: NetworkImage(widget.result.cocktail.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.surface.withValues(alpha: 0.8),
                    ],
                    stops: const [0.5, 1.0],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Match Metrics
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryGold.withValues(alpha: 0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.result.matchPercentage >= 1.0
                        ? Icons.check_circle_outline_rounded
                        : Icons.info_outline_rounded,
                    color: widget.result.matchPercentage >= 1.0
                        ? AppColors.activeGreen
                        : AppColors.primaryGold,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Eşleşme: %${(widget.result.matchPercentage * 100).toInt()}',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              widget.result.cocktail.name,
              style: GoogleFonts.newsreader(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryGold,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              widget.result.cocktail.description,
              style: GoogleFonts.manrope(
                fontSize: 14,
                color: AppColors.labelText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Ingredients Breakdown
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Reçete Gerekksinimleri',
                style: GoogleFonts.newsreader(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...widget.result.cocktail.ingredients.map((ing) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.circle, size: 8, color: AppColors.primaryGold),
                    const SizedBox(width: 12),
                    Text(
                      '${ing.amount} ${ing.name}',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Hazırlanışı:',
                style: GoogleFonts.newsreader(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.result.cocktail.preparation,
              style: GoogleFonts.manrope(
                fontSize: 14,
                color: AppColors.labelText,
                height: 1.5,
              ),
              textAlign: TextAlign.left,
            ),
            
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _shareToCommunity,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surfaceContainerLowest,
                  foregroundColor: AppColors.primaryGold,
                  side: BorderSide(color: AppColors.primaryGold.withValues(alpha: 0.5)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  'Toplulukla Paylaş',
                  style: GoogleFonts.manrope(fontWeight: FontWeight.w800, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGold,
                  foregroundColor: AppColors.surface,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  'Ana Sayfaya Dön',
                  style: GoogleFonts.manrope(fontWeight: FontWeight.w800, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
