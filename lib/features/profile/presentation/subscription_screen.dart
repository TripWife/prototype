import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/tw_button.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int _selectedTier = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () => context.pop(),
                    ),
                    const Spacer(),
                    Text('Choose Your Plan', style: AppTextStyles.heading3),
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
                      Text(
                        'Unlock the full TripWife experience',
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.mediumGrey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Tier cards
                      _TierCard(
                        tier: 'Silver',
                        price: AppConstants.silverPrice,
                        features: [
                          '${AppConstants.silverContactsPerMonth} contacts per month',
                          '${AppConstants.silverCallsPerWeek} video calls per week',
                          'Basic profile',
                          'Standard support',
                        ],
                        isSelected: _selectedTier == 0,
                        onTap: () => setState(() => _selectedTier = 0),
                      ).animate().fadeIn(delay: 100.ms),

                      const SizedBox(height: 12),

                      _TierCard(
                        tier: 'Gold',
                        price: AppConstants.goldPrice,
                        badge: 'POPULAR',
                        features: [
                          '${AppConstants.goldContactsPerMonth} contacts per month',
                          'Unlimited video calls',
                          'Highlighted profile',
                          'Priority support',
                          'See who viewed you',
                        ],
                        isSelected: _selectedTier == 1,
                        isRecommended: true,
                        onTap: () => setState(() => _selectedTier = 1),
                      ).animate().fadeIn(delay: 200.ms),

                      const SizedBox(height: 12),

                      _TierCard(
                        tier: 'Platinum',
                        price: AppConstants.platinumPrice,
                        badge: 'EXCLUSIVE',
                        features: [
                          'Unlimited contacts',
                          'Unlimited video calls',
                          'Top of discovery feed',
                          'Personal concierge',
                          'Express verification (24h)',
                          'Exclusive badges',
                        ],
                        isSelected: _selectedTier == 2,
                        onTap: () => setState(() => _selectedTier = 2),
                      ).animate().fadeIn(delay: 300.ms),

                      const SizedBox(height: 24),

                      TwButton(
                        label: 'Subscribe Now',
                        icon: Icons.diamond_rounded,
                        width: double.infinity,
                        onPressed: () {
                          // TODO: Open external Stripe payment
                        },
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Payment processed outside the app via Stripe.\nCancel anytime.',
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
}

class _TierCard extends StatelessWidget {
  final String tier;
  final double price;
  final String? badge;
  final List<String> features;
  final bool isSelected;
  final bool isRecommended;
  final VoidCallback onTap;

  const _TierCard({
    required this.tier,
    required this.price,
    this.badge,
    required this.features,
    required this.isSelected,
    this.isRecommended = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 250.ms,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accent.withValues(alpha: 0.08)
              : AppColors.primaryLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.accent : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(tier, style: AppTextStyles.heading3),
                const SizedBox(width: 8),
                if (badge != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isRecommended
                          ? AppColors.accent
                          : AppColors.rose,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      badge!,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('\u20AC',
                            style: AppTextStyles.bodyMedium
                                .copyWith(color: AppColors.accent)),
                        Text('${price.toInt()}',
                            style: AppTextStyles.heading1
                                .copyWith(color: AppColors.accent, fontSize: 28)),
                      ],
                    ),
                    Text('/month', style: AppTextStyles.caption),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...features.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: isSelected ? AppColors.accent : AppColors.mediumGrey,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(f,
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.lightGrey)),
                    ),
                  ],
                ),
              ),
            ),
            if (isSelected) ...[
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Selected',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
