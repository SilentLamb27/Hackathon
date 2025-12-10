import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/car_provider.dart';
import '../utils/app_design_system.dart';
import 'dashboard_screen.dart';
import 'access_control_screen.dart';

/// Lock Screen - Authentication with Owner/Guest Management
class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  bool _isScanning = false;
  String? _scanMessage;
  bool _showOwnerOptions = false;
  bool _showGuestQrScanner = false;

  @override
  Widget build(BuildContext context) {
    final car = Provider.of<CarProvider>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Check if owner is already registered
    final hasOwner = car.registeredKads.any((kad) => kad.isOwner);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: Color(0xFF000000)),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    screenHeight -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.08,
                  vertical: 24,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.05),

                    // App Logo
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF64FFDA).withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        'SU7',
                        style: AppTextStyles.heading1.copyWith(
                          fontSize: screenWidth > 600 ? 72 : 56,
                          color: AppColors.teal,
                          letterSpacing: 8.0,
                        ),
                      ),
                    ).animate().fadeIn(duration: 800.ms).scale(),

                    const SizedBox(height: 8),

                    Text(
                      'CONTROL SYSTEM',
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 16,
                        color: const Color(0xFF6B7280),
                        letterSpacing: 4.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ).animate(delay: 300.ms).fadeIn(duration: 600.ms),

                    SizedBox(height: screenHeight * 0.08),

                    // Car Icon
                    Container(
                          padding: EdgeInsets.all(screenWidth > 600 ? 50 : 40),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF1a1a1a),
                            border: Border.all(
                              color: const Color(0xFF64FFDA).withOpacity(0.5),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF64FFDA).withOpacity(0.3),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.directions_car_filled,
                            size: screenWidth > 600 ? 100 : 80,
                            color: const Color(0xFF64FFDA),
                          ),
                        )
                        .animate(delay: 500.ms)
                        .scale(duration: 600.ms, curve: Curves.easeOut),

                    SizedBox(height: screenHeight * 0.06),

                    // Status Message
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: _isScanning
                            ? const Color(0xFF64FFDA).withOpacity(0.15)
                            : const Color(0xFF1a1a1a),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: _isScanning
                              ? const Color(0xFF64FFDA)
                              : const Color(0xFF2a2a2a),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        _scanMessage ?? 'VEHICLE LOCKED',
                        style: AppTextStyles.heading3.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _isScanning
                              ? const Color(0xFF64FFDA)
                              : Colors.white,
                          letterSpacing: 2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ).animate(delay: 700.ms).fadeIn(),

                    const SizedBox(height: 16),

                    Text(
                      hasOwner
                          ? 'Use MyKAD or QR code to unlock'
                          : 'Register your MyKAD to get started',
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 13,
                        color: const Color(0xFF6B7280),
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: screenHeight * 0.08),

                    // Authentication Buttons
                    if (!_isScanning) ...[
                      _buildAuthButton(
                        context,
                        label: hasOwner
                            ? 'UNLOCK AS OWNER'
                            : 'REGISTER AS OWNER',
                        icon: Icons.person,
                        color: const Color(0xFF64FFDA),
                        onTap: () => _handleOwnerAuth(car, hasOwner),
                      ),

                      const SizedBox(height: 16),

                      _buildAuthButton(
                        context,
                        label: 'GUEST ACCESS',
                        icon: Icons.qr_code_scanner,
                        color: const Color(0xFF3B82F6),
                        onTap: () => _handleGuestAuth(car, hasOwner),
                      ),

                      if (hasOwner) ...[
                        const SizedBox(height: 24),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AccessControlScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Manage Guest Access',
                            style: AppTextStyles.body2.copyWith(
                              color: const Color(0xFF6B7280),
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.all(40),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF1a1a1a),
                        ),
                        child: const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF64FFDA),
                          ),
                          strokeWidth: 3,
                        ),
                      ).animate().scale(duration: 400.ms),
                    ],

                    SizedBox(height: screenHeight * 0.05),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          color: const Color(0xFF1a1a1a),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTextStyles.heading3.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 900.ms).slideY(begin: 0.2);
  }

  // OWNER AUTHENTICATION
  Future<void> _handleOwnerAuth(CarProvider car, bool hasOwner) async {
    if (hasOwner) {
      // Owner already registered - just scan to unlock
      await _ownerQuickUnlock(car);
    } else {
      // First time - register owner
      await _registerNewOwner(car);
    }
  }

  Future<void> _ownerQuickUnlock(CarProvider car) async {
    setState(() {
      _isScanning = true;
      _scanMessage = 'Scan MyKAD to Unlock...';
    });

    await Future.delayed(const Duration(seconds: 2));

    // Check if scanned KAD is the owner
    final ownerKad = car.registeredKads.firstWhere((kad) => kad.isOwner);
    final isOwner = await car.scanMyKad(
      mockKadNumber: ownerKad.kadNumber,
      mockName: ownerKad.name,
    );

    if (isOwner) {
      car.grantOwnerAccess();
      setState(() {
        _scanMessage = 'Welcome Back, ${ownerKad.name}!';
      });

      await Future.delayed(const Duration(milliseconds: 800));

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      }
    } else {
      setState(() {
        _isScanning = false;
        _scanMessage = 'MyKAD Not Recognized';
      });
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _scanMessage = null);
    }
  }

  Future<void> _registerNewOwner(CarProvider car) async {
    setState(() {
      _isScanning = true;
      _scanMessage = 'Scan MyKAD to Register...';
    });

    await Future.delayed(const Duration(seconds: 2));

    // Simulate MyKAD scan
    const mockKadNumber = '950123-01-5678';
    const mockName = 'Ahmad bin Abdullah';

    setState(() {
      _scanMessage = 'Registering as Owner...';
    });

    await Future.delayed(const Duration(seconds: 1));

    await car.registerKad(
      kadNumber: mockKadNumber,
      name: mockName,
      isOwner: true,
    );

    car.grantOwnerAccess();

    setState(() {
      _scanMessage = 'Registration Complete!';
    });

    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) {
      _showWelcomeDialog(mockName);
    }
  }

  void _showWelcomeDialog(String name) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a1a),
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF64FFDA), size: 32),
            const SizedBox(width: 12),
            Text(
              'Welcome!',
              style: AppTextStyles.heading3.copyWith(
                color: const Color(0xFF64FFDA),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi $name,',
              style: AppTextStyles.body1.copyWith(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your MyKAD has been registered as the owner of this vehicle.',
              style: AppTextStyles.body2.copyWith(
                color: const Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF2a2a2a),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.check,
                        color: Color(0xFF10B981),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Full vehicle access',
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.check,
                        color: Color(0xFF10B981),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Manage guest access',
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.check,
                        color: Color(0xFF10B981),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'RFID toll & parking',
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF64FFDA),
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const DashboardScreen()),
              );
            },
            child: Text(
              'GET STARTED',
              style: AppTextStyles.heading3.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // GUEST AUTHENTICATION
  Future<void> _handleGuestAuth(CarProvider car, bool hasOwner) async {
    if (!hasOwner) {
      _showToast('Please register vehicle owner first');
      return;
    }

    setState(() {
      _isScanning = true;
      _scanMessage = 'Scan Guest QR Code...';
    });

    await Future.delayed(const Duration(seconds: 2));

    // Simulate QR scan - check if guest has history
    const mockGuestName = 'Siti binti Hassan';
    final existingGuest = car.guestAccessHistory
        .where((g) => g.guestName == mockGuestName)
        .toList();

    if (existingGuest.isNotEmpty) {
      // Guest has history - verify MyKAD
      await _verifyReturningGuest(car, mockGuestName);
    } else {
      // New guest - verify MyKAD
      await _verifyNewGuest(car, mockGuestName);
    }
  }

  Future<void> _verifyReturningGuest(CarProvider car, String name) async {
    setState(() {
      _scanMessage = 'Returning Guest - Verify MyKAD...';
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _scanMessage = 'MyKAD Verified!';
    });

    await Future.delayed(const Duration(seconds: 1));

    // Create new access with default 7 days
    await car.createGuestAccess(guestName: name, durationDays: 7);

    car.grantGuestAccess(7);

    setState(() {
      _scanMessage = 'Welcome Back!';
    });

    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    }
  }

  Future<void> _verifyNewGuest(CarProvider car, String name) async {
    setState(() {
      _scanMessage = 'New Guest - Verify MyKAD...';
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _scanMessage = 'MyKAD Verified!';
    });

    await Future.delayed(const Duration(seconds: 1));

    // Create access with duration from QR (default 7 days)
    await car.createGuestAccess(guestName: name, durationDays: 7);

    car.grantGuestAccess(7);

    setState(() {
      _scanMessage = 'Guest Access Granted!';
    });

    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    }
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
