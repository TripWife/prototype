import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/glass_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isMale = true;
  bool _agreedToTerms = false;
  bool _isLoading = false;
  DateTime? _dob;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 25),
      firstDate: DateTime(now.year - 80),
      lastDate: DateTime(now.year - 18),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.accent,
              surface: AppColors.primaryLight,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _dob = picked);
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) context.go('/approval-pending');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlassBackground.standard(
        child: SafeArea(
          child: Column(
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white.withValues(alpha: 0.8), size: 20),
                      onPressed: () => context.go('/login'),
                    ),
                    const Spacer(),
                    Text('Apply to TripWife', style: AppTextStyles.heading3),
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
                      Center(
                        child: GlassBadge(
                          text: 'All members are reviewed within 72 hours',
                          icon: Icons.schedule_rounded,
                          color: AppColors.accent,
                        ),
                      ).animate().fadeIn(),

                      const SizedBox(height: 28),

                      // Gender selection
                      Text('I AM', style: AppTextStyles.label),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _GenderOption(
                              label: 'A Man',
                              icon: Icons.male_rounded,
                              isSelected: _isMale,
                              onTap: () => setState(() => _isMale = true),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _GenderOption(
                              label: 'A Woman',
                              icon: Icons.female_rounded,
                              isSelected: !_isMale,
                              onTap: () => setState(() => _isMale = false),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 100.ms),

                      const SizedBox(height: 24),

                      // Name fields
                      Row(
                        children: [
                          Expanded(
                            child: GlassTextField(
                              label: 'First Name',
                              hint: 'John',
                              controller: _firstNameController,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GlassTextField(
                              label: 'Last Name',
                              hint: 'Doe',
                              controller: _lastNameController,
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 200.ms),

                      const SizedBox(height: 20),

                      GlassTextField(
                        label: 'Email',
                        hint: 'your@email.com',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.mail_outline_rounded,
                      ).animate().fadeIn(delay: 300.ms),

                      const SizedBox(height: 20),

                      GlassTextField(
                        label: 'Password',
                        hint: 'Min. 8 characters',
                        controller: _passwordController,
                        obscureText: true,
                        prefixIcon: Icons.lock_outline_rounded,
                      ).animate().fadeIn(delay: 400.ms),

                      const SizedBox(height: 20),

                      // Date of birth
                      GlassTextField(
                        label: 'Date of Birth',
                        hint: 'Select your date of birth',
                        prefixIcon: Icons.calendar_today_rounded,
                        readOnly: true,
                        onTap: _pickDate,
                        controller: TextEditingController(
                          text: _dob != null
                              ? '${_dob!.day}/${_dob!.month}/${_dob!.year}'
                              : '',
                        ),
                      ).animate().fadeIn(delay: 500.ms),

                      const SizedBox(height: 24),

                      // Subscription notice for men
                      if (_isMale)
                        GlassCard(
                          tintColor: AppColors.accent,
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(Icons.diamond_rounded,
                                  color: AppColors.accent, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Subscription required for men. Plans start at €199/month.',
                                  style: AppTextStyles.bodySmall.copyWith(
                                      color: Colors.white.withValues(alpha: 0.7)),
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(delay: 550.ms),

                      const SizedBox(height: 24),

                      // Terms
                      GestureDetector(
                        onTap: () =>
                            setState(() => _agreedToTerms = !_agreedToTerms),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GlassContainer(
                              borderRadius: 6,
                              padding: const EdgeInsets.all(2),
                              opacity: _agreedToTerms ? 0.3 : 0.06,
                              borderOpacity: _agreedToTerms ? 0.4 : 0.12,
                              tintColor: _agreedToTerms
                                  ? AppColors.accent
                                  : Colors.white,
                              child: Icon(
                                _agreedToTerms
                                    ? Icons.check_rounded
                                    : Icons.close_rounded,
                                size: 16,
                                color: _agreedToTerms
                                    ? AppColors.accent
                                    : Colors.transparent,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'I agree to the Terms of Service and Privacy Policy. I understand that TripWife is not a dating platform and does not promote any illegal activity.',
                                style: AppTextStyles.caption
                                    .copyWith(height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 600.ms),

                      const SizedBox(height: 28),

                      GlassButton(
                        label: 'Submit Application',
                        width: double.infinity,
                        isLoading: _isLoading,
                        onPressed:
                            _agreedToTerms ? _submit : null,
                      ).animate().fadeIn(delay: 700.ms),

                      const SizedBox(height: 24),
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
}

class _GenderOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      onTap: onTap,
      borderRadius: 16,
      opacity: isSelected ? 0.15 : 0.06,
      borderOpacity: isSelected ? 0.35 : 0.1,
      tintColor: isSelected ? AppColors.accent : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Icon(icon,
              size: 28,
              color: isSelected
                  ? AppColors.accent
                  : Colors.white.withValues(alpha: 0.4)),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? AppColors.accent
                  : Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
