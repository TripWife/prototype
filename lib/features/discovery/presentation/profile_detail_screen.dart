import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/tw_button.dart';

class ProfileDetailScreen extends StatelessWidget {
  final String profileId;

  const ProfileDetailScreen({super.key, required this.profileId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                // Photo gallery
                SliverAppBar(
                  expandedHeight: 420,
                  pinned: true,
                  backgroundColor: AppColors.primaryDark,
                  leading: _CircleBackButton(onTap: () => context.pop()),
                  actions: [
                    _CircleIconButton(
                      icon: Icons.share_rounded,
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    _CircleIconButton(
                      icon: Icons.flag_outlined,
                      onTap: () {},
                    ),
                    const SizedBox(width: 12),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: _PhotoGallery(profileId: profileId),
                  ),
                ),

                // Profile content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name, age, verification
                        Row(
                          children: [
                            Text('Sofia, 27', style: AppTextStyles.heading1),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.accent,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.check,
                                  color: AppColors.primary, size: 14),
                            ),
                          ],
                        ).animate().fadeIn(),

                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                color: AppColors.mediumGrey, size: 16),
                            const SizedBox(width: 4),
                            Text('Barcelona, Spain',
                                style: AppTextStyles.bodyMedium
                                    .copyWith(color: AppColors.mediumGrey)),
                            const SizedBox(width: 16),
                            const Icon(Icons.work_outline,
                                color: AppColors.mediumGrey, size: 16),
                            const SizedBox(width: 4),
                            Text('Photographer',
                                style: AppTextStyles.bodyMedium
                                    .copyWith(color: AppColors.mediumGrey)),
                          ],
                        ).animate().fadeIn(delay: 100.ms),

                        const SizedBox(height: 20),

                        // Stats row
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _StatColumn(
                                  value: '3', label: 'Trips', icon: Icons.flight_rounded),
                              Container(width: 1, height: 32, color: AppColors.primary),
                              _StatColumn(
                                  value: '4.8', label: 'Rating', icon: Icons.star_rounded),
                              Container(width: 1, height: 32, color: AppColors.primary),
                              _StatColumn(
                                  value: '5', label: 'Reviews', icon: Icons.rate_review_rounded),
                            ],
                          ),
                        ).animate().fadeIn(delay: 200.ms),

                        const SizedBox(height: 24),

                        // About
                        Text('ABOUT', style: AppTextStyles.label),
                        const SizedBox(height: 8),
                        Text(
                          'Passionate traveler and photographer. I love exploring new cultures, '
                          'tasting local cuisine, and capturing beautiful moments. Looking for a '
                          'respectful travel companion to share adventures with. I speak English, '
                          'Spanish, and a bit of French.',
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: AppColors.lightGrey, height: 1.6),
                        ).animate().fadeIn(delay: 300.ms),

                        const SizedBox(height: 24),

                        // Languages
                        Text('LANGUAGES', style: AppTextStyles.label),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: ['English', 'Spanish', 'French']
                              .map((l) => _ChipTag(label: l, icon: Icons.translate))
                              .toList(),
                        ).animate().fadeIn(delay: 350.ms),

                        const SizedBox(height: 24),

                        // Interests
                        Text('INTERESTS', style: AppTextStyles.label),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            'Beach',
                            'Culture',
                            'Food & Wine',
                            'Photography',
                            'Hiking',
                            'Art',
                          ]
                              .map((i) => _ChipTag(label: i))
                              .toList(),
                        ).animate().fadeIn(delay: 400.ms),

                        const SizedBox(height: 24),

                        // Preferred destinations
                        Text('PREFERRED DESTINATIONS', style: AppTextStyles.label),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            'Bali',
                            'Maldives',
                            'Santorini',
                            'Tokyo',
                            'Paris',
                          ]
                              .map((d) => _ChipTag(
                                  label: d, icon: Icons.flight_takeoff_rounded))
                              .toList(),
                        ).animate().fadeIn(delay: 450.ms),

                        const SizedBox(height: 24),

                        // Reviews
                        Text('REVIEWS', style: AppTextStyles.label),
                        const SizedBox(height: 12),
                        _ReviewCard(
                          name: 'Marco',
                          rating: 5.0,
                          date: 'Bali, March 2026',
                          text: 'Amazing travel companion. Very respectful and fun. '
                              'We had a wonderful time exploring the temples.',
                        ).animate().fadeIn(delay: 500.ms),
                        const SizedBox(height: 12),
                        _ReviewCard(
                          name: 'James',
                          rating: 4.5,
                          date: 'Paris, January 2026',
                          text: 'Great company, wonderful person. Highly recommend.',
                        ).animate().fadeIn(delay: 550.ms),

                        // Bottom padding for floating button
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Floating action bar
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryDark.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primaryLight,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Video call button
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.videocam_rounded,
                            color: AppColors.accent),
                        onPressed: () => context.push('/video-call/$profileId'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Message button
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.chat_bubble_rounded,
                            color: AppColors.accent),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Propose trip button
                    Expanded(
                      child: TwButton(
                        label: 'Propose Trip',
                        icon: Icons.flight_takeoff_rounded,
                        onPressed: () => context.push('/propose-trip/$profileId'),
                      ),
                    ),
                  ],
                ),
              ).animate().slideY(begin: 1, duration: 500.ms, delay: 300.ms, curve: Curves.easeOut),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleBackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _CircleBackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryDark.withValues(alpha: 0.6),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back_ios_new, size: 18),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryDark.withValues(alpha: 0.6),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: AppColors.white),
      ),
    );
  }
}

class _PhotoGallery extends StatefulWidget {
  final String profileId;
  const _PhotoGallery({required this.profileId});

  @override
  State<_PhotoGallery> createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<_PhotoGallery> {
  int _currentPhoto = 0;
  final int _totalPhotos = 4;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        final width = MediaQuery.of(context).size.width;
        if (details.globalPosition.dx > width / 2) {
          if (_currentPhoto < _totalPhotos - 1) {
            setState(() => _currentPhoto++);
          }
        } else {
          if (_currentPhoto > 0) {
            setState(() => _currentPhoto--);
          }
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Photo placeholder
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.accent.withValues(alpha: 0.08),
                  AppColors.rose.withValues(alpha: 0.06),
                  AppColors.primaryLight,
                ],
              ),
            ),
            child: Icon(
              Icons.person_rounded,
              size: 120,
              color: AppColors.mediumGrey.withValues(alpha: 0.2),
            ),
          ),
          // Photo indicators at top
          Positioned(
            top: MediaQuery.of(context).padding.top + 44,
            left: 12,
            right: 12,
            child: Row(
              children: List.generate(
                _totalPhotos,
                (i) => Expanded(
                  child: Container(
                    height: 3,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: i == _currentPhoto
                          ? AppColors.white
                          : AppColors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Gradient overlay at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.primaryDark.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  const _StatColumn({required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.accent, size: 20),
        const SizedBox(height: 4),
        Text(value,
            style: AppTextStyles.heading3.copyWith(color: AppColors.accent)),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

class _ChipTag extends StatelessWidget {
  final String label;
  final IconData? icon;
  const _ChipTag({required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: AppColors.accentLight),
            const SizedBox(width: 4),
          ],
          Text(label,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.lightGrey)),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final String name;
  final double rating;
  final String date;
  final String text;
  const _ReviewCard(
      {required this.name,
      required this.rating,
      required this.date,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(name[0],
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.accent, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: AppTextStyles.bodyMedium
                          .copyWith(fontWeight: FontWeight.w600)),
                  Text(date, style: AppTextStyles.caption),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: AppColors.accent, size: 16),
                  const SizedBox(width: 2),
                  Text(rating.toString(),
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.accent, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(text,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.lightGrey, height: 1.5)),
        ],
      ),
    );
  }
}
