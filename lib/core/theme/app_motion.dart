import 'package:flutter/material.dart';

class AppMotion {
  // Durations
  static const Duration durationFast = Duration(milliseconds: 180);
  static const Duration durationNormal = Duration(milliseconds: 280);
  static const Duration durationSlow = Duration(milliseconds: 400);

  // iOS-style spring curves
  static const Curve springCurve = Curves.easeOutCubic;
  static const Curve bounceOut = Curves.easeOutBack;
  static const Curve standardCurve = Curves.easeInOut;

  // Stagger intervals for lists (Section 6.2: 40ms stagger)
  static const Duration staggerInterval = Duration(milliseconds: 40);

  // Helper to adjust duration based on system "Reduce Motion" setting
  static Duration responsiveDuration(BuildContext context, Duration original) {
    if (MediaQuery.of(context).disableAnimations) {
      return Duration.zero;
    }
    return original;
  }
}
