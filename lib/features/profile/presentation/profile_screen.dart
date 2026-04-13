import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/tw_avatar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Avatar
                const TwAvatar(
                  size: 100,
                  showBorder: true,
                  availabilityDot: AvailabilityDot.available,
                ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9)),

                const SizedBox(height: 16),

                Text('John Doe', style: AppTextStyles.heading2)
                    .animate()
                    .fadeIn(delay: 100.ms),
                Text(
                  'New York, USA',
                  style: AppTextStyles.bodySmall,
                ).animate().fadeIn(delay: 200.ms),

                const SizedBox(height: 8),

                // Subscription badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: AppColors.accentGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'SILVER MEMBER',
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.primary,
                      fontSize: 11,
                    ),
                  ),
                ).animate().fadeIn(delay: 300.ms),

                const SizedBox(height: 24),

                // Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatItem(label: 'Trips', value: '3'),
                    _StatItem(label: 'Rating', value: '4.8'),
                    _StatItem(label: 'Reviews', value: '5'),
                  ],
                ).animate().fadeIn(delay: 400.ms),

                const SizedBox(height: 32),

                // Menu items
                ...[
                  _MenuItem(
                      icon: Icons.edit_rounded,
                      label: 'Edit Profile',
                      onTap: () => context.go('/profile/edit')),
                  _MenuItem(
                      icon: Icons.photo_library_rounded,
                      label: 'Manage Photos',
                      onTap: () => context.go('/profile/edit')),
                  _MenuItem(
                      icon: Icons.credit_card_rounded,
                      label: 'Subscription',
                      onTap: () => context.go('/profile/subscription')),
                  _MenuItem(
                      icon: Icons.security_rounded,
                      label: 'Verification'),
                  _MenuItem(
                      icon: Icons.calendar_month_rounded,
                      label: 'Availability Calendar'),
                  _MenuItem(
                      icon: Icons.settings_rounded,
                      label: 'Settings',
                      onTap: () => context.go('/profile/settings')),
                  _MenuItem(
                      icon: Icons.help_outline_rounded, label: 'Help & FAQ'),
                  _MenuItem(
                    icon: Icons.logout_rounded,
                    label: 'Sign Out',
                    isDestructive: true,
                    onTap: () => context.go('/login'),
                  ),
                ]
                    .asMap()
                    .entries
                    .map((e) => e.value
                        .animate()
                        .fadeIn(
                            delay: Duration(milliseconds: 500 + e.key * 50)))
                    ,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.heading2.copyWith(
          color: AppColors.accent,
        )),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDestructive;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.isDestructive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(
          icon,
          color: isDestructive ? AppColors.error : AppColors.mediumGrey,
          size: 22,
        ),
        title: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDestructive ? AppColors.error : AppColors.white,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: isDestructive
              ? AppColors.error.withValues(alpha: 0.5)
              : AppColors.mediumGrey.withValues(alpha: 0.5),
        ),
        onTap: onTap,
      ),
    );
  }
}
