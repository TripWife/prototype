import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/glass_widgets.dart';

class VideoCallScreen extends StatefulWidget {
  final String recipientId;
  const VideoCallScreen({super.key, required this.recipientId});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool _isConnected = false;
  bool _isMuted = false;
  bool _isCameraOn = true;
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = AppConstants.maxCallDurationMinutes * 60;
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isConnected = true);
        _startTimer();
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        if (mounted) context.pop();
        return;
      }
      setState(() => _remainingSeconds--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _timeString {
    final m = _remainingSeconds ~/ 60;
    final s = _remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isLow = _remainingSeconds < 60;

    return Scaffold(
      body: GlassBackground(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A0B20), Color(0xFF121338), Color(0xFF0A0B20)],
        ),
        orbs: const [
          GlassOrb(color: Color(0x15D4A853), radius: 150, position: Alignment(-0.5, -0.4)),
          GlassOrb(color: Color(0x105C6BC0), radius: 180, position: Alignment(0.6, 0.3)),
        ],
        child: SafeArea(
          child: Stack(
            children: [
              // Remote video (full screen placeholder)
              Center(
                child: _isConnected
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GlassAvatar(size: 100, showGlassRing: true),
                          const SizedBox(height: 20),
                          Text('Sofia', style: AppTextStyles.heading2),
                          const SizedBox(height: 8),
                          GlassBadge(
                            text: 'Connected',
                            color: AppColors.success,
                            icon: Icons.circle,
                          ),
                        ],
                      ).animate().fadeIn()
                    : _ConnectingView(),
              ),

              // Timer
              Positioned(
                top: 12,
                left: 16,
                child: GlassContainer(
                  borderRadius: 20,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  opacity: 0.12,
                  tintColor: isLow ? AppColors.error : Colors.white,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.timer_rounded,
                          size: 16,
                          color: isLow ? AppColors.error : AppColors.accent),
                      const SizedBox(width: 6),
                      Text(
                        _timeString,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          fontFeatures: const [FontFeature.tabularFigures()],
                          color: isLow ? AppColors.error : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Local video preview (PiP)
              Positioned(
                top: 12,
                right: 16,
                child: GlassContainer(
                  borderRadius: 16,
                  width: 100,
                  height: 140,
                  opacity: 0.1,
                  padding: EdgeInsets.zero,
                  child: Center(
                    child: Icon(
                      _isCameraOn ? Icons.person_rounded : Icons.videocam_off_rounded,
                      color: Colors.white.withValues(alpha: 0.2),
                      size: 32,
                    ),
                  ),
                ),
              ),

              // Bottom controls
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Text(
                      'Video calls are limited to ${AppConstants.maxCallDurationMinutes} minutes.\nExchange contact details for longer conversations.',
                      style: AppTextStyles.caption,
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 500.ms),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _CallControl(
                          icon: _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                          label: _isMuted ? 'Unmute' : 'Mute',
                          onTap: () => setState(() => _isMuted = !_isMuted),
                          isActive: _isMuted,
                        ),
                        const SizedBox(width: 16),
                        _CallControl(
                          icon: _isCameraOn ? Icons.videocam_rounded : Icons.videocam_off_rounded,
                          label: _isCameraOn ? 'Camera Off' : 'Camera On',
                          onTap: () => setState(() => _isCameraOn = !_isCameraOn),
                          isActive: !_isCameraOn,
                        ),
                        const SizedBox(width: 16),
                        _CallControl(
                          icon: Icons.flip_camera_ios_rounded,
                          label: 'Flip',
                          onTap: () {},
                        ),
                        const SizedBox(width: 16),
                        _CallControl(
                          icon: Icons.call_end_rounded,
                          label: 'End',
                          onTap: () => context.pop(),
                          isDestructive: true,
                        ),
                      ],
                    ).animate().slideY(begin: 0.5, duration: 400.ms, delay: 300.ms),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConnectingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accent.withValues(alpha: 0.2),
                    AppColors.accent.withValues(alpha: 0),
                  ],
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat())
                .scaleXY(begin: 0.8, end: 1.3, duration: 1500.ms)
                .fadeOut(begin: 0.5, duration: 1500.ms),
            GlassAvatar(size: 80, showGlassRing: true),
          ],
        ),
        const SizedBox(height: 24),
        Text('Connecting...', style: AppTextStyles.heading3),
        const SizedBox(height: 8),
        Text('Sofia', style: AppTextStyles.bodySmall),
      ],
    );
  }
}

class _CallControl extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;
  final bool isDestructive;

  const _CallControl({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GlassContainer(
            borderRadius: 30,
            padding: const EdgeInsets.all(16),
            opacity: isDestructive
                ? 0.25
                : isActive
                    ? 0.2
                    : 0.1,
            tintColor: isDestructive
                ? AppColors.error
                : isActive
                    ? Colors.white
                    : Colors.white,
            borderOpacity: isDestructive ? 0.3 : 0.15,
            child: Icon(icon,
                color: isDestructive
                    ? AppColors.error
                    : isActive
                        ? Colors.white
                        : AppColors.accent,
                size: 24),
          ),
          const SizedBox(height: 6),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
