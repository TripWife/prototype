import 'dart:ui';

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

// ─────────────────────────────────────────────────
// LIQUID GLASS BACKGROUND
// Rich gradient with floating luminous orbs
// ─────────────────────────────────────────────────

class GlassBackground extends StatelessWidget {
  final Widget child;
  final List<GlassOrb> orbs;
  final Gradient? gradient;

  const GlassBackground({
    super.key,
    required this.child,
    this.orbs = const [],
    this.gradient,
  });

  factory GlassBackground.standard({
    Key? key,
    required Widget child,
  }) {
    return GlassBackground(
      key: key,
      gradient: AppColors.glassBackgroundGradient,
      orbs: const [
        GlassOrb(
          color: Color(0x30D4A853),
          radius: 180,
          position: Alignment(-0.8, -0.6),
        ),
        GlassOrb(
          color: Color(0x205C6BC0),
          radius: 200,
          position: Alignment(0.9, -0.3),
        ),
        GlassOrb(
          color: Color(0x18E8A0B4),
          radius: 150,
          position: Alignment(-0.3, 0.7),
        ),
        GlassOrb(
          color: Color(0x15D4A853),
          radius: 120,
          position: Alignment(0.7, 0.8),
        ),
      ],
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient ?? AppColors.glassBackgroundGradient,
      ),
      child: Stack(
        children: [
          // Floating orbs
          ...orbs.map((orb) => Positioned.fill(
                child: Align(
                  alignment: orb.position,
                  child: Container(
                    width: orb.radius * 2,
                    height: orb.radius * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [orb.color, orb.color.withValues(alpha: 0)],
                        stops: const [0.0, 1.0],
                      ),
                    ),
                  ),
                ),
              )),
          // Content
          child,
        ],
      ),
    );
  }
}

class GlassOrb {
  final Color color;
  final double radius;
  final Alignment position;

  const GlassOrb({
    required this.color,
    required this.radius,
    required this.position,
  });
}

// ─────────────────────────────────────────────────
// GLASS CONTAINER
// Base frosted glass panel with blur + luminous border
// ─────────────────────────────────────────────────

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final Color? tintColor;
  final double opacity;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderOpacity;
  final bool showTopHighlight;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.blur = 24,
    this.tintColor,
    this.opacity = 0.08,
    this.padding,
    this.margin,
    this.borderOpacity = 0.15,
    this.showTopHighlight = true,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: (tintColor ?? Colors.white).withValues(alpha: opacity),
            border: Border.all(
              color: Colors.white.withValues(alpha: borderOpacity),
              width: 0.8,
            ),
            gradient: showTopHighlight
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: opacity + 0.06),
                      (tintColor ?? Colors.white).withValues(alpha: opacity),
                      (tintColor ?? Colors.white)
                          .withValues(alpha: opacity * 0.5),
                    ],
                    stops: const [0.0, 0.3, 1.0],
                  )
                : null,
          ),
          padding: padding,
          child: child,
        ),
      ),
    );

    if (margin != null) {
      final wrapped = Padding(padding: margin!, child: content);
      return onTap != null
          ? GestureDetector(onTap: onTap, child: wrapped)
          : wrapped;
    }

    return onTap != null
        ? GestureDetector(onTap: onTap, child: content)
        : content;
  }
}

// ─────────────────────────────────────────────────
// GLASS CARD
// Elevated glass panel for content cards
// ─────────────────────────────────────────────────

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? tintColor;
  final VoidCallback? onTap;
  final double blur;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 20,
    this.tintColor,
    this.onTap,
    this.blur = 24,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: borderRadius,
      blur: blur,
      tintColor: tintColor,
      padding: padding,
      margin: margin,
      onTap: onTap,
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────
// GLASS BUTTON
// Translucent button with glow effect
// ─────────────────────────────────────────────────

class GlassButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final bool isPrimary;
  final Color? tintColor;
  final double borderRadius;

  const GlassButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.isPrimary = true,
    this.tintColor,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    final color = tintColor ?? AppColors.accent;
    final isDisabled = onPressed == null || isLoading;

    return GestureDetector(
      onTap: isDisabled ? null : onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: width,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: isPrimary
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color.withValues(alpha: isDisabled ? 0.2 : 0.6),
                        color.withValues(alpha: isDisabled ? 0.1 : 0.35),
                      ],
                    )
                  : LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.12),
                        Colors.white.withValues(alpha: 0.05),
                      ],
                    ),
              border: Border.all(
                color: isPrimary
                    ? color.withValues(alpha: 0.4)
                    : Colors.white.withValues(alpha: 0.15),
                width: 0.8,
              ),
              boxShadow: isPrimary && !isDisabled
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.25),
                        blurRadius: 20,
                        spreadRadius: -4,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: width != null ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(
                        isPrimary ? Colors.white : color,
                      ),
                    ),
                  )
                else ...[
                  if (icon != null) ...[
                    Icon(icon, size: 20,
                        color: isPrimary ? Colors.white : color),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isPrimary
                          ? Colors.white
                          : color,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// GLASS NAV BAR
// Frosted bottom navigation
// ─────────────────────────────────────────────────

class GlassNavBar extends StatelessWidget {
  final List<GlassNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const GlassNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          padding: EdgeInsets.only(
            top: 8,
            bottom: MediaQuery.of(context).padding.bottom + 8,
            left: 8,
            right: 8,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: 0.1),
                Colors.white.withValues(alpha: 0.05),
              ],
            ),
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.12),
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isActive = index == currentIndex;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: isActive
                              ? AppColors.accent.withValues(alpha: 0.2)
                              : Colors.transparent,
                          border: isActive
                              ? Border.all(
                                  color:
                                      AppColors.accent.withValues(alpha: 0.3),
                                  width: 0.5)
                              : null,
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              isActive
                                  ? item.activeIcon ?? item.icon
                                  : item.icon,
                              color: isActive
                                  ? AppColors.accent
                                  : Colors.white.withValues(alpha: 0.4),
                              size: 24,
                            ),
                            if (item.badge != null && item.badge! > 0)
                              Positioned(
                                right: -8,
                                top: -4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: AppColors.error,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${item.badge}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight:
                              isActive ? FontWeight.w600 : FontWeight.w400,
                          color: isActive
                              ? AppColors.accent
                              : Colors.white.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class GlassNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final int? badge;

  const GlassNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    this.badge,
  });
}

// ─────────────────────────────────────────────────
// GLASS CHIP
// Translucent pill-shaped tag
// ─────────────────────────────────────────────────

class GlassChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final IconData? icon;
  final Color? selectedColor;

  const GlassChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.icon,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = selectedColor ?? AppColors.accent;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected
              ? color.withValues(alpha: 0.25)
              : Colors.white.withValues(alpha: 0.07),
          border: Border.all(
            color: isSelected
                ? color.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.12),
            width: 0.8,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14,
                  color: isSelected ? color : Colors.white70),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? color : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// GLASS TEXT FIELD
// Frosted input field
// ─────────────────────────────────────────────────

class GlassTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;

  const GlassTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffix,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.accent.withValues(alpha: 0.8),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              validator: validator,
              onChanged: onChanged,
              maxLines: maxLines,
              readOnly: readOnly,
              onTap: onTap,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                  fontSize: 14,
                ),
                prefixIcon: prefixIcon != null
                    ? Icon(prefixIcon,
                        color: Colors.white.withValues(alpha: 0.4), size: 20)
                    : null,
                suffixIcon: suffix,
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.07),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: 0.1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: 0.1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                      color: AppColors.accent.withValues(alpha: 0.5),
                      width: 1.5),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.error),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────
// GLASS AVATAR
// Avatar with glass ring and glow
// ─────────────────────────────────────────────────

class GlassAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final AvailabilityDot? availabilityDot;
  final bool showGlassRing;
  final VoidCallback? onTap;

  const GlassAvatar({
    super.key,
    this.imageUrl,
    this.size = 56,
    this.availabilityDot,
    this.showGlassRing = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: showGlassRing
                  ? Border.all(
                      color: AppColors.accent.withValues(alpha: 0.4),
                      width: 2,
                    )
                  : Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                      width: 1,
                    ),
              boxShadow: showGlassRing
                  ? [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.2),
                        blurRadius: 12,
                        spreadRadius: -2,
                      ),
                    ]
                  : null,
            ),
            child: ClipOval(
              child: Container(
                color: Colors.white.withValues(alpha: 0.08),
                child: Icon(
                  Icons.person_rounded,
                  color: Colors.white.withValues(alpha: 0.35),
                  size: size * 0.5,
                ),
              ),
            ),
          ),
          if (availabilityDot != null)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: size * 0.25,
                height: size * 0.25,
                decoration: BoxDecoration(
                  color: availabilityDot!.color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF0D0E2B),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: availabilityDot!.color.withValues(alpha: 0.4),
                      blurRadius: 6,
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

enum AvailabilityDot {
  available(AppColors.available),
  busy(AppColors.busy),
  offline(AppColors.offline);

  final Color color;
  const AvailabilityDot(this.color);
}

// ─────────────────────────────────────────────────
// GLASS TOGGLE
// Glass-styled toggle switch
// ─────────────────────────────────────────────────

class GlassToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const GlassToggle({super.key, required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 50,
        height: 28,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: value
              ? AppColors.accent.withValues(alpha: 0.35)
              : Colors.white.withValues(alpha: 0.1),
          border: Border.all(
            color: value
                ? AppColors.accent.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.15),
            width: 0.8,
          ),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: value ? AppColors.accent : Colors.white.withValues(alpha: 0.5),
              boxShadow: value
                  ? [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.4),
                        blurRadius: 8,
                      ),
                    ]
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// GLASS APP BAR
// Frosted top bar
// ─────────────────────────────────────────────────

class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showBack;

  const GlassAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.showBack = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          child: SizedBox(
            height: 56,
            child: Row(
              children: [
                if (leading != null)
                  leading!
                else if (showBack)
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white.withValues(alpha: 0.8), size: 20),
                    onPressed: () => Navigator.of(context).maybePop(),
                  )
                else
                  const SizedBox(width: 16),
                if (title != null)
                  Expanded(
                    child: Text(
                      title!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                if (actions != null) ...actions! else const SizedBox(width: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// GLASS BADGE
// Small luminous badge
// ─────────────────────────────────────────────────

class GlassBadge extends StatelessWidget {
  final String text;
  final Color? color;
  final IconData? icon;

  const GlassBadge({
    super.key,
    required this.text,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.accent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: c.withValues(alpha: 0.2),
        border: Border.all(color: c.withValues(alpha: 0.35), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: c),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: c,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// GLASS DIVIDER
// ─────────────────────────────────────────────────

class GlassDivider extends StatelessWidget {
  final double? indent;
  final double? endIndent;

  const GlassDivider({super.key, this.indent, this.endIndent});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0.5,
      indent: indent,
      endIndent: endIndent,
      color: Colors.white.withValues(alpha: 0.08),
    );
  }
}
