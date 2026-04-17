import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/glass_widgets.dart';

class DemoProfile {
  final String name;
  final int age;
  final String city;
  final double rating;
  final int trips;
  final bool isVerified;
  final bool isAvailable;
  final List<String> tags;

  const DemoProfile({
    required this.name,
    required this.age,
    required this.city,
    required this.rating,
    required this.trips,
    this.isVerified = true,
    this.isAvailable = true,
    this.tags = const [],
  });
}

const demoProfiles = [
  DemoProfile(
      name: 'Sofia',
      age: 27,
      city: 'Barcelona',
      rating: 4.8,
      trips: 3,
      tags: ['Beach', 'Culture', 'Food']),
  DemoProfile(
      name: 'Emma',
      age: 25,
      city: 'Paris',
      rating: 4.9,
      trips: 5,
      tags: ['Art', 'Wine', 'History']),
  DemoProfile(
      name: 'Mia',
      age: 29,
      city: 'Tokyo',
      rating: 4.7,
      trips: 8,
      isAvailable: false,
      tags: ['Adventure', 'Photography']),
  DemoProfile(
      name: 'Aria',
      age: 24,
      city: 'Milan',
      rating: 5.0,
      trips: 2,
      tags: ['Fashion', 'Food', 'Nightlife']),
  DemoProfile(
      name: 'Luna',
      age: 26,
      city: 'Lisbon',
      rating: 4.6,
      trips: 4,
      tags: ['Beach', 'Hiking', 'Music']),
  DemoProfile(
      name: 'Chloe',
      age: 28,
      city: 'London',
      rating: 4.8,
      trips: 6,
      tags: ['Culture', 'Theater', 'Travel']),
];

class ProfileCard extends StatelessWidget {
  final DemoProfile profile;
  final VoidCallback? onTap;

  const ProfileCard({super.key, required this.profile, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo area
          Stack(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.05),
                      Colors.white.withValues(alpha: 0.02),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(Icons.person_rounded,
                      size: 64,
                      color: Colors.white.withValues(alpha: 0.12)),
                ),
              ),
              // Verified badge
              if (profile.isVerified)
                Positioned(
                  left: 12,
                  top: 12,
                  child: GlassBadge(
                    text: 'Verified',
                    icon: Icons.verified_rounded,
                    color: AppColors.accent,
                  ),
                ),
              // Availability
              Positioned(
                right: 12,
                top: 12,
                child: GlassBadge(
                  text: profile.isAvailable ? 'Available' : 'Busy',
                  icon: Icons.circle,
                  color: profile.isAvailable
                      ? AppColors.success
                      : AppColors.warning,
                ),
              ),
            ],
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
                      '${profile.name}, ${profile.age}',
                      style: AppTextStyles.heading3,
                    ),
                    const Spacer(),
                    Icon(Icons.star_rounded,
                        size: 18, color: AppColors.accent),
                    const SizedBox(width: 4),
                    Text('${profile.rating}',
                        style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: 14,
                        color: Colors.white.withValues(alpha: 0.4)),
                    const SizedBox(width: 4),
                    Text(profile.city, style: AppTextStyles.bodySmall),
                    const SizedBox(width: 12),
                    Icon(Icons.flight_takeoff_rounded,
                        size: 14,
                        color: Colors.white.withValues(alpha: 0.4)),
                    const SizedBox(width: 4),
                    Text('${profile.trips} trips',
                        style: AppTextStyles.bodySmall),
                  ],
                ),
                if (profile.tags.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: profile.tags
                        .map((tag) => GlassChip(label: tag))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
