import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/glass_widgets.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  static const _conversations = [
    {'name': 'Sofia', 'message': 'That sounds like a great plan!', 'time': '2m', 'unread': '2'},
    {'name': 'Emma', 'message': 'When are you thinking of flying?', 'time': '1h', 'unread': '0'},
    {'name': 'Mia', 'message': 'I loved the video call!', 'time': '3h', 'unread': '0'},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Text('Messages', style: AppTextStyles.heading1),
          ).animate().fadeIn(),
          const SizedBox(height: 16),
          Expanded(
            child: _conversations.isEmpty
                ? _EmptyState()
                : _ConversationList(),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GlassContainer(
            borderRadius: 40,
            padding: const EdgeInsets.all(24),
            opacity: 0.08,
            child: Icon(Icons.chat_bubble_outline_rounded,
                size: 36, color: Colors.white.withValues(alpha: 0.3)),
          ),
          const SizedBox(height: 16),
          Text('No conversations yet', style: AppTextStyles.heading3),
          const SizedBox(height: 8),
          Text('Start by discovering travel companions',
              style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}

class _ConversationList extends StatelessWidget {
  static const _conversations = ConversationsScreen._conversations;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      itemCount: _conversations.length,
      separatorBuilder: (_, __) =>
          GlassDivider(indent: 72),
      itemBuilder: (context, i) {
        final conv = _conversations[i];
        final hasUnread = conv['unread'] != '0';

        return GlassCard(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          onTap: () => context.go('/messages/chat/$i'),
          child: Row(
            children: [
              GlassAvatar(
                size: 52,
                availabilityDot:
                    i == 0 ? AvailabilityDot.available : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          conv['name']!,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight:
                                hasUnread ? FontWeight.w600 : FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          conv['time']!,
                          style: AppTextStyles.caption.copyWith(
                            color: hasUnread
                                ? AppColors.accent
                                : Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conv['message']!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: hasUnread
                                  ? Colors.white.withValues(alpha: 0.7)
                                  : Colors.white.withValues(alpha: 0.4),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (hasUnread)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: AppColors.accent.withValues(alpha: 0.4)),
                            ),
                            child: Text(
                              conv['unread']!,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: 100 * i));
      },
    );
  }
}
