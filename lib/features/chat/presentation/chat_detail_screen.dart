import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/tw_avatar.dart';

class ChatDetailScreen extends StatefulWidget {
  final String conversationId;
  const ChatDetailScreen({super.key, required this.conversationId});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  // Demo messages
  final _messages = <_DemoMessage>[
    _DemoMessage('Hi! I saw you\'re heading to Bali next month?', false, '10:30'),
    _DemoMessage('Yes! I\'m planning a 10-day trip. Have you been?', true, '10:32'),
    _DemoMessage('I have! It\'s one of my favorite places. The temples in Ubud are incredible.', false, '10:33'),
    _DemoMessage('That sounds amazing. I\'d love to hear more about it.', true, '10:35'),
    _DemoMessage('Would you be interested in a video call? I can show you some of my photos from there.', false, '10:36'),
    _DemoMessage('That sounds like a great plan!', true, '10:38'),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _ChatHeader(
                name: 'Sofia',
                status: 'Online',
                onBack: () => context.pop(),
                onVideoCall: () => context.push('/video-call/${widget.conversationId}'),
                onInfo: () {},
              ),

              // Deposit banner
              _DepositBanner(),

              // Messages
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: _messages.length,
                  itemBuilder: (_, i) {
                    final msg = _messages[i];
                    final showAvatar = !msg.isMine &&
                        (i == 0 || _messages[i - 1].isMine);
                    return _MessageBubble(
                      text: msg.text,
                      time: msg.time,
                      isMine: msg.isMine,
                      showAvatar: showAvatar,
                    ).animate().fadeIn(
                          delay: Duration(milliseconds: 50 * i),
                          duration: 300.ms,
                        );
                  },
                ),
              ),

              // Input
              _MessageInput(
                controller: _messageController,
                onSend: () {
                  if (_messageController.text.trim().isEmpty) return;
                  setState(() {
                    _messages.add(_DemoMessage(
                      _messageController.text.trim(),
                      true,
                      '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                    ));
                    _messageController.clear();
                  });
                  Future.delayed(100.ms, () {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: 300.ms,
                      curve: Curves.easeOut,
                    );
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DemoMessage {
  final String text;
  final bool isMine;
  final String time;
  _DemoMessage(this.text, this.isMine, this.time);
}

class _ChatHeader extends StatelessWidget {
  final String name;
  final String status;
  final VoidCallback onBack;
  final VoidCallback onVideoCall;
  final VoidCallback onInfo;

  const _ChatHeader({
    required this.name,
    required this.status,
    required this.onBack,
    required this.onVideoCall,
    required this.onInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.primaryLight, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: onBack,
          ),
          TwAvatar(
            size: 40,
            availabilityDot: AvailabilityDot.available,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: AppTextStyles.bodyLarge
                        .copyWith(fontWeight: FontWeight.w600)),
                Text(status,
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.available)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.videocam_rounded, color: AppColors.accent),
            onPressed: onVideoCall,
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.mediumGrey),
            onPressed: onInfo,
          ),
        ],
      ),
    );
  }
}

class _DepositBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.accent, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Security deposit required to confirm a trip together.',
              style: AppTextStyles.caption.copyWith(color: AppColors.accentLight),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text('Learn more',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w700,
                )),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String text;
  final String time;
  final bool isMine;
  final bool showAvatar;

  const _MessageBubble({
    required this.text,
    required this.time,
    required this.isMine,
    this.showAvatar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMine)
            showAvatar
                ? const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: TwAvatar(size: 28),
                  )
                : const SizedBox(width: 36),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isMine ? AppColors.accent : AppColors.primaryLight,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMine ? 16 : 4),
                  bottomRight: Radius.circular(isMine ? 4 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    text,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isMine ? AppColors.primary : AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    time,
                    style: AppTextStyles.caption.copyWith(
                      color: isMine
                          ? AppColors.primary.withValues(alpha: 0.6)
                          : AppColors.mediumGrey,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _MessageInput({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: AppColors.primaryDark,
        border: Border(
          top: BorderSide(color: AppColors.primaryLight, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline,
                color: AppColors.mediumGrey),
            onPressed: () {},
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: controller,
                style: AppTextStyles.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle:
                      AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGrey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onSubmitted: (_) => onSend(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onSend,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send_rounded,
                  color: AppColors.primary, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
