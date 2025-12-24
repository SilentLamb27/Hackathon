import 'package:flutter/material.dart';

class AccidentDetectionService {
  // Simulate accident detection based on sudden deceleration or impact
  static bool detectAccident({
    required double acceleration,
    required double impactForce,
  }) {
    // Thresholds for demo purposes
    if (acceleration < -8.0 || impactForce > 15.0) {
      return true;
    }
    return false;
  }
}
