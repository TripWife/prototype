import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/glass_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final _pages = const [
    _OnboardingData(
      icon: Icons.flight_takeoff_rounded,
      title: 'Travel is better\ntogether',
      subtitle:
          'Connect with verified travel companions who share your passion for discovering the world.',
      orbColor: Color(0x35D4A853),
    ),
    _OnboardingData(
      icon: Icons.verified_user_rounded,
      title: 'Trust &\nSafety first',
      subtitle:
          'Every member is verified. Security deposits protect every journey. Your safety is our priority.',
      orbColor: Color(0x3534D399),
    ),
    _OnboardingData(
      icon: Icons.videocam_rounded,
      title: 'Meet before\nyou travel',
      subtitle:
          'Video calls let you connect face-to-face before committing to a trip together.',
      orbColor: Color(0x3560A5FA),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlassBackground.standard(
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GlassChip(
                    label: 'Skip',
                    onTap: () => context.go('/login'),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (_, i) => _OnboardingPage(data: _pages[i]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (i) => AnimatedContainer(
                      duration: 300.ms,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: i == _currentPage ? 28 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: i == _currentPage
                            ? AppColors.accent
                            : Colors.white.withValues(alpha: 0.12),
                        boxShadow: i == _currentPage
                            ? [
                                BoxShadow(
                                  color: AppColors.accent.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: GlassButton(
                  label: _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                  icon: _currentPage == _pages.length - 1
                      ? Icons.arrow_forward_rounded
                      : null,
                  width: double.infinity,
                  onPressed: () {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                          duration: 400.ms, curve: Curves.easeInOut);
                    } else {
                      context.go('/login');
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16, top: 8),
                child: TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text(
                    'Already have an account? Sign in',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.accent.withValues(alpha: 0.7),
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

class _OnboardingData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color orbColor;
  const _OnboardingData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.orbColor,
  });
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingData data;
  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [data.orbColor, data.orbColor.withValues(alpha: 0)],
                  ),
                ),
              ),
              GlassContainer(
                borderRadius: 50,
                padding: const EdgeInsets.all(28),
                opacity: 0.1,
                child: Icon(data.icon, size: 44, color: AppColors.accent),
              ),
            ],
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .scale(begin: const Offset(0.8, 0.8), duration: 600.ms, curve: Curves.easeOut),
          const SizedBox(height: 48),
          Text(data.title, style: AppTextStyles.heading1, textAlign: TextAlign.center)
              .animate()
              .fadeIn(delay: 200.ms, duration: 500.ms)
              .slideY(begin: 0.2, duration: 500.ms),
          const SizedBox(height: 20),
          Text(
            data.subtitle,
            style: AppTextStyles.bodyLarge.copyWith(color: Colors.white.withValues(alpha: 0.5)),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(delay: 400.ms, duration: 500.ms)
              .slideY(begin: 0.15, duration: 500.ms),
        ],
      ),
    );
  }
}
