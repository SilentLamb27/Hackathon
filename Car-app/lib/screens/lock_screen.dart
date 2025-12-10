import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/car_provider.dart';
import '../models/registered_kad.dart';
import '../utils/app_design_system.dart';
import '../widgets/autoflux_logo.dart';
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF000000),
              const Color(0xFF0a0a0a),
              const Color(0xFF1a1a1a).withOpacity(0.8),
            ],
          ),
        ),
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
                    SizedBox(height: screenHeight * 0.03),

                    // AUTOFLUX Logo
                    Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    const Color(0xFF64FFDA).withOpacity(0.1),
                                    Colors.transparent,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF64FFDA,
                                    ).withOpacity(0.3),
                                    blurRadius: 40,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: AutofluxLogo(
                                size: screenWidth > 600 ? 200 : 160,
                                showText: false,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'AUTOFLUX',
                              style: TextStyle(
                                fontSize: screenWidth > 600 ? 42 : 36,
                                fontWeight: FontWeight.w900,
                                fontStyle: FontStyle.italic,
                                color: Colors.white,
                                letterSpacing: 3,
                                shadows: [
                                  Shadow(
                                    color: const Color(
                                      0xFF64FFDA,
                                    ).withOpacity(0.5),
                                    blurRadius: 15,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                        .animate()
                        .fadeIn(duration: 1000.ms)
                        .scale(begin: const Offset(0.8, 0.8), duration: 800.ms)
                        .shimmer(
                          duration: 2000.ms,
                          color: const Color(0xFF64FFDA).withOpacity(0.3),
                        ),

                    const SizedBox(height: 16),

                    // Tagline
                    Text(
                          'Smart Vehicle Control System',
                          style: AppTextStyles.body1.copyWith(
                            fontSize: 15,
                            color: const Color(0xFF64FFDA).withOpacity(0.9),
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        )
                        .animate(delay: 400.ms)
                        .fadeIn(duration: 800.ms)
                        .slideY(begin: 0.3, end: 0),

                    const SizedBox(height: 8),

                    Container(
                      width: 60,
                      height: 3,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Colors.transparent,
                            Color(0xFF64FFDA),
                            Colors.transparent,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ).animate(delay: 600.ms).fadeIn(duration: 1000.ms).scaleX(),

                    SizedBox(height: screenHeight * 0.06),

                    // Status Message
                    Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            gradient: _isScanning
                                ? LinearGradient(
                                    colors: [
                                      const Color(0xFF64FFDA).withOpacity(0.2),
                                      const Color(0xFF64FFDA).withOpacity(0.1),
                                    ],
                                  )
                                : LinearGradient(
                                    colors: [
                                      const Color(0xFF1a1a1a),
                                      const Color(0xFF0f0f0f),
                                    ],
                                  ),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: _isScanning
                                  ? const Color(0xFF64FFDA).withOpacity(0.6)
                                  : const Color(0xFF2a2a2a),
                              width: 1.5,
                            ),
                            boxShadow: _isScanning
                                ? [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF64FFDA,
                                      ).withOpacity(0.3),
                                      blurRadius: 15,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_isScanning)
                                const Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Icon(
                                    Icons.lock_outline,
                                    color: Color(0xFF64FFDA),
                                    size: 20,
                                  ),
                                )
                              else
                                const Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Icon(
                                    Icons.lock,
                                    color: Color(0xFF6B7280),
                                    size: 20,
                                  ),
                                ),
                              Text(
                                _scanMessage ?? 'VEHICLE LOCKED',
                                style: AppTextStyles.heading3.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: _isScanning
                                      ? const Color(0xFF64FFDA)
                                      : const Color(0xFF6B7280),
                                  letterSpacing: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                        .animate(delay: 700.ms)
                        .fadeIn()
                        .shimmer(
                          duration: _isScanning ? 1500.ms : 0.ms,
                          color: const Color(0xFF64FFDA).withOpacity(0.3),
                        ),

                    const SizedBox(height: 20),

                    Text(
                      hasOwner
                          ? 'Use MyKAD or QR code to unlock'
                          : 'Register your MyKAD to get started',
                      style: AppTextStyles.body2.copyWith(
                        fontSize: 14,
                        color: const Color(0xFF9CA3AF),
                        letterSpacing: 0.8,
                      ),
                      textAlign: TextAlign.center,
                    ).animate(delay: 800.ms).fadeIn(),

                    SizedBox(height: screenHeight * 0.05),

                    // Authentication Buttons
                    if (!_isScanning) ...[
                      _buildAuthButton(
                            context,
                            label: hasOwner
                                ? 'UNLOCK AS OWNER'
                                : 'REGISTER AS OWNER',
                            icon: Icons.person_outline,
                            color: const Color(0xFF64FFDA),
                            onTap: () => _handleOwnerAuth(car, hasOwner),
                          )
                          .animate(delay: 1000.ms)
                          .fadeIn(duration: 600.ms)
                          .slideY(begin: 0.3, end: 0),

                      const SizedBox(height: 16),

                      _buildAuthButton(
                            context,
                            label: 'GUEST ACCESS',
                            icon: Icons.qr_code_scanner_outlined,
                            color: const Color(0xFF3B82F6),
                            onTap: () => _handleGuestAuth(car, hasOwner),
                          )
                          .animate(delay: 1200.ms)
                          .fadeIn(duration: 600.ms)
                          .slideY(begin: 0.3, end: 0),

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
                            padding: const EdgeInsets.all(45),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  const Color(0xFF64FFDA).withOpacity(0.15),
                                  Colors.transparent,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF64FFDA,
                                  ).withOpacity(0.4),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF64FFDA),
                              ),
                              strokeWidth: 4,
                            ),
                          )
                          .animate(onPlay: (controller) => controller.repeat())
                          .scale(duration: 1000.ms)
                          .fadeIn(),
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
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 28),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.6), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: AppTextStyles.heading3.copyWith(
                fontSize: 16,
                color: color,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
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

    // Extract and verify age from MyKAD
    final dateOfBirth = RegisteredKad.extractDateOfBirth(mockKadNumber);
    if (dateOfBirth == null) {
      setState(() {
        _isScanning = false;
        _scanMessage = 'Invalid MyKAD format';
      });
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _scanMessage = null);
      return;
    }

    // Calculate age
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }

    // Verify minimum driving age (18 in Malaysia)
    if (age < 18) {
      setState(() {
        _isScanning = false;
        _scanMessage = 'Access Denied: Must be 18+ to drive';
      });
      _showAgeVerificationError(mockName, age);
      await Future.delayed(const Duration(seconds: 3));
      setState(() => _scanMessage = null);
      return;
    }

    setState(() {
      _scanMessage = 'Age Verified ($age years) - Registering...';
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

    // Simulate MyKAD scan for returning guest
    const mockGuestKadNumber =
        '010515-10-1234'; // Born 15 May 2001 (23 years old)

    // Extract and verify age from MyKAD
    final dateOfBirth = RegisteredKad.extractDateOfBirth(mockGuestKadNumber);
    if (dateOfBirth == null) {
      setState(() {
        _isScanning = false;
        _scanMessage = 'Invalid MyKAD format';
      });
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _scanMessage = null);
      return;
    }

    // Calculate age
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }

    // Verify minimum driving age (18 in Malaysia)
    if (age < 18) {
      setState(() {
        _isScanning = false;
        _scanMessage = 'Access Denied: Must be 18+ to drive';
      });
      _showAgeVerificationError(name, age);
      await Future.delayed(const Duration(seconds: 3));
      setState(() => _scanMessage = null);
      return;
    }

    setState(() {
      _scanMessage = 'Age Verified ($age years) - MyKAD Verified!';
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

    // Simulate MyKAD scan for guest
    const mockGuestKadNumber =
        '010515-10-1234'; // Born 15 May 2001 (23 years old)

    // Extract and verify age from MyKAD
    final dateOfBirth = RegisteredKad.extractDateOfBirth(mockGuestKadNumber);
    if (dateOfBirth == null) {
      setState(() {
        _isScanning = false;
        _scanMessage = 'Invalid MyKAD format';
      });
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _scanMessage = null);
      return;
    }

    // Calculate age
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }

    // Verify minimum driving age (18 in Malaysia)
    if (age < 18) {
      setState(() {
        _isScanning = false;
        _scanMessage = 'Access Denied: Must be 18+ to drive';
      });
      _showAgeVerificationError(name, age);
      await Future.delayed(const Duration(seconds: 3));
      setState(() => _scanMessage = null);
      return;
    }

    setState(() {
      _scanMessage = 'Age Verified ($age years) - MyKAD Verified!';
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

  void _showAgeVerificationError(String name, int age) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a1a),
        title: Row(
          children: [
            const Icon(Icons.warning, color: Color(0xFFEF4444), size: 32),
            const SizedBox(width: 12),
            Text(
              'Age Verification Failed',
              style: AppTextStyles.heading3.copyWith(
                color: const Color(0xFFEF4444),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Access Denied',
              style: AppTextStyles.body1.copyWith(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'The MyKAD scanned belongs to $name (Age: $age).',
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
                border: Border.all(
                  color: const Color(0xFFEF4444).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Color(0xFFEF4444),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Minimum age requirement: 18 years',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Malaysia\'s legal driving age is 18 years. Please ensure the driver meets this requirement before accessing the vehicle.',
                    style: AppTextStyles.caption.copyWith(
                      color: const Color(0xFF6B7280),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B7280),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: Text(
              'UNDERSTOOD',
              style: AppTextStyles.heading3.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
