import 'package:flutter/material.dart';
import 'app_design_system.dart';

/// Error Handler Utility
/// Provides consistent error handling and user feedback throughout the app
class ErrorHandler {
  /// Show an error dialog to the user
  static void showError(
    BuildContext context,
    String message, {
    String? title,
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.danger, width: 1),
        ),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: AppColors.danger, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title ?? 'Error',
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.danger,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: AppTextStyles.body1,
        ),
        actions: [
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                onRetry();
              },
              child: Text(
                'Retry',
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              onDismiss?.call();
            },
            child: Text(
              'OK',
              style: AppTextStyles.body1.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show a success message
  static void showSuccess(
    BuildContext context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.body1.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Show a warning message
  static void showWarning(
    BuildContext context,
    String message, {
    String? title,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.warning, width: 1),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber, color: AppColors.warning, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title ?? 'Warning',
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.warning,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: AppTextStyles.body1,
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'OK',
              style: AppTextStyles.body1.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Handle async operations with error handling
  static Future<T?> handleAsync<T>(
    BuildContext context,
    Future<T> Function() operation, {
    String? errorMessage,
    String? errorTitle,
    VoidCallback? onRetry,
    bool showError = true,
  }) async {
    try {
      return await operation();
    } catch (e) {
      if (showError) {
        ErrorHandler.showError(
          context,
          errorMessage ?? 'An error occurred: ${e.toString()}',
          title: errorTitle,
          onRetry: onRetry,
        );
      }
      return null;
    }
  }

  /// Handle async operations with loading indicator
  static Future<T?> handleAsyncWithLoading<T>(
    BuildContext context,
    Future<T> Function() operation, {
    String? loadingMessage,
    String? errorMessage,
    String? errorTitle,
  }) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: 16),
            Text(
              loadingMessage ?? 'Please wait...',
              style: AppTextStyles.body1,
            ),
          ],
        ),
      ),
    );

    try {
      final result = await operation();
      Navigator.pop(context); // Close loading dialog
      return result;
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      ErrorHandler.showError(
        context,
        errorMessage ?? 'An error occurred: ${e.toString()}',
        title: errorTitle,
      );
      return null;
    }
  }
}

