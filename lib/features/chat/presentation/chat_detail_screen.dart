import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/glass_widgets.dart';

class ChatDetailScreen extends StatefulWidget {
  final String conversationId;
  const ChatDetailScreen({super.key, required this.conversationId});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

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
      body: GlassBackground.standard(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _ChatHeader(
                name: 'Sofia',
                status: 'Online',
                onBack: () => context.pop(),
                onVideoCall: () => context.push('/video-call/${widget.conversationId}'),
              ),

              // Deposit banner
              _DepositBanner(),

              // Messages
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  itemCount: _messages.length,
                  itemBuilder: (_, i) {
                    final msg = _messages[i];
                    final showAvatar = !msg.isMine &&
                        (i == 0 || _messages[i - 1].isMine);
                    return _MessageBubble(
                      message: msg,
                      showAvatar: showAvatar,
                    ).animate().fadeIn(
                        delay: Duration(milliseconds: 50 * i),
                        duration: 300.ms);
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
                        _messageController.text, true, '10:40'));
                    _messageController.clear();
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

  const _ChatHeader({
    required this.name,
    required this.status,
    required this.onBack,
    required this.onVideoCall,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            border: Border(
              bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white.withValues(alpha: 0.8), size: 20),
                onPressed: onBack,
              ),
              GlassAvatar(size: 36, availabilityDot: AvailabilityDot.available),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTextStyles.bodyLarge
                        .copyWith(fontWeight: FontWeight.w600, color: Colors.white)),
                    Text(status, style: AppTextStyles.caption
                        .copyWith(color: AppColors.success)),
                  ],
                ),
              ),
              GlassContainer(
                borderRadius: 12,
                padding: const EdgeInsets.all(8),
                opacity: 0.08,
                onTap: onVideoCall,
                child: const Icon(Icons.videocam_rounded,
                    color: AppColors.accent, size: 20),
              ),
              const SizedBox(width: 8),
              GlassContainer(
                borderRadius: 12,
                padding: const EdgeInsets.all(8),
                opacity: 0.08,
                child: Icon(Icons.info_outline_rounded,
                    color: Colors.white.withValues(alpha: 0.5), size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DepositBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        tintColor: AppColors.accent,
        child: Row(
          children: [
            Icon(Icons.shield_outlined,
                size: 18, color: AppColors.accent.withValues(alpha: 0.8)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Security deposit required to confirm a trip together.',
                style: AppTextStyles.caption
                    .copyWith(color: Colors.white.withValues(alpha: 0.6)),
              ),
            ),
            GlassChip(
              label: 'Learn more',
              selectedColor: AppColors.accent,
              isSelected: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final _DemoMessage message;
  final bool showAvatar;

  const _MessageBubble({required this.message, required this.showAvatar});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment:
            message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isMine)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: showAvatar
                  ? const GlassAvatar(size: 28)
                  : const SizedBox(width: 28),
            ),
          Flexible(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(message.isMine ? 18 : 4),
                bottomRight: Radius.circular(message.isMine ? 4 : 18),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(message.isMine ? 18 : 4),
                      bottomRight: Radius.circular(message.isMine ? 4 : 18),
                    ),
                    gradient: message.isMine
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.accent.withValues(alpha: 0.4),
                              AppColors.accent.withValues(alpha: 0.25),
                            ],
                          )
                        : LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withValues(alpha: 0.12),
                              Colors.white.withValues(alpha: 0.06),
                            ],
                          ),
                    border: Border.all(
                      color: message.isMine
                          ? AppColors.accent.withValues(alpha: 0.3)
                          : Colors.white.withValues(alpha: 0.1),
                      width: 0.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        message.text,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message.time,
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white.withValues(alpha: 0.35),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
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
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.fromLTRB(
              12, 8, 12, MediaQuery.of(context).padding.bottom + 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            border: Border(
              top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
            ),
          ),
          child: Row(
            children: [
              GlassContainer(
                borderRadius: 20,
                padding: const EdgeInsets.all(8),
                opacity: 0.08,
                child: Icon(Icons.add_rounded,
                    color: Colors.white.withValues(alpha: 0.5), size: 22),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: TextField(
                      controller: controller,
                      style: AppTextStyles.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.3)),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.07),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                              color: Colors.white.withValues(alpha: 0.1)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                              color: Colors.white.withValues(alpha: 0.1)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                              color: AppColors.accent.withValues(alpha: 0.4)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GlassContainer(
                borderRadius: 20,
                padding: const EdgeInsets.all(10),
                opacity: 0.15,
                tintColor: AppColors.accent,
                onTap: onSend,
                child: const Icon(Icons.send_rounded,
                    color: AppColors.accent, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
