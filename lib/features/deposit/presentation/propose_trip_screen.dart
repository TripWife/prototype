import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/glass_widgets.dart';

class ProposeTripScreen extends StatefulWidget {
  final String recipientId;
  const ProposeTripScreen({super.key, required this.recipientId});

  @override
  State<ProposeTripScreen> createState() => _ProposeTripScreenState();
}

class _ProposeTripScreenState extends State<ProposeTripScreen> {
  final _destinationController = TextEditingController();
  final _messageController = TextEditingController();
  DateTimeRange? _dateRange;
  bool _isLoading = false;

  @override
  void dispose() {
    _destinationController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickDates() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.accent,
              surface: AppColors.primaryLight,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _dateRange = picked);
  }

  void _submit() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: AppColors.primaryLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Icon(Icons.check_circle_rounded,
              color: AppColors.success, size: 56),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Trip Proposed!', style: AppTextStyles.heading3),
              const SizedBox(height: 8),
              Text(
                'Sofia will be notified. You\'ll be asked to place the security deposit once she accepts.',
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/home');
              },
              child: const Text('Done'),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlassBackground.standard(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white.withValues(alpha: 0.8), size: 20),
                      onPressed: () => context.pop(),
                    ),
                    const Spacer(),
                    Text('Propose a Trip', style: AppTextStyles.heading3),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Companion card
                      GlassCard(
                        child: Row(
                          children: [
                            GlassAvatar(size: 48, showGlassRing: true),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Sofia, 27',
                                    style: AppTextStyles.bodyLarge
                                        .copyWith(fontWeight: FontWeight.w600, color: Colors.white)),
                                Text('Barcelona, Spain',
                                    style: AppTextStyles.bodySmall),
                              ],
                            ),
                            const Spacer(),
                            Icon(Icons.verified_rounded,
                                color: AppColors.accent, size: 22),
                          ],
                        ),
                      ).animate().fadeIn(),

                      const SizedBox(height: 24),

                      GlassTextField(
                        label: 'Destination',
                        hint: 'Where would you like to go?',
                        controller: _destinationController,
                        prefixIcon: Icons.flight_takeoff_rounded,
                      ).animate().fadeIn(delay: 100.ms),

                      const SizedBox(height: 20),

                      GlassTextField(
                        label: 'Travel Dates',
                        hint: 'Select travel dates',
                        prefixIcon: Icons.calendar_month_rounded,
                        readOnly: true,
                        onTap: _pickDates,
                        controller: TextEditingController(
                          text: _dateRange != null
                              ? '${_dateRange!.start.day}/${_dateRange!.start.month} - ${_dateRange!.end.day}/${_dateRange!.end.month}/${_dateRange!.end.year}'
                              : '',
                        ),
                      ).animate().fadeIn(delay: 200.ms),

                      const SizedBox(height: 20),

                      GlassTextField(
                        label: 'Message (Optional)',
                        hint: 'Share your ideas for the trip, activities you\'d like to do...',
                        controller: _messageController,
                        maxLines: 3,
                      ).animate().fadeIn(delay: 300.ms),

                      const SizedBox(height: 28),

                      // Deposit info
                      GlassCard(
                        tintColor: AppColors.accent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.shield_rounded,
                                    color: AppColors.accent, size: 22),
                                const SizedBox(width: 10),
                                Text('Security Deposit',
                                    style: AppTextStyles.heading3
                                        .copyWith(fontSize: 16)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'To confirm this trip, you must place a \$${AppConstants.securityDeposit.toInt()} security deposit. This protects your companion\'s return journey in case of any issues.',
                              style: AppTextStyles.bodySmall
                                  .copyWith(color: Colors.white.withValues(alpha: 0.6)),
                            ),
                            const SizedBox(height: 16),
                            GlassContainer(
                              borderRadius: 12,
                              padding: const EdgeInsets.all(12),
                              opacity: 0.08,
                              child: Column(
                                children: [
                                  _InfoRow('Deposit amount',
                                      '\$${AppConstants.securityDeposit.toInt()}',
                                      valueColor: AppColors.accent),
                                  const SizedBox(height: 8),
                                  _InfoRow('Refundable', 'No'),
                                  const SizedBox(height: 8),
                                  _InfoRow('When charged',
                                      'After she confirms',
                                      valueColor: AppColors.accent),
                                  const SizedBox(height: 8),
                                  _InfoRow('Covers',
                                      'Her return & emergencies',
                                      valueColor: AppColors.accent),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 400.ms),

                      const SizedBox(height: 16),

                      // Policy reminder
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline_rounded,
                              size: 16,
                              color: Colors.white.withValues(alpha: 0.3)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'As per TripWife policy, you are responsible for all travel arrangements and expenses during the trip.',
                              style: AppTextStyles.caption,
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 500.ms),

                      const SizedBox(height: 28),

                      GlassButton(
                        label: 'Propose Trip',
                        icon: Icons.flight_takeoff_rounded,
                        width: double.infinity,
                        isLoading: _isLoading,
                        onPressed: _submit,
                      ).animate().fadeIn(delay: 600.ms),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow(this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodySmall),
        Text(value,
            style: AppTextStyles.bodySmall.copyWith(
                color: valueColor ?? Colors.white.withValues(alpha: 0.7),
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}
