import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/car_provider.dart';
import '../utils/app_design_system.dart';

/// RFID/Toll Screen
/// MyKAD acts as RFID for highway tolls and parking access
class RfidTollScreen extends StatefulWidget {
  const RfidTollScreen({super.key});

  @override
  State<RfidTollScreen> createState() => _RfidTollScreenState();
}

class _RfidTollScreenState extends State<RfidTollScreen> {
  bool _rfidActive = false;
  bool _isScanning = false;
  String? _lastTransaction;
  double _balance = 150.50; // Demo balance
  final List<Map<String, dynamic>> _transactions = [
    {
      'type': 'Highway Toll',
      'location': 'PLUS Highway - Plaza Tol Sungai Besi',
      'amount': -4.50,
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'icon': Icons.toll,
    },
    {
      'type': 'Parking',
      'location': 'Pavilion KL - Level B2',
      'amount': -12.00,
      'date': DateTime.now().subtract(const Duration(hours: 5)),
      'icon': Icons.local_parking,
    },
    {
      'type': 'Highway Toll',
      'location': 'ELITE Highway - Plaza Tol Shah Alam',
      'amount': -6.20,
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'icon': Icons.toll,
    },
    {
      'type': 'Top Up',
      'location': 'Touch n Go eWallet',
      'amount': 50.00,
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'icon': Icons.account_balance_wallet,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final car = Provider.of<CarProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'RFID & TOLL',
          style: AppTextStyles.heading3.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.credit_card),
            onPressed: _showTopUpDialog,
            tooltip: 'Top Up',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // RFID Status Card
            _buildRfidStatusCard(),

            const SizedBox(height: 24),

            // Balance Card
            _buildBalanceCard(),

            const SizedBox(height: 24),

            // MyKAD as RFID
            _buildMyKadRfidCard(car),

            const SizedBox(height: 24),

            // Features Info
            _buildFeaturesSection(),

            const SizedBox(height: 32),

            // Transaction History
            _buildTransactionHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildRfidStatusCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a1a),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _rfidActive
              ? const Color(0xFF64FFDA)
              : const Color(0xFF2a2a2a),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _rfidActive
                  ? const Color(0xFF64FFDA).withOpacity(0.2)
                  : const Color(0xFF2a2a2a),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _rfidActive ? Icons.wifi_tethering : Icons.portable_wifi_off,
              color: _rfidActive
                  ? const Color(0xFF64FFDA)
                  : const Color(0xFF6B7280),
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RFID STATUS',
                  style: AppTextStyles.caption.copyWith(
                    color: const Color(0xFF6B7280),
                    fontSize: 12,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _rfidActive ? 'ACTIVE & READY' : 'INACTIVE',
                  style: AppTextStyles.heading2.copyWith(
                    color: _rfidActive ? const Color(0xFF64FFDA) : Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _rfidActive,
            activeColor: const Color(0xFF64FFDA),
            onChanged: (value) {
              setState(() => _rfidActive = value);
              _showToast(value ? 'RFID Activated' : 'RFID Deactivated');
            },
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.2);
  }

  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF64FFDA), Color(0xFF14B8A6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF64FFDA).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AVAILABLE BALANCE',
                style: AppTextStyles.heading3.copyWith(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Touch n Go',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'RM ${_balance.toStringAsFixed(2)}',
            style: AppTextStyles.heading1.copyWith(
              color: Colors.black,
              fontSize: 36,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _showTopUpDialog,
            icon: const Icon(Icons.add, color: Color(0xFF64FFDA)),
            label: Text(
              'TOP UP',
              style: AppTextStyles.heading3.copyWith(
                color: const Color(0xFF64FFDA),
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.2);
  }

  Widget _buildMyKadRfidCard(CarProvider car) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a1a),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2a2a2a), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.credit_card,
                  color: Color(0xFF3B82F6),
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MyKAD LINKED',
                      style: AppTextStyles.caption.copyWith(
                        color: const Color(0xFF64FFDA),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      car.registeredKads.isNotEmpty
                          ? car.registeredKads.first.name
                          : 'Not Registered',
                      style: AppTextStyles.heading2.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (car.registeredKads.isNotEmpty)
                      Text(
                        car.registeredKads.first.kadNumber,
                        style: AppTextStyles.caption.copyWith(
                          color: const Color(0xFF6B7280),
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Color(0xFF2a2a2a)),
          const SizedBox(height: 16),
          Text(
            'Your MyKAD is now linked as RFID for:',
            style: AppTextStyles.body2.copyWith(
              color: const Color(0xFF6B7280),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          _buildFeatureItem(
            Icons.toll,
            'Highway Toll Payment',
            'Automatic toll deduction',
          ),
          _buildFeatureItem(
            Icons.local_parking,
            'Parking Access',
            'Backup when plate recognition fails',
          ),
          _buildFeatureItem(
            Icons.security,
            'Building Access',
            'Gated community entry',
          ),
        ],
      ),
    ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.2);
  }

  Widget _buildFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'HOW IT WORKS',
          style: AppTextStyles.heading2.copyWith(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          '1. Highway Tolls',
          'When approaching toll booth, MyKAD RFID is automatically detected. Payment deducted from linked Touch n Go balance.',
          Icons.toll,
          const Color(0xFF10B981),
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          '2. Parking Entry',
          'If ANPR camera fails to read your plate, tap your MyKAD at the reader. Barrier opens automatically.',
          Icons.local_parking,
          const Color(0xFF3B82F6),
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          '3. Smart Exit',
          'On exit, parking fee is calculated and deducted. SMS receipt sent to registered mobile.',
          Icons.exit_to_app,
          const Color(0xFFF59E0B),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a1a),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2a2a2a)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.heading3.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.caption.copyWith(
                    color: const Color(0xFF6B7280),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF64FFDA), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body1.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: const Color(0xFF6B7280),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'RECENT TRANSACTIONS',
              style: AppTextStyles.heading2.copyWith(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'View All',
                style: AppTextStyles.caption.copyWith(
                  color: const Color(0xFF64FFDA),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._transactions.map(
          (transaction) => _buildTransactionItem(transaction),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final isPositive = transaction['amount'] > 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a1a),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2a2a2a)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isPositive
                  ? const Color(0xFF10B981).withOpacity(0.2)
                  : const Color(0xFFEF4444).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              transaction['icon'],
              color: isPositive
                  ? const Color(0xFF10B981)
                  : const Color(0xFFEF4444),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['type'],
                  style: AppTextStyles.body1.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  transaction['location'],
                  style: AppTextStyles.caption.copyWith(
                    color: const Color(0xFF6B7280),
                    fontSize: 12,
                  ),
                ),
                Text(
                  _formatDate(transaction['date']),
                  style: AppTextStyles.caption.copyWith(
                    color: const Color(0xFF6B7280),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isPositive ? '+' : ''}RM ${transaction['amount'].abs().toStringAsFixed(2)}',
            style: AppTextStyles.numbers.copyWith(
              color: isPositive
                  ? const Color(0xFF10B981)
                  : const Color(0xFFEF4444),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inHours < 1) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  void _showTopUpDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a1a),
        title: Text(
          'Top Up Balance',
          style: AppTextStyles.heading2.copyWith(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTopUpOption('RM 20.00', 20.00),
            _buildTopUpOption('RM 50.00', 50.00),
            _buildTopUpOption('RM 100.00', 100.00),
            _buildTopUpOption('RM 200.00', 200.00),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildTopUpOption(String label, double amount) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        setState(() {
          _balance += amount;
        });
        _showToast('Successfully topped up $label');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2a2a2a),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF64FFDA).withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.heading2.copyWith(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF64FFDA),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF64FFDA),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
