import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/approval_pending_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/chat/presentation/chat_detail_screen.dart';
import '../../features/chat/presentation/conversations_screen.dart';
import '../../features/deposit/presentation/deposit_screen.dart';
import '../../features/deposit/presentation/propose_trip_screen.dart';
import '../../features/discovery/presentation/discovery_screen.dart';
import '../../features/discovery/presentation/profile_detail_screen.dart';
import '../../features/home/presentation/home_shell.dart';
import '../../features/home/presentation/trips_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/profile/presentation/edit_profile_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/profile/presentation/subscription_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/video_call/presentation/video_call_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/onboarding',
  routes: [
    // Onboarding
    GoRoute(
      path: '/onboarding',
      builder: (_, __) => const OnboardingScreen(),
    ),

    // Auth
    GoRoute(
      path: '/login',
      builder: (_, __) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (_, __) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/approval-pending',
      builder: (_, __) => const ApprovalPendingScreen(),
    ),

    // Full-screen overlays (outside bottom nav)
    GoRoute(
      path: '/video-call/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) => VideoCallScreen(
        recipientId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/propose-trip/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) => ProposeTripScreen(
        recipientId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/deposit/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) => DepositScreen(
        tripId: state.pathParameters['id']!,
      ),
    ),

    // Main app with bottom nav
    StatefulShellRoute.indexedStack(
      builder: (_, __, navigationShell) =>
          HomeShell(navigationShell: navigationShell),
      branches: [
        // Discovery tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (_, __) => const DiscoveryScreen(),
              routes: [
                GoRoute(
                  path: 'profile-detail/:id',
                  builder: (_, state) => ProfileDetailScreen(
                    profileId: state.pathParameters['id']!,
                  ),
                ),
              ],
            ),
          ],
        ),

        // Trips tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/trips',
              builder: (_, __) => const TripsScreen(),
            ),
          ],
        ),

        // Messages tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/messages',
              builder: (_, __) => const ConversationsScreen(),
              routes: [
                GoRoute(
                  path: 'chat/:id',
                  builder: (_, state) => ChatDetailScreen(
                    conversationId: state.pathParameters['id']!,
                  ),
                ),
              ],
            ),
          ],
        ),

        // Profile tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (_, __) => const ProfileScreen(),
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (_, __) => const EditProfileScreen(),
                ),
                GoRoute(
                  path: 'subscription',
                  builder: (_, __) => const SubscriptionScreen(),
                ),
                GoRoute(
                  path: 'settings',
                  builder: (_, __) => const SettingsScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
