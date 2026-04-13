import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/tw_avatar.dart';

class VideoCallScreen extends StatefulWidget {
  final String recipientId;
  const VideoCallScreen({super.key, required this.recipientId});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool _isConnecting = true;
  bool _isConnected = false;
  bool _isMuted = false;
  bool _isCameraOff = false;
  bool _isFrontCamera = true;
  int _remainingSeconds = AppConstants.maxCallDurationMinutes * 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Simulate connection
    Future.delayed(2000.ms, () {
      if (mounted) {
        setState(() {
          _isConnecting = false;
          _isConnected = true;
        });
        _startTimer();
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        _endCall();
        return;
      }
      setState(() => _remainingSeconds--);
    });
  }

  void _endCall() {
    _timer?.cancel();
    context.pop();
  }

  String get _timerText {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  bool get _isTimeLow => _remainingSeconds <= 60;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Remote video (placeholder)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primaryDark,
                  AppColors.primary,
                  AppColors.primaryDark,
                ],
              ),
            ),
            child: _isConnecting
                ? _ConnectingView()
                : Center(
                    child: Icon(
                      Icons.person_rounded,
                      size: 120,
                      color: AppColors.mediumGrey.withValues(alpha: 0.2),
                    ),
                  ),
          ),

          // Local video (small preview)
          if (_isConnected && !_isCameraOff)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 16,
              child: Container(
                width: 100,
                height: 140,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.accent, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Center(
                    child: Icon(
                      Icons.person_rounded,
                      size: 40,
                      color: AppColors.mediumGrey.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 500.ms).scale(begin: const Offset(0.8, 0.8)),
            ),

          // Timer bar
          if (_isConnected)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _isTimeLow
                      ? AppColors.error.withValues(alpha: 0.9)
                      : AppColors.primaryDark.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isTimeLow
                        ? AppColors.error
                        : AppColors.primaryLight,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isTimeLow
                          ? Icons.timer_off_rounded
                          : Icons.timer_rounded,
                      color: AppColors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _timerText,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        fontFeatures: [const FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 300.ms),
            ),

          // Caller name
          if (_isConnected)
            Positioned(
              left: 0,
              right: 0,
              bottom: 160,
              child: Column(
                children: [
                  Text('Sofia', style: AppTextStyles.heading2),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.available.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('Connected',
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.available)),
                  ),
                ],
              ).animate().fadeIn(delay: 400.ms),
            ),

          // Time limit info
          if (_isConnected)
            Positioned(
              left: 20,
              right: 20,
              bottom: 130,
              child: Text(
                'Video calls are limited to 15 minutes.\nExchange contact details for longer conversations.',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.mediumGrey,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 600.ms),
            ),

          // Controls
          Positioned(
            left: 0,
            right: 0,
            bottom: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _CallControl(
                  icon: _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                  label: _isMuted ? 'Unmute' : 'Mute',
                  isActive: _isMuted,
                  onTap: () => setState(() => _isMuted = !_isMuted),
                ),
                _CallControl(
                  icon: _isCameraOff
                      ? Icons.videocam_off_rounded
                      : Icons.videocam_rounded,
                  label: _isCameraOff ? 'Camera On' : 'Camera Off',
                  isActive: _isCameraOff,
                  onTap: () => setState(() => _isCameraOff = !_isCameraOff),
                ),
                _CallControl(
                  icon: Icons.cameraswitch_rounded,
                  label: 'Flip',
                  onTap: () => setState(() => _isFrontCamera = !_isFrontCamera),
                ),
                _CallControl(
                  icon: Icons.call_end_rounded,
                  label: 'End',
                  isDestructive: true,
                  onTap: _endCall,
                ),
              ],
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),
          ),
        ],
      ),
    );
  }
}

class _ConnectingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const TwAvatar(size: 100, showBorder: true)
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                begin: const Offset(0.95, 0.95),
                end: const Offset(1.05, 1.05),
                duration: 1000.ms,
              ),
          const SizedBox(height: 24),
          Text('Sofia', style: AppTextStyles.heading2),
          const SizedBox(height: 8),
          Text('Connecting...',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.mediumGrey))
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .fadeIn(duration: 800.ms),
        ],
      ),
    );
  }
}

class _CallControl extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isDestructive;
  final VoidCallback onTap;

  const _CallControl({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.isDestructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isDestructive
                  ? AppColors.error
                  : isActive
                      ? AppColors.white.withValues(alpha: 0.2)
                      : AppColors.primaryLight.withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isDestructive ? AppColors.white : AppColors.white,
              size: 26,
            ),
          ),
          const SizedBox(height: 6),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
