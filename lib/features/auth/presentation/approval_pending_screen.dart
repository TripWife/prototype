import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ApprovalPendingScreen extends StatelessWidget {
  const ApprovalPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accent.withValues(alpha: 0.1),
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.hourglass_top_rounded,
                      size: 56,
                      color: AppColors.accent,
                    ),
                  )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .shimmer(duration: 2000.ms, color: AppColors.accentLight.withValues(alpha: 0.3)),

                  const SizedBox(height: 40),

                  Text(
                    'Application\nUnder Review',
                    style: AppTextStyles.heading1,
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 200.ms),

                  const SizedBox(height: 16),

                  Text(
                    'Your profile is being reviewed by our team. This process typically takes up to 72 hours.',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.lightGrey,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 400.ms),

                  const SizedBox(height: 40),

                  // Timeline
                  _TimelineStep(
                    icon: Icons.check_circle,
                    label: 'Application submitted',
                    isComplete: true,
                    isFirst: true,
                  ),
                  _TimelineStep(
                    icon: Icons.search,
                    label: 'Identity verification',
                    isComplete: false,
                    isActive: true,
                  ),
                  _TimelineStep(
                    icon: Icons.verified_user,
                    label: 'Profile review',
                    isComplete: false,
                  ),
                  _TimelineStep(
                    icon: Icons.celebration,
                    label: 'Welcome to TripWife',
                    isComplete: false,
                    isLast: true,
                  ),

                  const SizedBox(height: 40),

                  Text(
                    'We\'ll notify you by email once your application is processed.',
                    style: AppTextStyles.bodySmall,
                    textAlign: TextAlign.center,
                  ),
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
  final bool isComplete;
  final bool isActive;
  final bool isFirst;
  final bool isLast;

  const _TimelineStep({
    required this.icon,
    required this.label,
    this.isComplete = false,
    this.isActive = false,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isComplete
        ? AppColors.success
        : isActive
            ? AppColors.accent
            : AppColors.mediumGrey.withValues(alpha: 0.3);

    return Row(
      children: [
        SizedBox(
          width: 40,
          child: Column(
            children: [
              if (!isFirst)
                Container(width: 2, height: 16, color: color),
              Icon(icon, color: color, size: 24),
              if (!isLast)
                Container(width: 2, height: 16, color: color),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isComplete || isActive
                ? AppColors.white
                : AppColors.mediumGrey,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
