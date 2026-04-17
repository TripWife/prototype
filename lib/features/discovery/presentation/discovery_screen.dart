import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/glass_widgets.dart';
import '../widgets/profile_card.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  int _selectedFilter = 0;
  final _filters = ['All', 'Available Now', 'Europe', 'Asia', 'Americas'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Discover', style: AppTextStyles.heading1),
                    Text('Find your travel companion',
                        style: AppTextStyles.bodySmall),
                  ],
                ),
                const Spacer(),
                GlassContainer(
                  borderRadius: 14,
                  padding: const EdgeInsets.all(10),
                  opacity: 0.08,
                  onTap: () {},
                  child: Icon(Icons.tune_rounded,
                      color: Colors.white.withValues(alpha: 0.6), size: 22),
                ),
                const SizedBox(width: 8),
                GlassAvatar(
                  size: 42,
                  showGlassRing: true,
                  onTap: () => context.go('/home/profile'),
                ),
              ],
            ),
          ).animate().fadeIn(),

          // Filter chips
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
            child: SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) => GlassChip(
                  label: _filters[i],
                  isSelected: i == _selectedFilter,
                  onTap: () => setState(() => _selectedFilter = i),
                ),
              ),
            ),
          ).animate().fadeIn(delay: 100.ms),

          // Profile cards
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
              itemCount: demoProfiles.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ProfileCard(
                  profile: demoProfiles[i],
                  onTap: () => context.go('/home/profile-detail/$i'),
                ).animate().fadeIn(
                    delay: Duration(milliseconds: 150 + i * 80),
                    duration: 400.ms),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
