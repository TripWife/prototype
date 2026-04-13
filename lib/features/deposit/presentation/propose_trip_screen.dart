import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/tw_button.dart';

class ProposeTripScreen extends StatefulWidget {
  final String recipientId;
  const ProposeTripScreen({super.key, required this.recipientId});

  @override
  State<ProposeTripScreen> createState() => _ProposeTripScreenState();
}

class _ProposeTripScreenState extends State<ProposeTripScreen> {
  final _destinationCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  DateTimeRange? _dateRange;
  bool _isLoading = false;

  @override
  void dispose() {
    _destinationCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectDates() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.accent,
              surface: AppColors.primary,
              onSurface: AppColors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _dateRange = picked);
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
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
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Companion card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.person,
                                  color: AppColors.mediumGrey),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Sofia, 27',
                                    style: AppTextStyles.bodyLarge
                                        .copyWith(fontWeight: FontWeight.w600)),
                                Text('Barcelona, Spain',
                                    style: AppTextStyles.bodySmall),
                              ],
                            ),
                            const Spacer(),
                            const Icon(Icons.verified,
                                color: AppColors.accent, size: 20),
                          ],
                        ),
                      ).animate().fadeIn(),

                      const SizedBox(height: 24),

                      // Destination
                      Text('DESTINATION', style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _destinationCtrl,
                        style: AppTextStyles.bodyMedium,
                        decoration: InputDecoration(
                          hintText: 'Where would you like to go?',
                          prefixIcon: const Icon(Icons.flight_takeoff_rounded,
                              color: AppColors.mediumGrey, size: 20),
                          hintStyle: AppTextStyles.bodyMedium
                              .copyWith(color: AppColors.mediumGrey),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Dates
                      Text('TRAVEL DATES', style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _selectDates,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_month_rounded,
                                  color: AppColors.mediumGrey, size: 20),
                              const SizedBox(width: 12),
                              Text(
                                _dateRange != null
                                    ? '${_dateRange!.start.day}/${_dateRange!.start.month} - ${_dateRange!.end.day}/${_dateRange!.end.month}/${_dateRange!.end.year}'
                                    : 'Select travel dates',
                                style: _dateRange != null
                                    ? AppTextStyles.bodyMedium
                                    : AppTextStyles.bodyMedium
                                        .copyWith(color: AppColors.mediumGrey),
                              ),
                              const Spacer(),
                              if (_dateRange != null)
                                Text(
                                  '${_dateRange!.duration.inDays} days',
                                  style: AppTextStyles.bodySmall
                                      .copyWith(color: AppColors.accent),
                                ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Notes
                      Text('MESSAGE (OPTIONAL)', style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _notesCtrl,
                        style: AppTextStyles.bodyMedium,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText:
                              'Share your ideas for the trip, activities you\'d like to do...',
                          hintStyle: AppTextStyles.bodyMedium
                              .copyWith(color: AppColors.mediumGrey),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Deposit info
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.accent.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.shield_rounded,
                                    color: AppColors.accent, size: 22),
                                const SizedBox(width: 10),
                                Text('Security Deposit',
                                    style: AppTextStyles.labelLarge),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'To confirm this trip, you must place a \$${AppConstants.securityDeposit.toInt()} security deposit. '
                              'This protects your companion\'s return journey in case of any issues.',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.lightGrey,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  _InfoRow('Deposit amount',
                                      '\$${AppConstants.securityDeposit.toInt()}'),
                                  const SizedBox(height: 8),
                                  _InfoRow('Refundable', 'No'),
                                  const SizedBox(height: 8),
                                  _InfoRow(
                                      'When charged', 'After she confirms'),
                                  const SizedBox(height: 8),
                                  _InfoRow('Covers',
                                      'Her return & emergencies'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 200.ms),

                      const SizedBox(height: 16),

                      // Policy reminder
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info_outline,
                                color: AppColors.mediumGrey, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'As per TripWife policy, you are responsible for all travel costs '
                                '(flights, accommodation, activities). The deposit is separate '
                                'and serves as insurance for your companion.',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.mediumGrey,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Submit
                      TwButton(
                        label: 'Send Trip Proposal',
                        icon: Icons.send_rounded,
                        width: double.infinity,
                        isLoading: _isLoading,
                        onPressed: _destinationCtrl.text.isNotEmpty &&
                                _dateRange != null
                            ? () {
                                setState(() => _isLoading = true);
                                Future.delayed(1500.ms, () {
                                  if (mounted) {
                                    setState(() => _isLoading = false);
                                    _showSuccessDialog();
                                  }
                                });
                              }
                            : null,
                      ),

                      const SizedBox(height: 20),
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.check, color: AppColors.success, size: 32),
              ),
              const SizedBox(height: 16),
              Text('Proposal Sent!', style: AppTextStyles.heading2),
              const SizedBox(height: 8),
              Text(
                'Sofia will review your trip proposal. You\'ll be notified when she responds.',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.lightGrey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TwButton(
                label: 'Back to Discovery',
                width: double.infinity,
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/home');
                },
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
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodySmall),
        Text(value,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.w600,
            )),
      ],
    );
  }
}
