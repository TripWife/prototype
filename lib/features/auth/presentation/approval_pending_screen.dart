import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/glass_widgets.dart';

class ApprovalPendingScreen extends StatelessWidget {
  const ApprovalPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlassBackground.standard(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated glass hourglass
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.accent.withValues(alpha: 0.25),
                              AppColors.accent.withValues(alpha: 0),
                            ],
                          ),
                        ),
                      ),
                      GlassContainer(
                        borderRadius: 50,
                        padding: const EdgeInsets.all(28),
                        opacity: 0.1,
                        child: const Icon(Icons.hourglass_top_rounded,
                            size: 44, color: AppColors.accent),
                      ),
                    ],
                  )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .shimmer(
                          duration: 2000.ms,
                          color: AppColors.accent.withValues(alpha: 0.15)),

                  const SizedBox(height: 40),

                  Text('Application\nUnder Review',
                          style: AppTextStyles.heading1,
                          textAlign: TextAlign.center)
                      .animate()
                      .fadeIn(delay: 200.ms),

                  const SizedBox(height: 16),

                  Text(
                    'Your profile is being reviewed by our team. This process typically takes up to 72 hours.',
                    style: AppTextStyles.bodyLarge
                        .copyWith(color: Colors.white.withValues(alpha: 0.5)),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 400.ms),

                  const SizedBox(height: 48),

                  // Timeline steps
                  GlassCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        _TimelineStep(
                          icon: Icons.check_circle_rounded,
                          label: 'Application submitted',
                          isCompleted: true,
                          isActive: false,
                        ),
                        _TimelineConnector(),
                        _TimelineStep(
                          icon: Icons.search_rounded,
                          label: 'Identity verification',
                          isCompleted: false,
                          isActive: true,
                        ),
                        _TimelineConnector(),
                        _TimelineStep(
                          icon: Icons.verified_rounded,
                          label: 'Profile review',
                          isCompleted: false,
                          isActive: false,
                        ),
                        _TimelineConnector(),
                        _TimelineStep(
                          icon: Icons.celebration_rounded,
                          label: 'Welcome to TripWife',
                          isCompleted: false,
                          isActive: false,
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1),

                  const SizedBox(height: 32),

                  Text(
                    "We'll notify you by email once your application is processed.",
                    style: AppTextStyles.caption,
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 800.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isCompleted;
  final bool isActive;

  const _TimelineStep({
    required this.icon,
    required this.label,
    required this.isCompleted,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final color = isCompleted
        ? AppColors.success
        : isActive
            ? AppColors.accent
            : Colors.white.withValues(alpha: 0.2);

    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: isCompleted ? 0.2 : 0.1),
            border: Border.all(
                color: color.withValues(alpha: isCompleted ? 0.5 : 0.3)),
            boxShadow: isActive
                ? [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 8)]
                : null,
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 16),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isCompleted || isActive
                ? Colors.white
                : Colors.white.withValues(alpha: 0.35),
          ),
        ),
      ],
    );
  }
}

class _TimelineConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Container(
        width: 2,
        height: 24,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withValues(alpha: 0.15),
              Colors.white.withValues(alpha: 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
