import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tesla-Style Design System
/// Centralized colors, typography, spacing, and reusable components

// ==================== COLORS ====================

class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF000000); // Pure black
  static const Color cardBackground = Color(0xFF1a1a1a); // Dark gray
  static const Color cardBackgroundLight = Color(0xFF222222); // Lighter dark
  static const Color divider = Color(0xFF2a2a2a);
  static const Color border = Color(0xFF333333);

  // Primary colors
  static const Color primary = Color(0xFF4A90E2); // Blue
  static const Color primaryDark = Color(0xFF2E5C8A);
  static const Color accent = Color(0xFF64FFDA); // Teal accent

  // Status colors
  static const Color success = Color(0xFF10B981); // Green
  static const Color successLight = Color(0xFF34D399);
  static const Color warning = Color(0xFFF59E0B); // Orange
  static const Color danger = Color(0xFFEF4444); // Red
  static const Color info = Color(0xFF3B82F6); // Blue

  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF); // White
  static const Color textSecondary = Color(0xFF9CA3AF); // Gray
  static const Color textTertiary = Color(0xFF6B7280); // Darker gray
  static const Color textDisabled = Color(0xFF4B5563);

  // Accent colors
  static const Color teal = Color(0xFF64FFDA);
  static const Color tealDark = Color(0xFF14B8A6);
  static const Color purple = Color(0xBB86FC);
  static const Color yellow = Color(0xFFFBBF24);

  // Overlay colors
  static Color overlay = Colors.white.withOpacity(0.05);
  static Color overlayLight = Colors.white.withOpacity(0.1);
}

// ==================== TYPOGRAPHY ====================

class AppTextStyles {
  // Headings - Orbitron
  static TextStyle heading1 = GoogleFonts.orbitron(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 1.5,
  );

  static TextStyle heading2 = GoogleFonts.orbitron(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 1.2,
  );

  static TextStyle heading3 = GoogleFonts.orbitron(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body text - Outfit
  static TextStyle body1 = GoogleFonts.outfit(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static TextStyle body2 = GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static TextStyle caption = GoogleFonts.outfit(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // Special - Roboto Mono for numbers
  static TextStyle numbers = GoogleFonts.robotoMono(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
}

// ==================== SPACING ====================

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

// ==================== REUSABLE WIDGETS ====================

/// Tesla-style card container
class TeslaCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? borderColor;

  const TeslaCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color ?? AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor ?? AppColors.divider, width: 1),
      ),
      child: child,
    );
  }
}

/// Tesla-style button
class TeslaButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isOutlined;
  final IconData? icon;

  const TeslaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.isOutlined = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon != null ? Icon(icon, size: 20) : const SizedBox.shrink(),
        label: Text(
          label,
          style: AppTextStyles.body1.copyWith(color: textColor),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor ?? AppColors.textPrimary,
          side: BorderSide(color: AppColors.divider),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon, size: 20) : const SizedBox.shrink(),
      label: Text(
        label,
        style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primary,
        foregroundColor: textColor ?? AppColors.textPrimary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

/// Tesla-style list tile for menu items
class TeslaListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;

  const TeslaListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppColors.textPrimary, size: 24),
      title: Text(title, style: AppTextStyles.body1),
      subtitle: Text(subtitle, style: AppTextStyles.caption),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
    );
  }
}

/// Tesla-style stat card
class TeslaStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? iconColor;

  const TeslaStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return TeslaCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Icon(icon, color: iconColor ?? AppColors.primary, size: 24),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(label, style: AppTextStyles.caption)),
          Text(value, style: AppTextStyles.numbers),
        ],
      ),
    );
  }
}

/// Tesla-style circular progress
class TeslaCircularProgress extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final String centerText;
  final double size;
  final Color? progressColor;

  const TeslaCircularProgress({
    super.key,
    required this.value,
    required this.centerText,
    this.size = 200,
    this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: value,
              strokeWidth: 16,
              backgroundColor: AppColors.cardBackground,
              valueColor: AlwaysStoppedAnimation<Color>(
                progressColor ?? AppColors.primary,
              ),
            ),
          ),
          Text(
            centerText,
            style: AppTextStyles.heading1.copyWith(fontSize: size * 0.25),
          ),
        ],
      ),
    );
  }
}

/// Tesla-style slider
class TeslaSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final Color? activeColor;
  final int? divisions;

  const TeslaSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.activeColor,
    this.divisions,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        activeTrackColor: activeColor ?? AppColors.primary,
        inactiveTrackColor: AppColors.cardBackground,
        thumbColor: activeColor ?? AppColors.primary,
        trackHeight: 6,
      ),
      child: Slider(
        value: value,
        min: min,
        max: max,
        divisions: divisions,
        onChanged: onChanged,
      ),
    );
  }
}

/// Tesla-style section header
class TeslaSectionHeader extends StatelessWidget {
  final String title;
  final Color? color;

  const TeslaSectionHeader({super.key, required this.title, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.caption.copyWith(
          color: color ?? AppColors.teal,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
