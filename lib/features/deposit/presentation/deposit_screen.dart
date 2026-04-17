import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/glass_widgets.dart';

class DepositScreen extends StatelessWidget {
  final String tripId;
  const DepositScreen({super.key, required this.tripId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlassBackground.standard(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white.withValues(alpha: 0.8), size: 20),
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
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),

                      // Shield icon with glow
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
                                  AppColors.accent.withValues(alpha: 0.2),
                                  AppColors.accent.withValues(alpha: 0),
                                ],
                              ),
                            ),
                          ),
                          GlassContainer(
                            borderRadius: 40,
                            padding: const EdgeInsets.all(22),
                            opacity: 0.12,
                            tintColor: AppColors.accent,
                            child: const Icon(Icons.shield_rounded,
                                size: 36, color: AppColors.accent),
                          ),
                        ],
                      ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9)),

                      const SizedBox(height: 20),

                      Text(
                        '\$${AppConstants.securityDeposit.toInt()}',
                        style: AppTextStyles.price.copyWith(
                          fontSize: 48,
                          color: Colors.white,
                        ),
                      ).animate().fadeIn(delay: 100.ms),
                      Text('USD', style: AppTextStyles.priceCurrency)
                          .animate()
                          .fadeIn(delay: 150.ms),
                      Text('Security Deposit', style: AppTextStyles.heading3)
                          .animate()
                          .fadeIn(delay: 200.ms),

                      const SizedBox(height: 28),

                      // Trip details
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('TRIP DETAILS', style: AppTextStyles.label),
                            const SizedBox(height: 16),
                            _DetailRow(Icons.flight_takeoff_rounded,
                                'Destination', 'Bali, Indonesia'),
                            const SizedBox(height: 12),
                            _DetailRow(Icons.calendar_month_rounded, 'Dates',
                                'May 15 - May 25, 2026'),
                            const SizedBox(height: 12),
                            _DetailRow(
                                Icons.person_rounded, 'Companion', 'Sofia'),
                            const SizedBox(height: 12),
                            _DetailRow(Icons.timer_rounded, 'Duration',
                                '10 days'),
                          ],
                        ),
                      ).animate().fadeIn(delay: 300.ms),

                      const SizedBox(height: 16),

                      // What this covers
                      GlassCard(
                        tintColor: AppColors.success,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('WHAT THIS COVERS',
                                style: AppTextStyles.label
                                    .copyWith(color: AppColors.success.withValues(alpha: 0.8))),
                            const SizedBox(height: 16),
                            _CoverItem(Icons.flight_land_rounded,
                                'Return flight if trip ends early'),
                            const SizedBox(height: 10),
                            _CoverItem(Icons.hotel_rounded,
                                'Emergency accommodation'),
                            const SizedBox(height: 10),
                            _CoverItem(Icons.directions_car_rounded,
                                'Emergency transportation'),
                            const SizedBox(height: 10),
                            _CoverItem(Icons.attach_money_rounded,
                                'Unforeseen travel expenses'),
                          ],
                        ),
                      ).animate().fadeIn(delay: 400.ms),

                      const SizedBox(height: 16),

                      // Warning
                      GlassCard(
                        tintColor: AppColors.warning,
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.warning_amber_rounded,
                                color: AppColors.warning, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'This deposit is non-refundable. It will be held by the platform and used only if your companion needs emergency return assistance.',
                                style: AppTextStyles.bodySmall.copyWith(
                                    color: Colors.white.withValues(alpha: 0.7)),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 500.ms),

                      const SizedBox(height: 24),

                      // Process steps
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('HOW IT WORKS', style: AppTextStyles.label),
                            const SizedBox(height: 16),
                            _StepRow('1', 'Place your security deposit'),
                            const SizedBox(height: 12),
                            _StepRow('2', 'Review & confirm trip details'),
                            const SizedBox(height: 12),
                            _StepRow('3', 'Trip confirmed — start planning!'),
                          ],
                        ),
                      ).animate().fadeIn(delay: 600.ms),

                      const SizedBox(height: 28),

                      GlassButton(
                        label: 'Pay via Stripe',
                        icon: Icons.lock_rounded,
                        width: double.infinity,
                        onPressed: () {
                          _showPaymentSheet(context);
                        },
                      ).animate().fadeIn(delay: 700.ms),

                      const SizedBox(height: 32),
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
      backgroundColor: Colors.transparent,
      builder: (ctx) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            padding: EdgeInsets.fromLTRB(
                24, 24, 24, MediaQuery.of(ctx).padding.bottom + 24),
            decoration: BoxDecoration(
              color: const Color(0xFF151738).withValues(alpha: 0.95),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(
                top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Icon(Icons.open_in_new_rounded,
                    color: AppColors.accent, size: 32),
                const SizedBox(height: 16),
                Text('External Payment', style: AppTextStyles.heading3),
                const SizedBox(height: 8),
                Text(
                  'You will be redirected to Stripe\'s secure payment page to complete the deposit.',
                  style: AppTextStyles.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                GlassButton(
                  label: 'Continue to Stripe',
                  icon: Icons.lock_rounded,
                  width: double.infinity,
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
                const SizedBox(height: 12),
                GlassButton(
                  label: 'Cancel',
                  width: double.infinity,
                  isPrimary: false,
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
          ),
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
        Icon(icon, size: 18, color: Colors.white.withValues(alpha: 0.4)),
        const SizedBox(width: 12),
        Text(label, style: AppTextStyles.bodySmall),
        const Spacer(),
        Text(value,
            style: AppTextStyles.bodyMedium
                .copyWith(fontWeight: FontWeight.w600, color: Colors.white)),
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
        Icon(icon, size: 18, color: AppColors.success),
        const SizedBox(width: 12),
        Text(text, style: AppTextStyles.bodyMedium),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  final String number;
  final String text;
  const _StepRow(this.number, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GlassContainer(
          borderRadius: 12,
          padding: const EdgeInsets.all(8),
          opacity: 0.12,
          tintColor: AppColors.accent,
          child: Text(number,
              style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 13,
                  fontWeight: FontWeight.w700)),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: AppTextStyles.bodyMedium)),
      ],
    );
  }
}
