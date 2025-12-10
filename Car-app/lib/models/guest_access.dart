/// Guest Access Model
/// Represents a guest access token for temporary car access
class GuestAccess {
  final String id;
  final String guestName;
  final DateTime createdAt;
  final DateTime expiryTime;
  final List<String> allowedFeatures;
  final String qrCode;
  final bool isActive;

  GuestAccess({
    required this.id,
    required this.guestName,
    required this.createdAt,
    required this.expiryTime,
    required this.allowedFeatures,
    required this.qrCode,
    this.isActive = true,
  });

  bool get isExpired => DateTime.now().isAfter(expiryTime);

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'guestName': guestName,
      'createdAt': createdAt.toIso8601String(),
      'expiryTime': expiryTime.toIso8601String(),
      'allowedFeatures': allowedFeatures,
      'qrCode': qrCode,
      'isActive': isActive,
    };
  }

  // Create from JSON
  factory GuestAccess.fromJson(Map<String, dynamic> json) {
    return GuestAccess(
      id: json['id'] as String,
      guestName: json['guestName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiryTime: DateTime.parse(json['expiryTime'] as String),
      allowedFeatures: List<String>.from(json['allowedFeatures'] as List),
      qrCode: json['qrCode'] as String,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  GuestAccess copyWith({
    String? id,
    String? guestName,
    DateTime? createdAt,
    DateTime? expiryTime,
    List<String>? allowedFeatures,
    String? qrCode,
    bool? isActive,
  }) {
    return GuestAccess(
      id: id ?? this.id,
      guestName: guestName ?? this.guestName,
      createdAt: createdAt ?? this.createdAt,
      expiryTime: expiryTime ?? this.expiryTime,
      allowedFeatures: allowedFeatures ?? this.allowedFeatures,
      qrCode: qrCode ?? this.qrCode,
      isActive: isActive ?? this.isActive,
    );
  }
}
