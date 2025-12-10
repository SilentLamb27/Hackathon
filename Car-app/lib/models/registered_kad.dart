/// Registered MyKAD Model
/// Represents a MyKAD that has been scanned and registered with this car
class RegisteredKad {
  final String kadNumber; // Encrypted or hashed in production
  final String ownerName;
  final DateTime firstRegistered;
  final DateTime lastAccessed;
  final bool isOwner;
  final int accessCount;

  // Getter for name (alias for ownerName)
  String get name => ownerName;

  RegisteredKad({
    required this.kadNumber,
    required this.ownerName,
    required this.firstRegistered,
    required this.lastAccessed,
    required this.isOwner,
    this.accessCount = 1,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'kadNumber': kadNumber,
      'ownerName': ownerName,
      'firstRegistered': firstRegistered.toIso8601String(),
      'lastAccessed': lastAccessed.toIso8601String(),
      'isOwner': isOwner,
      'accessCount': accessCount,
    };
  }

  // Create from JSON
  factory RegisteredKad.fromJson(Map<String, dynamic> json) {
    return RegisteredKad(
      kadNumber: json['kadNumber'] as String,
      ownerName: json['ownerName'] as String,
      firstRegistered: DateTime.parse(json['firstRegistered'] as String),
      lastAccessed: DateTime.parse(json['lastAccessed'] as String),
      isOwner: json['isOwner'] as bool,
      accessCount: json['accessCount'] as int? ?? 1,
    );
  }

  RegisteredKad copyWith({
    String? kadNumber,
    String? ownerName,
    DateTime? firstRegistered,
    DateTime? lastAccessed,
    bool? isOwner,
    int? accessCount,
  }) {
    return RegisteredKad(
      kadNumber: kadNumber ?? this.kadNumber,
      ownerName: ownerName ?? this.ownerName,
      firstRegistered: firstRegistered ?? this.firstRegistered,
      lastAccessed: lastAccessed ?? this.lastAccessed,
      isOwner: isOwner ?? this.isOwner,
      accessCount: accessCount ?? this.accessCount,
    );
  }
}
