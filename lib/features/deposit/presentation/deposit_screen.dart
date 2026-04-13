import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/tw_button.dart';

class DepositScreen extends StatelessWidget {
  final String tripId;
  const DepositScreen({super.key, required this.tripId});

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
                      onPressed: () => context.pop(),
                    ),
                    const Spacer(),
                    Text('Security Deposit', style: AppTextStyles.heading3),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Shield icon
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.accent.withValues(alpha: 0.1),
                          border: Border.all(
                            color: AppColors.accent.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: const Icon(Icons.shield_rounded,
                            color: AppColors.accent, size: 48),
                      ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9)),

                      const SizedBox(height: 24),

                      // Amount
                      Text(
                        '\$${AppConstants.securityDeposit.toInt()}',
                        style: AppTextStyles.price,
                      ).animate().fadeIn(delay: 100.ms),
                      Text(
                        AppConstants.depositCurrency,
                        style: AppTextStyles.priceCurrency,
                      ),

                      const SizedBox(height: 8),
                      Text(
                        'Security Deposit',
                        style: AppTextStyles.heading3,
                      ),

                      const SizedBox(height: 32),

                      // Trip details card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text('TRIP DETAILS', style: AppTextStyles.label),
                            const SizedBox(height: 16),
                            _DetailRow(Icons.flight_takeoff_rounded,
                                'Destination', 'Bali, Indonesia'),
                            const SizedBox(height: 12),
                            _DetailRow(Icons.calendar_month_rounded, 'Dates',
                                'May 15 - May 25, 2026'),
                            const SizedBox(height: 12),
                            _DetailRow(Icons.person_rounded, 'Companion',
                                'Sofia'),
                            const SizedBox(height: 12),
                            _DetailRow(Icons.timelapse_rounded, 'Duration',
                                '10 days'),
                          ],
                        ),
                      ).animate().fadeIn(delay: 200.ms),

                      const SizedBox(height: 20),

                      // What it covers
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('WHAT THIS COVERS',
                                style: AppTextStyles.label),
                            const SizedBox(height: 16),
                            _CoverItem(Icons.flight_land_rounded,
                                'Return flight if trip ends early'),
                            const SizedBox(height: 10),
                            _CoverItem(Icons.hotel_rounded,
                                'Emergency accommodation'),
                            const SizedBox(height: 10),
                            _CoverItem(Icons.local_taxi_rounded,
                                'Emergency transportation'),
                            const SizedBox(height: 10),
                            _CoverItem(Icons.health_and_safety_rounded,
                                'Unforeseen travel expenses'),
                          ],
                        ),
                      ).animate().fadeIn(delay: 300.ms),

                      const SizedBox(height: 20),

                      // Important notice
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.warning.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.warning_amber_rounded,
                                color: AppColors.warning, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'This deposit is non-refundable. It will be held by the platform '
                                'and used only if your companion needs to return early or faces '
                                'an emergency during the trip.',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.warning,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 400.ms),

                      const SizedBox(height: 20),

                      // Payment flow info
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            _StepRow('1', 'You place the deposit',
                                isComplete: false, isActive: true),
                            _StepRow('2', 'She reviews and confirms',
                                isComplete: false),
                            _StepRow('3', 'Trip is officially confirmed',
                                isComplete: false),
                          ],
                        ),
                      ).animate().fadeIn(delay: 450.ms),

                      const SizedBox(height: 32),

                      // Pay button (opens external Stripe)
                      TwButton(
                        label: 'Place Deposit — \$${AppConstants.securityDeposit.toInt()}',
                        icon: Icons.lock_rounded,
                        width: double.infinity,
                        onPressed: () {
                          _showPaymentSheet(context);
                        },
                      ).animate().fadeIn(delay: 500.ms),

                      const SizedBox(height: 8),

                      Text(
                        'Payment processed securely via Stripe',
                        style: AppTextStyles.caption,
                        textAlign: TextAlign.center,
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

  void _showPaymentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.mediumGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Icon(Icons.open_in_new_rounded,
                color: AppColors.accent, size: 40),
            const SizedBox(height: 16),
            Text('External Payment', style: AppTextStyles.heading3),
            const SizedBox(height: 8),
            Text(
              'You will be redirected to our secure payment page powered by Stripe. '
              'The payment is processed outside the app.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.lightGrey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TwButton(
              label: 'Continue to Payment',
              icon: Icons.launch_rounded,
              width: double.infinity,
              onPressed: () {
                Navigator.pop(context);
                // TODO: url_launcher to Stripe checkout
              },
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.mediumGrey)),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.accent, size: 18),
        const SizedBox(width: 10),
        Text(label, style: AppTextStyles.bodySmall),
        const Spacer(),
        Text(value,
            style: AppTextStyles.bodyMedium
                .copyWith(fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _CoverItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _CoverItem(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.success, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text, style: AppTextStyles.bodySmall
              .copyWith(color: AppColors.lightGrey)),
        ),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  final String number;
  final String text;
  final bool isComplete;
  final bool isActive;
  const _StepRow(this.number, this.text,
      {this.isComplete = false, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isComplete
                  ? AppColors.success
                  : isActive
                      ? AppColors.accent
                      : AppColors.primary,
              border: Border.all(
                color: isComplete
                    ? AppColors.success
                    : isActive
                        ? AppColors.accent
                        : AppColors.mediumGrey,
              ),
            ),
            child: Center(
              child: isComplete
                  ? const Icon(Icons.check, size: 16, color: AppColors.white)
                  : Text(number,
                      style: AppTextStyles.caption.copyWith(
                        color: isActive ? AppColors.primary : AppColors.mediumGrey,
                        fontWeight: FontWeight.w700,
                      )),
            ),
          ),
          const SizedBox(width: 12),
          Text(text,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isActive ? AppColors.white : AppColors.mediumGrey,
              )),
        ],
      ),
    );
  }
}
