import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/glass_widgets.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int _selectedTier = 0;

  final _tiers = [
    _Tier('Silver', AppConstants.silverPrice.toInt(), null, [
      '3 contacts per month',
      '2 video calls per week',
      'Basic profile',
      'Standard support',
    ]),
    _Tier('Gold', AppConstants.goldPrice.toInt(), 'POPULAR', [
      '10 contacts per month',
      'Unlimited video calls',
      'Highlighted profile',
      'Priority support',
      'See who viewed you',
    ]),
    _Tier('Platinum', AppConstants.platinumPrice.toInt(), 'EXCLUSIVE', [
      'Unlimited contacts',
      'Unlimited video calls',
      'Featured profile',
      'VIP support',
      'See who viewed you',
      'Priority matching',
      'Exclusive events access',
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlassBackground.standard(
        child: SafeArea(
          child: Column(
            children: [
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
                    Text('Choose Your Plan', style: AppTextStyles.heading3),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('Unlock the full TripWife experience',
                    style: AppTextStyles.bodySmall),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                  itemCount: _tiers.length,
                  itemBuilder: (_, i) => _TierCard(
                    tier: _tiers[i],
                    isSelected: i == _selectedTier,
                    onTap: () => setState(() => _selectedTier = i),
                  ).animate().fadeIn(
                      delay: Duration(milliseconds: 100 + i * 100),
                      duration: 400.ms),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tier {
  final String name;
  final int price;
  final String? badge;
  final List<String> features;
  const _Tier(this.name, this.price, this.badge, this.features);
}

class _TierCard extends StatelessWidget {
  final _Tier tier;
  final bool isSelected;
  final VoidCallback onTap;

  const _TierCard({
    required this.tier,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassContainer(
        onTap: onTap,
        borderRadius: 24,
        opacity: isSelected ? 0.14 : 0.07,
        borderOpacity: isSelected ? 0.35 : 0.1,
        tintColor: isSelected ? AppColors.accent : Colors.white,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(tier.name,
                    style: AppTextStyles.heading2.copyWith(fontSize: 22)),
                if (tier.badge != null) ...[
                  const SizedBox(width: 10),
                  GlassBadge(
                    text: tier.badge!,
                    color: tier.badge == 'POPULAR'
                        ? AppColors.accent
                        : const Color(0xFFAB68FF),
                  ),
                ],
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('€',
                            style: AppTextStyles.priceCurrency
                                .copyWith(fontSize: 14)),
                        Text('${tier.price}',
                            style: AppTextStyles.price
                                .copyWith(fontSize: 32, color: Colors.white)),
                      ],
                    ),
                    Text('/month', style: AppTextStyles.caption),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...tier.features.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_rounded,
                        size: 18,
                        color: isSelected
                            ? AppColors.accent
                            : AppColors.success.withValues(alpha: 0.6)),
                    const SizedBox(width: 10),
                    Text(f, style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            GlassButton(
              label: isSelected ? 'Selected' : 'Select Plan',
              width: double.infinity,
              isPrimary: isSelected,
              onPressed: isSelected ? () {} : onTap,
            ),
          ],
        ),
      ),
    );
  }
}
