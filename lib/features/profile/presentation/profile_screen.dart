import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/glass_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Avatar
            GlassAvatar(size: 100, showGlassRing: true)
                .animate()
                .fadeIn()
                .scale(begin: const Offset(0.9, 0.9)),

            const SizedBox(height: 16),

            Text('John Doe', style: AppTextStyles.heading2)
                .animate()
                .fadeIn(delay: 100.ms),
            Text('New York, USA', style: AppTextStyles.bodySmall)
                .animate()
                .fadeIn(delay: 200.ms),

            const SizedBox(height: 12),

            // Subscription badge
            GlassBadge(
              text: 'SILVER MEMBER',
              icon: Icons.diamond_rounded,
              color: AppColors.accent,
            ).animate().fadeIn(delay: 300.ms),

            const SizedBox(height: 24),

            // Stats
            Row(
              children: [
                _StatPill(value: '3', label: 'Trips'),
                const SizedBox(width: 8),
                _StatPill(value: '4.8', label: 'Rating'),
                const SizedBox(width: 8),
                _StatPill(value: '5', label: 'Reviews'),
              ],
            ).animate().fadeIn(delay: 400.ms),

            const SizedBox(height: 32),

            // Menu items
            ...[
              _MenuItem(
                icon: Icons.edit_rounded,
                label: 'Edit Profile',
                onTap: () => context.go('/profile/edit'),
              ),
              _MenuItem(
                icon: Icons.photo_library_rounded,
                label: 'Manage Photos',
                onTap: () => context.go('/profile/edit'),
              ),
              _MenuItem(
                icon: Icons.credit_card_rounded,
                label: 'Subscription',
                onTap: () => context.go('/profile/subscription'),
              ),
              _MenuItem(
                icon: Icons.verified_user_rounded,
                label: 'Verification',
              ),
              _MenuItem(
                icon: Icons.calendar_month_rounded,
                label: 'Availability Calendar',
              ),
              _MenuItem(
                icon: Icons.settings_rounded,
                label: 'Settings',
                onTap: () => context.go('/profile/settings'),
              ),
              _MenuItem(
                icon: Icons.help_outline_rounded,
                label: 'Help & FAQ',
              ),
              _MenuItem(
                icon: Icons.logout_rounded,
                label: 'Sign Out',
                isDestructive: true,
                onTap: () => context.go('/login'),
              ),
            ].asMap().entries.map(
                  (e) => e.value
                      .animate()
                      .fadeIn(delay: Duration(milliseconds: 500 + e.key * 50)),
                ),
          ],
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String value;
  final String label;
  const _StatPill({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          children: [
            Text(value,
                style: AppTextStyles.heading3
                    .copyWith(color: AppColors.accent)),
            const SizedBox(height: 2),
            Text(label, style: AppTextStyles.caption),
          ],
        ),
      ),
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
    final color = isDestructive ? AppColors.error : Colors.white;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        onTap: onTap,
        tintColor: isDestructive ? AppColors.error : null,
        child: Row(
          children: [
            Icon(icon,
                size: 20,
                color: isDestructive
                    ? AppColors.error
                    : Colors.white.withValues(alpha: 0.5)),
            const SizedBox(width: 14),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: color.withValues(alpha: isDestructive ? 1 : 0.85),
              ),
            ),
            const Spacer(),
            Icon(Icons.chevron_right_rounded,
                color: color.withValues(alpha: 0.25), size: 20),
          ],
        ),
      ),
    );
  }
}
