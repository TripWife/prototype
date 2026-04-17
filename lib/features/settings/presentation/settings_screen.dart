import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/glass_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _showOnlineStatus = true;
  bool _showLastActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlassBackground.standard(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white.withValues(alpha: 0.8), size: 20),
                      onPressed: () => context.pop(),
                    ),
                    const Spacer(),
                    Text('Settings', style: AppTextStyles.heading3),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Notifications
                      Text('NOTIFICATIONS', style: AppTextStyles.label),
                      const SizedBox(height: 12),
                      GlassCard(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          children: [
                            _SettingsToggle(
                              icon: Icons.notifications_rounded,
                              label: 'Push Notifications',
                              value: _pushNotifications,
                              onChanged: (v) =>
                                  setState(() => _pushNotifications = v),
                            ),
                            GlassDivider(),
                            _SettingsToggle(
                              icon: Icons.mail_rounded,
                              label: 'Email Notifications',
                              value: _emailNotifications,
                              onChanged: (v) =>
                                  setState(() => _emailNotifications = v),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Privacy
                      Text('PRIVACY', style: AppTextStyles.label),
                      const SizedBox(height: 12),
                      GlassCard(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          children: [
                            _SettingsToggle(
                              icon: Icons.circle,
                              label: 'Show Online Status',
                              value: _showOnlineStatus,
                              onChanged: (v) =>
                                  setState(() => _showOnlineStatus = v),
                            ),
                            GlassDivider(),
                            _SettingsToggle(
                              icon: Icons.access_time_rounded,
                              label: 'Show Last Active',
                              value: _showLastActive,
                              onChanged: (v) =>
                                  setState(() => _showLastActive = v),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Account
                      Text('ACCOUNT', style: AppTextStyles.label),
                      const SizedBox(height: 12),
                      GlassCard(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          children: [
                            _SettingsItem(
                              icon: Icons.lock_outline_rounded,
                              label: 'Change Password',
                            ),
                            GlassDivider(),
                            _SettingsItem(
                              icon: Icons.mail_outline_rounded,
                              label: 'Change Email',
                              subtitle: 'john@email.com',
                            ),
                            GlassDivider(),
                            _SettingsItem(
                              icon: Icons.language_rounded,
                              label: 'Language',
                              subtitle: 'English',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Legal
                      Text('LEGAL', style: AppTextStyles.label),
                      const SizedBox(height: 12),
                      GlassCard(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          children: [
                            _SettingsItem(
                              icon: Icons.description_outlined,
                              label: 'Terms of Service',
                            ),
                            GlassDivider(),
                            _SettingsItem(
                              icon: Icons.privacy_tip_outlined,
                              label: 'Privacy Policy',
                            ),
                            GlassDivider(),
                            _SettingsItem(
                              icon: Icons.handshake_outlined,
                              label: 'Community Guidelines',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Support
                      Text('SUPPORT', style: AppTextStyles.label),
                      const SizedBox(height: 12),
                      GlassCard(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          children: [
                            _SettingsItem(
                              icon: Icons.help_outline_rounded,
                              label: 'Help Center',
                            ),
                            GlassDivider(),
                            _SettingsItem(
                              icon: Icons.bug_report_outlined,
                              label: 'Report a Problem',
                            ),
                            GlassDivider(),
                            _SettingsItem(
                              icon: Icons.info_outline_rounded,
                              label: 'About TripWife',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Danger zone
                      Text('DANGER ZONE', style: AppTextStyles.label
                          .copyWith(color: AppColors.error.withValues(alpha: 0.7))),
                      const SizedBox(height: 12),
                      GlassCard(
                        tintColor: AppColors.error,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: _SettingsItem(
                          icon: Icons.delete_forever_rounded,
                          label: 'Delete Account',
                          isDestructive: true,
                          onTap: () => _showDeleteDialog(context),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.primaryLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Delete Account', style: AppTextStyles.heading3),
        content: Text(
          'Are you sure? This action cannot be undone. All your data, trips, and messages will be permanently deleted.',
          style: AppTextStyles.bodySmall
              .copyWith(color: Colors.white.withValues(alpha: 0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go('/login');
            },
            child: Text('Delete',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _SettingsToggle extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsToggle({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.white.withValues(alpha: 0.5)),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label, style: AppTextStyles.bodyMedium),
          ),
          GlassToggle(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final bool isDestructive;
  final VoidCallback? onTap;

  const _SettingsItem({
    required this.icon,
    required this.label,
    this.subtitle,
    this.isDestructive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon,
                size: 20,
                color: isDestructive
                    ? AppColors.error
                    : Colors.white.withValues(alpha: 0.5)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isDestructive ? AppColors.error : null,
                    ),
                  ),
                  if (subtitle != null)
                    Text(subtitle!, style: AppTextStyles.caption),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                size: 20,
                color: isDestructive
                    ? AppColors.error.withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: 0.2)),
          ],
        ),
      ),
    );
  }
}
