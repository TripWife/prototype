import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary - Deep elegant navy/dark blue
  static const Color primary = Color(0xFF1A1B3A);
  static const Color primaryLight = Color(0xFF2D2E5E);
  static const Color primaryDark = Color(0xFF0F1029);

  // Accent - Warm gold for premium feel
  static const Color accent = Color(0xFFD4A853);
  static const Color accentLight = Color(0xFFE8C97A);
  static const Color accentDark = Color(0xFFB8892E);

  // Secondary - Soft rose for feminine touch
  static const Color rose = Color(0xFFE8A0B4);
  static const Color roseLight = Color(0xFFF2C4D2);
  static const Color roseDark = Color(0xFFD47A94);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF8F7F4);
  static const Color lightGrey = Color(0xFFE8E6E1);
  static const Color mediumGrey = Color(0xFFB0ADA6);
  static const Color darkGrey = Color(0xFF6B6966);
  static const Color charcoal = Color(0xFF2C2C2C);
  static const Color black = Color(0xFF121212);

  // Status
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF2196F3);

  // Deposit status
  static const Color depositPending = Color(0xFFFF9800);
  static const Color depositConfirmed = Color(0xFF4CAF50);
  static const Color depositBlocked = Color(0xFFD4A853);

  // Availability
  static const Color available = Color(0xFF4CAF50);
  static const Color busy = Color(0xFFFF9800);
  static const Color offline = Color(0xFFB0ADA6);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentDark, accent, accentLight],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1A1B3A),
      Color(0xFF2D2E5E),
      Color(0xFF1A1B3A),
    ],
  );
}
