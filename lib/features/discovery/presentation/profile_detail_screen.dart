import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/glass_widgets.dart';

class ProfileDetailScreen extends StatefulWidget {
  final String profileId;
  const ProfileDetailScreen({super.key, required this.profileId});

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  int _currentPhoto = 0;
  final _totalPhotos = 4;

  String get profileId => widget.profileId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlassBackground.standard(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                // Photo gallery
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 420,
                    child: Stack(
                      children: [
                        // Photo placeholder
                        GestureDetector(
                          onTapUp: (details) {
                            final width = MediaQuery.of(context).size.width;
                            setState(() {
                              if (details.globalPosition.dx < width / 2) {
                                _currentPhoto = (_currentPhoto - 1).clamp(0, _totalPhotos - 1);
                              } else {
                                _currentPhoto = (_currentPhoto + 1).clamp(0, _totalPhotos - 1);
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white.withValues(alpha: 0.04),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            child: Center(
                              child: Icon(Icons.person_rounded,
                                  size: 80,
                                  color: Colors.white.withValues(alpha: 0.1)),
                            ),
                          ),
                        ),
                        // Photo indicators
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 8,
                          left: 16,
                          right: 16,
                          child: Row(
                            children: List.generate(
                              _totalPhotos,
                              (i) => Expanded(
                                child: Container(
                                  height: 3,
                                  margin: const EdgeInsets.symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: i == _currentPhoto
                                        ? AppColors.accent
                                        : Colors.white.withValues(alpha: 0.2),
                                    boxShadow: i == _currentPhoto
                                        ? [BoxShadow(color: AppColors.accent.withValues(alpha: 0.5), blurRadius: 4)]
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Back button
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 16,
                          left: 16,
                          child: GlassContainer(
                            borderRadius: 14,
                            padding: const EdgeInsets.all(8),
                            opacity: 0.12,
                            onTap: () => context.pop(),
                            child: const Icon(Icons.arrow_back_ios_new_rounded,
                                color: Colors.white, size: 18),
                          ),
                        ),
                        // Share/Report
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 16,
                          right: 16,
                          child: Row(
                            children: [
                              GlassContainer(
                                borderRadius: 14,
                                padding: const EdgeInsets.all(8),
                                opacity: 0.12,
                                child: const Icon(Icons.share_rounded,
                                    color: Colors.white, size: 18),
                              ),
                              const SizedBox(width: 8),
                              GlassContainer(
                                borderRadius: 14,
                                padding: const EdgeInsets.all(8),
                                opacity: 0.12,
                                child: const Icon(Icons.flag_outlined,
                                    color: Colors.white, size: 18),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Profile info
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name & verification
                        Row(
                          children: [
                            Text('Sofia, 27', style: AppTextStyles.heading1),
                            const SizedBox(width: 8),
                            Icon(Icons.verified_rounded,
                                color: AppColors.accent, size: 24),
                          ],
                        ).animate().fadeIn(),

                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                size: 16,
                                color: Colors.white.withValues(alpha: 0.4)),
                            const SizedBox(width: 4),
                            Text('Barcelona, Spain',
                                style: AppTextStyles.bodySmall),
                            const SizedBox(width: 16),
                            Icon(Icons.work_outline_rounded,
                                size: 16,
                                color: Colors.white.withValues(alpha: 0.4)),
                            const SizedBox(width: 4),
                            Text('Photographer',
                                style: AppTextStyles.bodySmall),
                          ],
                        ).animate().fadeIn(delay: 100.ms),

                        const SizedBox(height: 20),

                        // Stats
                        Row(
                          children: [
                            _StatPill(icon: Icons.flight_takeoff_rounded, value: '3', label: 'Trips'),
                            const SizedBox(width: 8),
                            _StatPill(icon: Icons.star_rounded, value: '4.8', label: 'Rating'),
                            const SizedBox(width: 8),
                            _StatPill(icon: Icons.rate_review_outlined, value: '5', label: 'Reviews'),
                          ],
                        ).animate().fadeIn(delay: 200.ms),

                        const SizedBox(height: 24),

                        // About
                        Text('ABOUT', style: AppTextStyles.label),
                        const SizedBox(height: 8),
                        Text(
                          'Freelance photographer with a passion for capturing beautiful moments. Looking for a travel companion who enjoys exploring local culture, trying new cuisines, and going on spontaneous adventures.',
                          style: AppTextStyles.bodyMedium,
                        ).animate().fadeIn(delay: 300.ms),

                        const SizedBox(height: 24),

                        // Languages
                        Text('LANGUAGES', style: AppTextStyles.label),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: ['Spanish', 'English', 'French']
                              .map((l) => GlassChip(label: l, icon: Icons.translate_rounded))
                              .toList(),
                        ).animate().fadeIn(delay: 400.ms),

                        const SizedBox(height: 24),

                        // Interests
                        Text('INTERESTS', style: AppTextStyles.label),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            'Beach', 'Culture', 'Food & Wine', 'Photography',
                            'Hiking', 'Art'
                          ].map((i) => GlassChip(label: i)).toList(),
                        ).animate().fadeIn(delay: 500.ms),

                        const SizedBox(height: 24),

                        // Destinations
                        Text('PREFERRED DESTINATIONS', style: AppTextStyles.label),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: ['Bali', 'Maldives', 'Santorini', 'Tokyo']
                              .map((d) => GlassChip(label: d, icon: Icons.place_outlined))
                              .toList(),
                        ).animate().fadeIn(delay: 600.ms),

                        const SizedBox(height: 24),

                        // Reviews
                        Text('REVIEWS', style: AppTextStyles.label),
                        const SizedBox(height: 12),
                        ...[
                          _ReviewData('Michael', 5.0, 'Amazing companion! Sofia made our Bali trip unforgettable.', '2 months ago'),
                          _ReviewData('James', 4.8, 'Great communication and very respectful. Highly recommend.', '4 months ago'),
                        ].map((r) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _ReviewCard(data: r),
                            )),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Floating action bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                        20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0.08),
                          Colors.white.withValues(alpha: 0.04),
                        ],
                      ),
                      border: Border(
                        top: BorderSide(
                            color: Colors.white.withValues(alpha: 0.1)),
                      ),
                    ),
                    child: Row(
                      children: [
                        GlassContainer(
                          borderRadius: 14,
                          padding: const EdgeInsets.all(12),
                          opacity: 0.1,
                          onTap: () => context.push('/video-call/$profileId'),
                          child: const Icon(Icons.videocam_rounded,
                              color: AppColors.accent, size: 22),
                        ),
                        const SizedBox(width: 8),
                        GlassContainer(
                          borderRadius: 14,
                          padding: const EdgeInsets.all(12),
                          opacity: 0.1,
                          child: const Icon(Icons.chat_bubble_rounded,
                              color: AppColors.accent, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GlassButton(
                            label: 'Propose Trip',
                            icon: Icons.flight_takeoff_rounded,
                            onPressed: () =>
                                context.push('/propose-trip/$profileId'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ).animate().slideY(begin: 1, duration: 500.ms, delay: 300.ms, curve: Curves.easeOut),
          ],
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatPill({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Icon(icon, size: 18, color: AppColors.accent),
            const SizedBox(height: 6),
            Text(value, style: AppTextStyles.heading3.copyWith(fontSize: 18)),
            Text(label, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}

class _ReviewData {
  final String name;
  final double rating;
  final String text;
  final String time;
  const _ReviewData(this.name, this.rating, this.text, this.time);
}

class _ReviewCard extends StatelessWidget {
  final _ReviewData data;
  const _ReviewCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GlassAvatar(size: 36),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.name, style: AppTextStyles.bodyMedium
                      .copyWith(fontWeight: FontWeight.w600)),
                  Text(data.time, style: AppTextStyles.caption),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.star_rounded,
                      size: 14, color: AppColors.accent),
                  const SizedBox(width: 4),
                  Text('${data.rating}',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.accent)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(data.text, style: AppTextStyles.bodySmall
              .copyWith(color: Colors.white.withValues(alpha: 0.7))),
        ],
      ),
    );
  }
}
