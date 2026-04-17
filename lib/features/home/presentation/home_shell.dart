import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/glass_widgets.dart';

class HomeShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomeShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlassBackground.standard(
        child: Stack(
          children: [
            navigationShell,
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: GlassNavBar(
                currentIndex: navigationShell.currentIndex,
                onTap: (i) => navigationShell.goBranch(
                  i,
                  initialLocation: i == navigationShell.currentIndex,
                ),
                items: const [
                  GlassNavItem(
                    icon: Icons.explore_outlined,
                    activeIcon: Icons.explore_rounded,
                    label: 'Discover',
                  ),
                  GlassNavItem(
                    icon: Icons.flight_outlined,
                    activeIcon: Icons.flight_rounded,
                    label: 'Trips',
                  ),
                  GlassNavItem(
                    icon: Icons.chat_bubble_outline_rounded,
                    activeIcon: Icons.chat_bubble_rounded,
                    label: 'Messages',
                    badge: 2,
                  ),
                  GlassNavItem(
                    icon: Icons.person_outline_rounded,
                    activeIcon: Icons.person_rounded,
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
