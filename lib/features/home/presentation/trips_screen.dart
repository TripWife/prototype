import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Text('My Trips', style: AppTextStyles.heading2),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.flight_takeoff_rounded,
                        size: 64,
                        color: AppColors.mediumGrey.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No trips yet',
                        style: AppTextStyles.heading3.copyWith(
                          color: AppColors.mediumGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your confirmed trips will appear here',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ).animate().fadeIn(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
