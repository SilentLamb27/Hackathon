import 'package:flutter/material.dart';

class PredictiveMaintenanceModel {
  final double engineTemp;
  final double batteryHealth;
  final double tirePressure;
  final double mileage;
  final DateTime lastServiceDate;

  PredictiveMaintenanceModel({
    required this.engineTemp,
    required this.batteryHealth,
    required this.tirePressure,
    required this.mileage,
    required this.lastServiceDate,
  });

  // Simple logic for demo: returns a warning if any value is out of range
  String getMaintenancePrediction() {
    if (engineTemp > 110) {
      return 'Warning: Engine temperature is too high!';
    }
    if (batteryHealth < 60) {
      return 'Warning: Battery health is low!';
    }
    if (tirePressure < 28 || tirePressure > 36) {
      return 'Warning: Tire pressure abnormal!';
    }
    if (DateTime.now().difference(lastServiceDate).inDays > 180) {
      return 'Warning: It\'s time for a service!';
    }
    if (mileage > 15000) {
      return 'Warning: High mileage, consider maintenance!';
    }
    return 'All systems normal.';
  }
}
