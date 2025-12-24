import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/car_provider.dart';
import '../utils/error_handler.dart';
import '../utils/haptic_feedback_service.dart';
import '../constants/app_constants.dart';

/// Access Control Screen
/// Manage MyKAD registrations and guest access
class AccessControlScreen extends StatefulWidget {
  const AccessControlScreen({super.key});

  @override
  State<AccessControlScreen> createState() => _AccessControlScreenState();
}

class _AccessControlScreenState extends State<AccessControlScreen> {
  int _currentTab = 0;
  bool _isLoading = false;

  Future<T?> _runWithLoading<T>({
    required String message,
    required Future<T> Function() operation,
    String? errorMessage,
  }) async {
    setState(() => _isLoading = true);
    final result = await ErrorHandler.handleAsync(
      context,
      operation,
      errorMessage: errorMessage,
    );
    setState(() => _isLoading = false);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Access Control'),
      ),
      body: Column(
        children: [
          if (_isLoading)
            const LinearProgressIndicator(
              minHeight: 2,
              color: Color(0xFF64FFDA),
              backgroundColor: Colors.transparent,
            ),
          // Tab Bar
          Container(
            color: Colors.grey[900],
            child: Row(
              children: [
                Expanded(
                  child: _TabButton(
                    label: 'MyKAD',
                    isSelected: _currentTab == 0,
                    onTap: () => setState(() => _currentTab = 0),
                  ),
                ),
                Expanded(
                  child: _TabButton(
                    label: 'Guest Access',
                    isSelected: _currentTab == 1,
                    onTap: () => setState(() => _currentTab = 1),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _currentTab == 0
                ? _MyKADManagement()
                : _GuestAccessManagement(),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFF64FFDA) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? const Color(0xFF64FFDA) : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _MyKADManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final car = Provider.of<CarProvider>(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Registered MyKADs',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),

        if (car.registeredKads.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                'No MyKADs registered yet',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),

        ...car.registeredKads.map((kad) {
          return Card(
            color: Colors.grey[900],
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(
                kad.isOwner ? Icons.verified_user : Icons.person,
                color: kad.isOwner ? Colors.amber : const Color(0xFF64FFDA),
              ),
              title: Text(
                kad.ownerName,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                '${kad.isOwner ? 'Owner' : 'Authorized User'}\nLast accessed: ${_formatDate(kad.lastAccessed)}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              trailing: !kad.isOwner
                  ? IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Remove KAD
                      },
                    )
                  : null,
            ),
          );
        }).toList(),

        const SizedBox(height: 24),

        ElevatedButton.icon(
          onPressed: () async {
            HapticFeedbackService.selection();
            final parentState =
                context.findAncestorStateOfType<_AccessControlScreenState>();
            final car = Provider.of<CarProvider>(context, listen: false);

            final scanned = await parentState?._runWithLoading<bool>(
              message: 'Scanning MyKAD...',
              operation: () => car.scanMyKad(),
              errorMessage: 'Failed to scan MyKAD',
            );

            if (scanned == false) {
              // Show registration dialog
              final nameController = TextEditingController();
              bool isOwner = false;
              await showDialog<void>(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: Colors.grey[900],
                  title: const Text('Register MyKAD', style: TextStyle(color: Colors.white)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Full name',
                          labelStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 12),
                      StatefulBuilder(
                        builder: (ctx, setState) => CheckboxListTile(
                          title: const Text('Set as owner', style: TextStyle(color: Colors.white)),
                          value: isOwner,
                          onChanged: (v) => setState(() => isOwner = v ?? false),
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: const Color(0xFF64FFDA),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (nameController.text.trim().isEmpty) return;
                        Navigator.pop(ctx);
                        await parentState?._runWithLoading<void>(
                          message: 'Registering MyKAD...',
                          operation: () => car.registerKad(
                            kadNumber: car.currentUserKad ?? '950123-01-5678',
                            name: nameController.text.trim(),
                            isOwner: isOwner,
                          ),
                          errorMessage: 'Failed to register MyKAD',
                        );

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('MyKAD registered')),
                          );
                        }
                      },
                      child: const Text('Register'),
                    ),
                  ],
                ),
              );
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('MyKAD scanned and authenticated')),
                );
              }
            }
          },
          icon: const Icon(Icons.qr_code_scanner),
          label: const Text('Scan New MyKAD'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF64FFDA),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _GuestAccessManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final car = Provider.of<CarProvider>(context);
    final state = context.findAncestorStateOfType<_AccessControlScreenState>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Guest Access',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),

        ElevatedButton.icon(
          onPressed: () => _showCreateGuestDialog(context),
          icon: const Icon(Icons.person_add),
          label: const Text('Create Guest Access'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF64FFDA),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.all(16),
          ),
        ),

        const SizedBox(height: 24),

        const Text(
          'Active Guest Access',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),

        if (car.activeGuestAccesses.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                'No active guest access',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),

        ...car.activeGuestAccesses.map((access) {
          return Card(
            color: Colors.grey[900],
            margin: const EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              leading: const Icon(Icons.qr_code, color: Color(0xFF64FFDA)),
              title: Text(
                access.guestName,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                'Expires: ${_formatDateTime(access.expiryTime)}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  HapticFeedbackService.selection();
                  await state?._runWithLoading<void>(
                    message: 'Revoking access...',
                    operation: () => car.revokeGuestAccess(access.id),
                    errorMessage: 'Failed to revoke guest access',
                  );
                },
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      QrImageView(
                        data: access.qrCode,
                        version: QrVersions.auto,
                        size: 200.0,
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          Share.share(
                            'Join my car access: ${access.qrCode}',
                            subject: 'Car Guest Access',
                          );
                        },
                        icon: const Icon(Icons.share),
                        label: const Text('Share QR Code'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showCreateGuestDialog(BuildContext context) {
    final nameController = TextEditingController();
    int durationDays = 1;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Create Guest Access',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Guest Name',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    'Duration:',
                    style: TextStyle(color: Colors.white),
                  ),
                  const Spacer(),
                  DropdownButton<int>(
                    value: durationDays,
                    dropdownColor: Colors.grey[800],
                    style: const TextStyle(color: Colors.white),
                    items: [1, 3, 7, 14, 30].map((days) {
                      return DropdownMenuItem(
                        value: days,
                        child: Text('$days day${days > 1 ? 's' : ''}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => durationDays = value!);
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  HapticFeedbackService.medium();
                  final car = Provider.of<CarProvider>(context, listen: false);
                  final parentState = context
                      .findAncestorStateOfType<_AccessControlScreenState>();
                  final result = await parentState?._runWithLoading<void>(
                    message: 'Creating guest access...',
                    operation: () => car.createGuestAccess(
                      guestName: nameController.text,
                      durationDays: durationDays,
                    ),
                    errorMessage: 'Failed to create guest access',
                  );
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Guest access created'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF64FFDA),
                foregroundColor: Colors.black,
              ),
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
