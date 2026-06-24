import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../providers/xp_provider.dart';
import '../providers/activity_provider.dart';
import 'secret_recipes_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final xp = ref.watch(xpProvider);
    final activityLog = ref.watch(activityProvider);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 32),

            // ── Title (Dynamic) ──
            Text(
              xp.title,
              style: GoogleFonts.newsreader(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryText,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Seviye ${xp.level} • ${xp.cocktailsMade} Kokteyl Hazırlandı',
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: AppColors.primaryGold,
              ),
            ),

            const SizedBox(height: 20),

            // ── XP Progress Bar ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryGold.withValues(alpha: 0.2),
                  width: 0.5,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => AppColors.goldGradient.createShader(bounds),
                            child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Seviye ${xp.level}',
                            style: GoogleFonts.manrope(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryGold,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${xp.xpInCurrentLevel} / ${xp.xpForNextLevel} XP',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          color: AppColors.labelText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: xp.progressPercent,
                      minHeight: 8,
                      backgroundColor: AppColors.surfaceContainerHighest,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryGold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Toplam ${xp.totalXPEarned} XP kazanıldı',
                    style: GoogleFonts.manrope(fontSize: 11, color: AppColors.placeholderText),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Miksoloji Günlüğü ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryGold.withValues(alpha: 0.2),
                  width: 0.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Miksoloji Günlüğü',
                    style: GoogleFonts.newsreader(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...activityLog.asMap().entries.map((entry) {
                    final index = entry.key;
                    final log = entry.value;
                    return Column(
                      children: [
                        _buildLogEntry(
                          name: log.name,
                          date: log.date,
                          badge: log.badge,
                          badgeIcon: log.badge != null ? Icons.star_rounded : null,
                        ),
                        if (index < activityLog.length - 1) _ghostDivider(),
                      ],
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Kilitli Reçete Card ──
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SecretRecipesScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                splashColor: AppColors.primaryGold.withValues(alpha: 0.2),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primaryGold.withValues(alpha: 0.3), width: 1),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGold.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.lock, color: AppColors.primaryGold),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '12 Gizli Reçete',
                              style: GoogleFonts.newsreader(
                                color: AppColors.primaryGold,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Seviyeni yükselterek kilitleri aç!',
                              style: GoogleFonts.manrope(fontSize: 12, color: AppColors.labelText),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: AppColors.primaryGold),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  Widget _buildLogEntry({required String name, required String date, String? badge, IconData? badgeIcon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primaryText)),
                const SizedBox(height: 4),
                Text(date, style: GoogleFonts.manrope(fontSize: 12, color: AppColors.labelText)),
              ],
            ),
          ),
          if (badge != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (badgeIcon != null) Icon(badgeIcon, size: 18, color: AppColors.primaryGold),
                const SizedBox(width: 4),
                Text(badge, style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primaryGold)),
              ],
            ),
        ],
      ),
    );
  }

  Widget _ghostDivider() {
    return Container(height: 0.5, color: AppColors.ghostBorder);
  }
}
