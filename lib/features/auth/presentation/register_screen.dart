import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/tw_button.dart';
import '../../../core/widgets/tw_text_field.dart';
import '../../../models/user_profile.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  UserGender? _gender;
  DateTime? _dateOfBirth;
  bool _isLoading = false;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
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
              surface: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _dateOfBirth = picked);
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (_gender == null || _dateOfBirth == null || !_acceptTerms) return;

    setState(() => _isLoading = true);
    // TODO: Implement Supabase registration
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
    if (mounted) context.go('/approval-pending');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () => context.go('/login'),
                    ),
                    const Spacer(),
                    Text('Apply to TripWife', style: AppTextStyles.heading3),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'All members are reviewed within 72 hours.',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.accentLight,
                          ),
                        ).animate().fadeIn(),

                        const SizedBox(height: 32),

                        // Gender selection
                        Text('I AM', style: AppTextStyles.label),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _GenderOption(
                              label: 'A Man',
                              icon: Icons.male_rounded,
                              selected: _gender == UserGender.male,
                              onTap: () =>
                                  setState(() => _gender = UserGender.male),
                            ),
                            const SizedBox(width: 12),
                            _GenderOption(
                              label: 'A Woman',
                              icon: Icons.female_rounded,
                              selected: _gender == UserGender.female,
                              onTap: () =>
                                  setState(() => _gender = UserGender.female),
                            ),
                          ],
                        ),

                        if (_gender == UserGender.male) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.accent.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.info_outline,
                                    color: AppColors.accent, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Subscription required after approval (from \u20AC199/mo)',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.accentLight,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 24),

                        Row(
                          children: [
                            Expanded(
                              child: TwTextField(
                                label: 'FIRST NAME',
                                hint: 'John',
                                controller: _firstNameCtrl,
                                validator: (v) =>
                                    v?.isEmpty ?? true ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TwTextField(
                                label: 'LAST NAME',
                                hint: 'Doe',
                                controller: _lastNameCtrl,
                                validator: (v) =>
                                    v?.isEmpty ?? true ? 'Required' : null,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        TwTextField(
                          label: 'EMAIL',
                          hint: 'your@email.com',
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          validator: (v) {
                            if (v?.isEmpty ?? true) return 'Required';
                            if (!v!.contains('@')) return 'Invalid email';
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        TwTextField(
                          label: 'PASSWORD',
                          hint: 'Min. 8 characters',
                          controller: _passwordCtrl,
                          obscureText: true,
                          prefixIcon: Icons.lock_outline,
                          validator: (v) {
                            if (v?.isEmpty ?? true) return 'Required';
                            if (v!.length < 8) return 'Min 8 characters';
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Date of birth
                        Text('DATE OF BIRTH', style: AppTextStyles.label),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _selectDate,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today_outlined,
                                    color: AppColors.mediumGrey, size: 20),
                                const SizedBox(width: 12),
                                Text(
                                  _dateOfBirth != null
                                      ? '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}'
                                      : 'Select your date of birth',
                                  style: _dateOfBirth != null
                                      ? AppTextStyles.bodyMedium
                                      : AppTextStyles.bodyMedium.copyWith(
                                          color: AppColors.mediumGrey),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Terms
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _acceptTerms,
                              onChanged: (v) =>
                                  setState(() => _acceptTerms = v ?? false),
                              activeColor: AppColors.accent,
                              side: const BorderSide(color: AppColors.mediumGrey),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(
                                    () => _acceptTerms = !_acceptTerms),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Text(
                                    'I agree to the Terms of Service and Privacy Policy. '
                                    'I understand that TripWife is not a dating platform and does not promote any illegal activity.',
                                    style: AppTextStyles.caption,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        TwButton(
                          label: 'Submit Application',
                          width: double.infinity,
                          isLoading: _isLoading,
                          onPressed: (_gender != null &&
                                  _dateOfBirth != null &&
                                  _acceptTerms)
                              ? _handleRegister
                              : null,
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
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
  final bool selected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: 200.ms,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.accent.withValues(alpha: 0.15)
                : AppColors.primaryLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppColors.accent : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(icon,
                  color: selected ? AppColors.accent : AppColors.mediumGrey,
                  size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: selected ? AppColors.accent : AppColors.mediumGrey,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
