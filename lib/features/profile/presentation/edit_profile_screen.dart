import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/tw_button.dart';
import '../../../core/widgets/tw_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _firstNameCtrl = TextEditingController(text: 'John');
  final _lastNameCtrl = TextEditingController(text: 'Doe');
  final _bioCtrl = TextEditingController(
      text: 'Entrepreneur and frequent traveler. Love discovering new places and cultures.');
  final _cityCtrl = TextEditingController(text: 'New York');
  final _occupationCtrl = TextEditingController(text: 'CEO');
  bool _isLoading = false;

  final _selectedInterests = <String>{'Beach', 'Culture', 'Food & Wine', 'Business'};
  final _allInterests = [
    'Beach', 'Culture', 'Food & Wine', 'Photography', 'Hiking',
    'Art', 'Nightlife', 'Adventure', 'Wellness', 'Business',
    'Shopping', 'History', 'Nature', 'Music', 'Sports',
  ];

  final _selectedDestinations = <String>{'Bali', 'Maldives', 'Dubai'};
  final _allDestinations = [
    'Bali', 'Maldives', 'Dubai', 'Santorini', 'Tokyo',
    'Paris', 'New York', 'London', 'Cancun', 'Mykonos',
    'Amalfi Coast', 'Phuket', 'Seychelles', 'Marbella', 'Ibiza',
  ];

  final _selectedLanguages = <String>{'English', 'Spanish'};
  final _allLanguages = [
    'English', 'Spanish', 'French', 'Italian', 'Portuguese',
    'German', 'Arabic', 'Japanese', 'Chinese', 'Russian',
  ];

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _bioCtrl.dispose();
    _cityCtrl.dispose();
    _occupationCtrl.dispose();
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () => context.pop(),
                    ),
                    const Spacer(),
                    Text('Edit Profile', style: AppTextStyles.heading3),
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
                      // Photos section
                      Text('PHOTOS', style: AppTextStyles.label),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 120,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ...List.generate(
                              3,
                              (i) => Container(
                                width: 90,
                                height: 120,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Icon(Icons.person,
                                          color: AppColors.mediumGrey.withValues(alpha: 0.3),
                                          size: 36),
                                    ),
                                    if (i == 0)
                                      Positioned(
                                        bottom: 4,
                                        left: 0,
                                        right: 0,
                                        child: Center(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppColors.accent,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text('Main',
                                                style: AppTextStyles.caption
                                                    .copyWith(
                                                  color: AppColors.primary,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w700,
                                                )),
                                          ),
                                        ),
                                      ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                          color: AppColors.error,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.close,
                                            size: 12, color: AppColors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Add photo button
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: 90,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.accent.withValues(alpha: 0.3),
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_photo_alternate_rounded,
                                        color: AppColors.accent, size: 28),
                                    SizedBox(height: 4),
                                    Text('Add',
                                        style: TextStyle(
                                          color: AppColors.accent,
                                          fontSize: 11,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(
                            child: TwTextField(
                                label: 'FIRST NAME',
                                controller: _firstNameCtrl),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TwTextField(
                                label: 'LAST NAME',
                                controller: _lastNameCtrl),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      TwTextField(
                        label: 'BIO',
                        controller: _bioCtrl,
                        maxLines: 3,
                        hint: 'Tell people about yourself...',
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: TwTextField(
                              label: 'CITY',
                              controller: _cityCtrl,
                              prefixIcon: Icons.location_on_outlined,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TwTextField(
                              label: 'OCCUPATION',
                              controller: _occupationCtrl,
                              prefixIcon: Icons.work_outline,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      _ChipSelector(
                        label: 'INTERESTS',
                        items: _allInterests,
                        selected: _selectedInterests,
                        onToggle: (item) {
                          setState(() {
                            if (_selectedInterests.contains(item)) {
                              _selectedInterests.remove(item);
                            } else {
                              _selectedInterests.add(item);
                            }
                          });
                        },
                      ),

                      const SizedBox(height: 24),

                      _ChipSelector(
                        label: 'PREFERRED DESTINATIONS',
                        items: _allDestinations,
                        selected: _selectedDestinations,
                        onToggle: (item) {
                          setState(() {
                            if (_selectedDestinations.contains(item)) {
                              _selectedDestinations.remove(item);
                            } else {
                              _selectedDestinations.add(item);
                            }
                          });
                        },
                      ),

                      const SizedBox(height: 24),

                      _ChipSelector(
                        label: 'LANGUAGES',
                        items: _allLanguages,
                        selected: _selectedLanguages,
                        onToggle: (item) {
                          setState(() {
                            if (_selectedLanguages.contains(item)) {
                              _selectedLanguages.remove(item);
                            } else {
                              _selectedLanguages.add(item);
                            }
                          });
                        },
                      ),

                      const SizedBox(height: 32),

                      TwButton(
                        label: 'Save Changes',
                        width: double.infinity,
                        isLoading: _isLoading,
                        onPressed: () async {
                          setState(() => _isLoading = true);
                          await Future.delayed(const Duration(seconds: 1));
                          if (!context.mounted) return;
                          setState(() => _isLoading = false);
                          context.pop();
                        },
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
}

class _ChipSelector extends StatelessWidget {
  final String label;
  final List<String> items;
  final Set<String> selected;
  final void Function(String) onToggle;

  const _ChipSelector({
    required this.label,
    required this.items,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            final isSelected = selected.contains(item);
            return GestureDetector(
              onTap: () => onToggle(item),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.accent.withValues(alpha: 0.15)
                      : AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color:
                        isSelected ? AppColors.accent : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  item,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isSelected ? AppColors.accent : AppColors.lightGrey,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
