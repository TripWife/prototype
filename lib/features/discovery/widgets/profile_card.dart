import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ProfileCard extends StatelessWidget {
  final int index;
  final VoidCallback? onTap;

  const ProfileCard({super.key, required this.index, this.onTap});

  // Demo data
  static const _demoProfiles = [
    {'name': 'Sofia', 'age': '27', 'city': 'Barcelona', 'trips': '3', 'rating': '4.8'},
    {'name': 'Emma', 'age': '25', 'city': 'Paris', 'trips': '5', 'rating': '4.9'},
    {'name': 'Mia', 'age': '29', 'city': 'Milan', 'trips': '2', 'rating': '4.7'},
    {'name': 'Isabella', 'age': '26', 'city': 'Madrid', 'trips': '1', 'rating': '5.0'},
    {'name': 'Olivia', 'age': '28', 'city': 'London', 'trips': '4', 'rating': '4.6'},
    {'name': 'Ava', 'age': '24', 'city': 'Lisbon', 'trips': '0', 'rating': '-'},
  ];

  @override
  Widget build(BuildContext context) {
    final profile = _demoProfiles[index % _demoProfiles.length];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            // Photo placeholder
            Container(
              height: 240,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.accent.withValues(alpha: 0.05 + (index * 0.03)),
                    AppColors.rose.withValues(alpha: 0.05 + (index * 0.02)),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Placeholder icon
                  Center(
                    child: Icon(
                      Icons.person_rounded,
                      size: 80,
                      color: AppColors.mediumGrey.withValues(alpha: 0.3),
                    ),
                  ),
                  // Availability badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.available.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Available',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Verified badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryDark.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified,
                        color: AppColors.accent,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${profile['name']}, ${profile['age']}',
                        style: AppTextStyles.heading3,
                      ),
                      const Spacer(),
                      if (profile['rating'] != '-') ...[
                        const Icon(Icons.star_rounded,
                            color: AppColors.accent, size: 18),
                        const SizedBox(width: 2),
                        Text(
                          profile['rating']!,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          color: AppColors.mediumGrey, size: 16),
                      const SizedBox(width: 4),
                      Text(profile['city']!, style: AppTextStyles.bodySmall),
                      const SizedBox(width: 16),
                      const Icon(Icons.flight_rounded,
                          color: AppColors.mediumGrey, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${profile['trips']} trips',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Interests preview
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: ['Beach', 'Culture', 'Food']
                        .map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tag,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.lightGrey,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
