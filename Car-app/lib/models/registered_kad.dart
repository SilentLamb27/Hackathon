/// Registered MyKAD Model
/// Represents a MyKAD that has been scanned and registered with this car
class RegisteredKad {
  final String kadNumber; // Encrypted or hashed in production
  final String ownerName;
  final DateTime dateOfBirth; // Extracted from MyKAD number
  final DateTime firstRegistered;
  final DateTime lastAccessed;
  final bool isOwner;
  final int accessCount;

  // Getter for name (alias for ownerName)
  String get name => ownerName;

  // Getter for age (calculated from date of birth)
  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  // Check if person is eligible to drive (18+ in Malaysia)
  bool get isEligibleToDrive => age >= 18;

  RegisteredKad({
    required this.kadNumber,
    required this.ownerName,
    required this.dateOfBirth,
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
      'dateOfBirth': dateOfBirth.toIso8601String(),
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
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      firstRegistered: DateTime.parse(json['firstRegistered'] as String),
      lastAccessed: DateTime.parse(json['lastAccessed'] as String),
      isOwner: json['isOwner'] as bool,
      accessCount: json['accessCount'] as int? ?? 1,
    );
  }

  RegisteredKad copyWith({
    String? kadNumber,
    String? ownerName,
    DateTime? dateOfBirth,
    DateTime? firstRegistered,
    DateTime? lastAccessed,
    bool? isOwner,
    int? accessCount,
  }) {
    return RegisteredKad(
      kadNumber: kadNumber ?? this.kadNumber,
      ownerName: ownerName ?? this.ownerName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      firstRegistered: firstRegistered ?? this.firstRegistered,
      lastAccessed: lastAccessed ?? this.lastAccessed,
      isOwner: isOwner ?? this.isOwner,
      accessCount: accessCount ?? this.accessCount,
    );
  }

  /// Extract date of birth from Malaysian MyKAD number
  /// Format: YYMMDD-PP-NNNN (e.g., 950123-01-5678 = 23 Jan 1995)
  static DateTime? extractDateOfBirth(String kadNumber) {
    try {
      // Remove dashes and get first 6 digits
      final digits = kadNumber.replaceAll('-', '');
      if (digits.length < 6) return null;

      final yy = int.parse(digits.substring(0, 2));
      final mm = int.parse(digits.substring(2, 4));
      final dd = int.parse(digits.substring(4, 6));

      // Determine century (assume born between 1900-2099)
      // If YY > current year's last 2 digits, assume 19XX, else 20XX
      final currentYearLastTwo = DateTime.now().year % 100;
      final year = yy > currentYearLastTwo ? 1900 + yy : 2000 + yy;

      return DateTime(year, mm, dd);
    } catch (e) {
      return null;
    }
  }
}
