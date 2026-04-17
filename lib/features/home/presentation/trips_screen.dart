import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/glass_widgets.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                          AppColors.accent.withValues(alpha: 0.15),
                          AppColors.accent.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                  GlassContainer(
                    borderRadius: 40,
                    padding: const EdgeInsets.all(24),
                    opacity: 0.08,
                    child: Icon(Icons.flight_takeoff_rounded,
                        size: 36, color: Colors.white.withValues(alpha: 0.3)),
                  ),
                ],
              ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9)),
              const SizedBox(height: 24),
              Text('No trips yet', style: AppTextStyles.heading3)
                  .animate()
                  .fadeIn(delay: 200.ms),
              const SizedBox(height: 8),
              Text(
                'Start by discovering travel companions',
                style: AppTextStyles.bodySmall,
              ).animate().fadeIn(delay: 300.ms),
            ],
          ),
        ),
      ),
    );
  }
}
