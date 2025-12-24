import 'package:flutter/material.dart';

class EmergencyNotifier {
  static Future<void> notifyEmergencyContacts(BuildContext context, {required String location}) async {
    // For demo: show a dialog. In real app, send SMS/call/email, etc.
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Emergency Alert Sent'),
        content: Text('Emergency contacts have been notified with your location: $location'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
