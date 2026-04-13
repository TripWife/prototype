import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/tw_button.dart';

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
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
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
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Notifications
                      Text('NOTIFICATIONS', style: AppTextStyles.label),
                      const SizedBox(height: 12),
                      _SettingsToggle(
                        icon: Icons.notifications_rounded,
                        label: 'Push Notifications',
                        value: _pushNotifications,
                        onChanged: (v) =>
                            setState(() => _pushNotifications = v),
                      ),
                      _SettingsToggle(
                        icon: Icons.email_rounded,
                        label: 'Email Notifications',
                        value: _emailNotifications,
                        onChanged: (v) =>
                            setState(() => _emailNotifications = v),
                      ),

                      const SizedBox(height: 24),

                      // Privacy
                      Text('PRIVACY', style: AppTextStyles.label),
                      const SizedBox(height: 12),
                      _SettingsToggle(
                        icon: Icons.circle,
                        label: 'Show Online Status',
                        value: _showOnlineStatus,
                        onChanged: (v) =>
                            setState(() => _showOnlineStatus = v),
                      ),
                      _SettingsToggle(
                        icon: Icons.access_time_rounded,
                        label: 'Show Last Active',
                        value: _showLastActive,
                        onChanged: (v) =>
                            setState(() => _showLastActive = v),
                      ),

                      const SizedBox(height: 24),

                      // Account
                      Text('ACCOUNT', style: AppTextStyles.label),
                      const SizedBox(height: 12),
                      _SettingsItem(
                        icon: Icons.lock_outline,
                        label: 'Change Password',
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.email_outlined,
                        label: 'Change Email',
                        subtitle: 'john@email.com',
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.language_rounded,
                        label: 'Language',
                        subtitle: 'English',
                        onTap: () {},
                      ),

                      const SizedBox(height: 24),

                      // Legal
                      Text('LEGAL', style: AppTextStyles.label),
                      const SizedBox(height: 12),
                      _SettingsItem(
                        icon: Icons.description_outlined,
                        label: 'Terms of Service',
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.privacy_tip_outlined,
                        label: 'Privacy Policy',
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.gavel_rounded,
                        label: 'Community Guidelines',
                        onTap: () {},
                      ),

                      const SizedBox(height: 24),

                      // Support
                      Text('SUPPORT', style: AppTextStyles.label),
                      const SizedBox(height: 12),
                      _SettingsItem(
                        icon: Icons.help_outline,
                        label: 'Help Center',
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.bug_report_outlined,
                        label: 'Report a Problem',
                        onTap: () {},
                      ),
                      _SettingsItem(
                        icon: Icons.info_outline,
                        label: 'About TripWife',
                        subtitle: 'v1.0.0',
                        onTap: () {},
                      ),

                      const SizedBox(height: 32),

                      // Danger zone
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.error.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('DANGER ZONE',
                                style: AppTextStyles.label
                                    .copyWith(color: AppColors.error)),
                            const SizedBox(height: 12),
                            TwButton(
                              label: 'Delete Account',
                              icon: Icons.delete_forever_rounded,
                              width: double.infinity,
                              isOutlined: true,
                              onPressed: () {
                                _showDeleteDialog();
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
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

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Account?', style: AppTextStyles.heading3),
        content: Text(
          'This action is permanent and cannot be undone. All your data, '
          'conversations, and trip history will be permanently deleted.',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.lightGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.mediumGrey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Delete',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.error, fontWeight: FontWeight.w600)),
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
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.mediumGrey, size: 22),
      title: Text(label, style: AppTextStyles.bodyMedium),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.accent,
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.mediumGrey, size: 22),
      title: Text(label, style: AppTextStyles.bodyMedium),
      subtitle: subtitle != null
          ? Text(subtitle!, style: AppTextStyles.caption)
          : null,
      trailing: const Icon(Icons.chevron_right_rounded,
          color: AppColors.mediumGrey, size: 22),
      onTap: onTap,
    );
  }
}
