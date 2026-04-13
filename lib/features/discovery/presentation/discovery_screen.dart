import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/tw_avatar.dart';
import '../widgets/profile_card.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  String _selectedFilter = 'All';
  final _filters = ['All', 'Available Now', 'Europe', 'Asia', 'Americas'];

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
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Discover', style: AppTextStyles.heading2),
                        Text(
                          'Find your travel companion',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.tune_rounded,
                          color: AppColors.accent),
                      onPressed: () {
                        // TODO: Open filters
                      },
                    ),
                    TwAvatar(
                      size: 40,
                      onTap: () => context.go('/home/profile'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Filter chips
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _filters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final isSelected = _selectedFilter == _filters[i];
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _selectedFilter = _filters[i]),
                      child: AnimatedContainer(
                        duration: 200.ms,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.accent
                              : AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _filters[i],
                          style: AppTextStyles.bodySmall.copyWith(
                            color:
                                isSelected ? AppColors.primary : AppColors.white,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Profile cards
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: 6, // Demo count
                  itemBuilder: (_, i) {
                    return ProfileCard(
                      index: i,
                      onTap: () => context.go('/home/profile-detail/$i'),
                    ).animate().fadeIn(
                          delay: Duration(milliseconds: 100 * i),
                          duration: 400.ms,
                        );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
