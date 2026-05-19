import 'dart:math';
import 'package:encrypt/encrypt.dart' as encrypt_lib;
import '../utils/app_strings.dart';

// ============================================================
// SERVICIO DE CIFRADO - AES-256 CBC
// ============================================================

class CryptoService {
  static const String _keyString = 'PhantomKey2026SecureKeyAES256K!!';

  late final encrypt_lib.Key _key;
  late final encrypt_lib.Encrypter _encrypter;

  CryptoService() {
    _key = encrypt_lib.Key.fromUtf8(_keyString);
    _encrypter = encrypt_lib.Encrypter(
      encrypt_lib.AES(_key, mode: encrypt_lib.AESMode.cbc),
    );
  }

  String encryptText(String plainText) {
    final iv = encrypt_lib.IV.fromSecureRandom(16);
    final encrypted = _encrypter.encrypt(plainText, iv: iv);
    return '${iv.base64}:${encrypted.base64}';
  }

  String decryptText(String encryptedText) {
    try {
      final parts = encryptedText.split(':');
      if (parts.length != 2) return encryptedText;
      final iv = encrypt_lib.IV.fromBase64(parts[0]);
      final encrypted = encrypt_lib.Encrypted.fromBase64(parts[1]);
      return _encrypter.decrypt(encrypted, iv: iv);
    } catch (e) {
      return encryptedText;
    }
  }

  static String generatePassword({
    int length = 16,
    bool includeUppercase = true,
    bool includeLowercase = true,
    bool includeNumbers = true,
    bool includeSymbols = true,
  }) {
    String chars = '';
    if (includeLowercase) chars += 'abcdefghijklmnopqrstuvwxyz';
    if (includeUppercase) chars += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    if (includeNumbers) chars += '0123456789';
    if (includeSymbols) chars += '!@#\$%^&*()_+-=[]{}|;:,.<>?';
    if (chars.isEmpty) chars = 'abcdefghijklmnopqrstuvwxyz';

    final random = Random.secure();
    return List.generate(length, (_) => chars[random.nextInt(chars.length)]).join();
  }

  static double evaluateStrength(String password) {
    if (password.isEmpty) return 0.0;
    double score = 0.0;
    if (password.length >= 8) score += 0.2;
    if (password.length >= 12) score += 0.1;
    if (password.length >= 16) score += 0.1;
    if (password.contains(RegExp(r'[a-z]'))) score += 0.15;
    if (password.contains(RegExp(r'[A-Z]'))) score += 0.15;
    if (password.contains(RegExp(r'[0-9]'))) score += 0.15;
    if (password.contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]'))) score += 0.15;
    return score.clamp(0.0, 1.0);
  }

  // Etiqueta localizada de fortaleza
  static String strengthLabel(double strength) {
    if (strength < 0.3) return AppStrings.weak;
    if (strength < 0.6) return AppStrings.medium;
    if (strength < 0.8) return AppStrings.strong;
    return AppStrings.veryStrong;
  }
}
