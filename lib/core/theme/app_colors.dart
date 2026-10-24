import 'package:flutter/material.dart';

class AppColors {
  // Brand Primary (Culinary Warm Saffron / Tangerine)
  static const Color primary = Color(0xFFFF5200); // Swiggy/Zomato vibrancy
  static const Color primaryDark = Color(0xFFE04800);
  static const Color primaryLight = Color(0xFFFFECE5);
  static const Color primaryContainer = Color(0xFFFFF2EB);

  // Secondary Accent (Royal Subscription Blue)
  static const Color subscriptionBlue = Color(0xFF2563EB);
  static const Color subscriptionBlueLight = Color(0xFFEFF6FF);

  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFECFDF5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);

  // FSSAI Food Categorization
  static const Color vegGreen = Color(0xFF16A34A);
  static const Color nonVegRed = Color(0xFFDC2626);
  static const Color eggYellow = Color(0xFFD97706);

  // Light Mode Surfaces & Text
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textTertiaryLight = Color(0xFF94A3B8);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color dividerLight = Color(0xFFF1F5F9);

  // Dark Mode Surfaces & Text (OLED optimized)
  static const Color backgroundDark = Color(0xFF090D16);
  static const Color surfaceDark = Color(0xFF131B2E);
  static const Color cardDark = Color(0xFF1E293B);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textTertiaryDark = Color(0xFF64748B);
  static const Color borderDark = Color(0xFF27354A);
  static const Color dividerDark = Color(0xFF1E293B);

  // Partner Specific Brand Accent (Emerald / Forest)
  static const Color partnerPrimary = Color(0xFF0D9488);
  static const Color partnerPrimaryLight = Color(0xFFCCFBF1);

  // Shadows
  static List<BoxShadow> softShadow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: isDark ? Colors.black.withOpacity(0.3) : const Color(0x0A0F172A),
        blurRadius: 16,
        offset: const Offset(0, 4),
        spreadRadius: 0,
      ),
    ];
  }

  static List<BoxShadow> elevatedShadow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: isDark ? Colors.black.withOpacity(0.4) : const Color(0x140F172A),
        blurRadius: 24,
        offset: const Offset(0, 8),
        spreadRadius: 0,
      ),
    ];
  }
}
