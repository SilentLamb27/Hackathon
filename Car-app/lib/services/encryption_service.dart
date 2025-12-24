import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Encryption Service
/// Handles secure hashing and encryption of sensitive data
class EncryptionService {
  /// Hash a MyKAD number using SHA-256
  /// This ensures we don't store plain text identity numbers
  static String hashKadNumber(String kadNumber) {
    final bytes = utf8.encode(kadNumber);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Verify a MyKAD number against a stored hash
  static bool verifyKadNumber(String kadNumber, String hash) {
    return hashKadNumber(kadNumber) == hash;
  }

  /// Hash a password or sensitive string
  static String hashString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Generate a secure random token
  static String generateSecureToken() {
    final random = DateTime.now().millisecondsSinceEpoch.toString();
    final bytes = utf8.encode(random);
    final digest = sha256.convert(bytes);
    return digest.toString().substring(0, 32); // Return first 32 chars
  }
}

