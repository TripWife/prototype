import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/glass_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlassBackground.standard(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Logo
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.accent.withValues(alpha: 0.3),
                            AppColors.accent.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                    GlassContainer(
                      borderRadius: 40,
                      padding: const EdgeInsets.all(20),
                      opacity: 0.12,
                      child: const Icon(Icons.flight_rounded,
                          size: 36, color: AppColors.accent),
                    ),
                  ],
                ).animate().fadeIn().scale(
                    begin: const Offset(0.8, 0.8),
                    duration: 600.ms,
                    curve: Curves.easeOut),

                const SizedBox(height: 16),
                Text('TripWife', style: AppTextStyles.heading1)
                    .animate()
                    .fadeIn(delay: 100.ms),
                Text(
                  'Travel is better together',
                  style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.accent.withValues(alpha: 0.7)),
                ).animate().fadeIn(delay: 200.ms),

                const SizedBox(height: 48),

                // Welcome text
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back', style: AppTextStyles.heading2),
                      const SizedBox(height: 4),
                      Text('Sign in to continue your journey',
                          style: AppTextStyles.bodySmall),
                    ],
                  ),
                ).animate().fadeIn(delay: 300.ms),

                const SizedBox(height: 28),

                // Email
                GlassTextField(
                  label: 'Email',
                  hint: 'your@email.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.mail_outline_rounded,
                ).animate().fadeIn(delay: 400.ms),

                const SizedBox(height: 20),

                // Password
                GlassTextField(
                  label: 'Password',
                  hint: 'Enter your password',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  prefixIcon: Icons.lock_outline_rounded,
                  suffix: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: Colors.white.withValues(alpha: 0.3),
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ).animate().fadeIn(delay: 500.ms),

                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text('Forgot password?',
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.accent.withValues(alpha: 0.7))),
                  ),
                ),

                const SizedBox(height: 16),

                // Sign in button
                GlassButton(
                  label: 'Sign In',
                  width: double.infinity,
                  isLoading: _isLoading,
                  onPressed: _signIn,
                ).animate().fadeIn(delay: 600.ms),

                const SizedBox(height: 28),

                // Divider
                Row(
                  children: [
                    Expanded(child: GlassDivider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('or',
                          style: AppTextStyles.caption),
                    ),
                    Expanded(child: GlassDivider()),
                  ],
                ).animate().fadeIn(delay: 700.ms),

                const SizedBox(height: 28),

                // Social buttons
                GlassButton(
                  label: 'Continue with Apple',
                  icon: Icons.apple_rounded,
                  width: double.infinity,
                  isPrimary: false,
                  onPressed: () {},
                ).animate().fadeIn(delay: 750.ms),

                const SizedBox(height: 12),

                GlassButton(
                  label: 'Continue with Google',
                  icon: Icons.g_mobiledata_rounded,
                  width: double.infinity,
                  isPrimary: false,
                  onPressed: () {},
                ).animate().fadeIn(delay: 800.ms),

                const SizedBox(height: 32),

                // Register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ",
                        style: AppTextStyles.bodySmall),
                    GestureDetector(
                      onTap: () => context.go('/register'),
                      child: Text('Apply now',
                          style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ).animate().fadeIn(delay: 900.ms),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
