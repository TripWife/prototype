import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/glass_widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool _isLoading = false;
  final _selectedInterests = {'Beach', 'Culture', 'Food & Wine'};
  final _selectedDestinations = {'Bali', 'Santorini', 'Tokyo'};
  final _selectedLanguages = {'English', 'Spanish'};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlassBackground.standard(
        child: SafeArea(
          child: Column(
            children: [
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
                    Text('Edit Profile', style: AppTextStyles.heading3),
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
                      // Photos
                      Text('PHOTOS', style: AppTextStyles.label),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 110,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ...List.generate(3, (i) => _PhotoSlot(
                              isMain: i == 0,
                              onRemove: () {},
                            )),
                            _AddPhotoSlot(),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(
                            child: GlassTextField(
                              label: 'First Name',
                              hint: 'John',
                              controller: TextEditingController(text: 'John'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GlassTextField(
                              label: 'Last Name',
                              hint: 'Doe',
                              controller: TextEditingController(text: 'Doe'),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      GlassTextField(
                        label: 'Bio',
                        hint: 'Tell others about yourself...',
                        maxLines: 3,
                        controller: TextEditingController(
                          text: 'Entrepreneur and frequent traveler. Love discovering new places and cultures.',
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: GlassTextField(
                              label: 'City',
                              hint: 'Your city',
                              prefixIcon: Icons.location_on_outlined,
                              controller: TextEditingController(text: 'New York'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GlassTextField(
                              label: 'Occupation',
                              hint: 'Your job',
                              prefixIcon: Icons.work_outline_rounded,
                              controller: TextEditingController(text: 'CEO'),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // Interests
                      _ChipSelector(
                        label: 'INTERESTS',
                        options: const [
                          'Beach', 'Culture', 'Food & Wine', 'Photography',
                          'Hiking', 'Art', 'Nightlife', 'Adventure',
                          'Wellness', 'Shopping', 'History', 'Nature',
                          'Music', 'Business',
                        ],
                        selected: _selectedInterests,
                        onToggle: (v) => setState(() {
                          _selectedInterests.contains(v)
                              ? _selectedInterests.remove(v)
                              : _selectedInterests.add(v);
                        }),
                      ),

                      const SizedBox(height: 24),

                      _ChipSelector(
                        label: 'PREFERRED DESTINATIONS',
                        options: const [
                          'Bali', 'Maldives', 'Santorini', 'Tokyo',
                          'Paris', 'Dubai', 'New York', 'Barcelona',
                          'Amalfi Coast', 'Swiss Alps', 'Tulum', 'Mykonos',
                        ],
                        selected: _selectedDestinations,
                        onToggle: (v) => setState(() {
                          _selectedDestinations.contains(v)
                              ? _selectedDestinations.remove(v)
                              : _selectedDestinations.add(v);
                        }),
                      ),

                      const SizedBox(height: 24),

                      _ChipSelector(
                        label: 'LANGUAGES',
                        options: const [
                          'English', 'Spanish', 'French', 'German',
                          'Italian', 'Portuguese', 'Japanese', 'Chinese',
                          'Arabic', 'Russian',
                        ],
                        selected: _selectedLanguages,
                        onToggle: (v) => setState(() {
                          _selectedLanguages.contains(v)
                              ? _selectedLanguages.remove(v)
                              : _selectedLanguages.add(v);
                        }),
                      ),

                      const SizedBox(height: 32),

                      GlassButton(
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

class _PhotoSlot extends StatelessWidget {
  final bool isMain;
  final VoidCallback onRemove;
  const _PhotoSlot({required this.isMain, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          GlassContainer(
            borderRadius: 16,
            width: 85,
            height: 110,
            opacity: 0.08,
            padding: EdgeInsets.zero,
            child: Center(
              child: Icon(Icons.person_rounded,
                  size: 32, color: Colors.white.withValues(alpha: 0.2)),
            ),
          ),
          if (isMain)
            Positioned(
              bottom: 6,
              left: 6,
              child: GlassBadge(text: 'Main', color: AppColors.accent),
            ),
          Positioned(
            top: -6,
            right: -6,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close_rounded,
                    size: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddPhotoSlot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 16,
      width: 85,
      height: 110,
      opacity: 0.05,
      borderOpacity: 0.2,
      padding: EdgeInsets.zero,
      child: Center(
        child: Icon(Icons.add_rounded,
            size: 28, color: Colors.white.withValues(alpha: 0.3)),
      ),
    );
  }
}

class _ChipSelector extends StatelessWidget {
  final String label;
  final List<String> options;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  const _ChipSelector({
    required this.label,
    required this.options,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options
              .map((opt) => GlassChip(
                    label: opt,
                    isSelected: selected.contains(opt),
                    onTap: () => onToggle(opt),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
