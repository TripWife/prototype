import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/tw_avatar.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

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
                child: Text('Messages', style: AppTextStyles.heading2),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _buildConversationList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConversationList() {
    // Demo conversations
    final conversations = [
      {'name': 'Sofia', 'message': 'That sounds like a great plan!', 'time': '2m', 'unread': '2'},
      {'name': 'Emma', 'message': 'When are you thinking of flying?', 'time': '1h', 'unread': '0'},
      {'name': 'Mia', 'message': 'I loved the video call!', 'time': '3h', 'unread': '0'},
    ];

    if (conversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline,
                size: 64, color: AppColors.mediumGrey.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text(
              'No conversations yet',
              style: AppTextStyles.heading3.copyWith(color: AppColors.mediumGrey),
            ),
            const SizedBox(height: 8),
            Text(
              'Start by discovering travel companions',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: conversations.length,
      separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
      itemBuilder: (context, i) {
        final conv = conversations[i];
        final hasUnread = conv['unread'] != '0';

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          leading: TwAvatar(
            size: 52,
            availabilityDot: i == 0 ? AvailabilityDot.available : null,
          ),
          title: Row(
            children: [
              Text(
                conv['name']!,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              const Spacer(),
              Text(
                conv['time']!,
                style: AppTextStyles.caption.copyWith(
                  color: hasUnread ? AppColors.accent : AppColors.mediumGrey,
                ),
              ),
            ],
          ),
          subtitle: Row(
            children: [
              Expanded(
                child: Text(
                  conv['message']!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: hasUnread ? AppColors.white : AppColors.mediumGrey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (hasUnread)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    conv['unread']!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          onTap: () => context.go('/messages/chat/$i'),
        ).animate().fadeIn(delay: Duration(milliseconds: 100 * i));
      },
    );
  }
}
