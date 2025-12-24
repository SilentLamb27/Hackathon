import 'package:flutter/services.dart';

/// Haptic Feedback Service
/// Provides consistent haptic feedback throughout the app
class HapticFeedbackService {
  /// Light impact - for subtle interactions (toggles, switches)
  static void light() {
    HapticFeedback.lightImpact();
  }

  /// Medium impact - for standard button presses
  static void medium() {
    HapticFeedback.mediumImpact();
  }

  /// Heavy impact - for important actions (lock/unlock, emergency)
  static void heavy() {
    HapticFeedback.heavyImpact();
  }

  /// Selection click - for list items, menu selections
  static void selection() {
    HapticFeedback.selectionClick();
  }

  /// Vibrate - for notifications and alerts
  static void vibrate() {
    HapticFeedback.vibrate();
  }

  /// Success feedback - combination for successful actions
  static void success() {
    light();
    Future.delayed(const Duration(milliseconds: 50), () {
      light();
    });
  }

  /// Error feedback - combination for error states
  static void error() {
    heavy();
    Future.delayed(const Duration(milliseconds: 100), () {
      light();
    });
  }
}

