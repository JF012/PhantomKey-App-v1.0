import 'package:flutter/material.dart';
import 'app_strings.dart';

// ============================================================
// CONSTANTES - Paleta dual + categorías localizadas
// ============================================================

class AppColors {
  static const _dark = _ColorSet(
    background: Color(0xFF0D0B0E),
    surface: Color(0xFF1A1520),
    surfaceLight: Color(0xFF261E2D),
    primary: Color(0xFFFF6B4A),
    secondary: Color(0xFFFF9F43),
    tertiary: Color(0xFFFFD93D),
    textPrimary: Color(0xFFF5F0EA),
    textSecondary: Color(0xFFB8A9A0),
    textMuted: Color(0xFF7A6B6B),
    glassWhite: Color(0x12FFFFFF),
    glassBorder: Color(0x25FFFFFF),
    socialMedia: Color(0xFFFF6B4A),
    work: Color(0xFFFF9F43),
    bank: Color(0xFFFFD93D),
    academic: Color(0xFFE87EFF),
  );

  static const _light = _ColorSet(
    background: Color(0xFFF8F5F1),
    surface: Color(0xFFFFFFFF),
    surfaceLight: Color(0xFFEDE8E2),
    primary: Color(0xFFE8533A),
    secondary: Color(0xFFE88A30),
    tertiary: Color(0xFFD4A017),
    textPrimary: Color(0xFF1A1118),
    textSecondary: Color(0xFF6B5C5C),
    textMuted: Color(0xFF9E8E8E),
    glassWhite: Color(0x18000000),
    glassBorder: Color(0x15000000),
    socialMedia: Color(0xFFE8533A),
    work: Color(0xFFE88A30),
    bank: Color(0xFFD4A017),
    academic: Color(0xFFCC5AE8),
  );

  static bool _isDark = true;
  static void setDarkMode(bool isDark) => _isDark = isDark;
  static bool get isDark => _isDark;

  static Color get background => _isDark ? _dark.background : _light.background;
  static Color get surface => _isDark ? _dark.surface : _light.surface;
  static Color get surfaceLight => _isDark ? _dark.surfaceLight : _light.surfaceLight;
  static Color get cyan => _isDark ? _dark.primary : _light.primary;
  static Color get violet => _isDark ? _dark.secondary : _light.secondary;
  static Color get green => _isDark ? _dark.tertiary : _light.tertiary;
  static Color get textPrimary => _isDark ? _dark.textPrimary : _light.textPrimary;
  static Color get textSecondary => _isDark ? _dark.textSecondary : _light.textSecondary;
  static Color get textMuted => _isDark ? _dark.textMuted : _light.textMuted;
  static Color get glassWhite => _isDark ? _dark.glassWhite : _light.glassWhite;
  static Color get glassBorder => _isDark ? _dark.glassBorder : _light.glassBorder;
  static Color get socialMedia => _isDark ? _dark.socialMedia : _light.socialMedia;
  static Color get work => _isDark ? _dark.work : _light.work;
  static Color get bank => _isDark ? _dark.bank : _light.bank;
  static Color get academic => _isDark ? _dark.academic : _light.academic;
}

class _ColorSet {
  final Color background, surface, surfaceLight;
  final Color primary, secondary, tertiary;
  final Color textPrimary, textSecondary, textMuted;
  final Color glassWhite, glassBorder;
  final Color socialMedia, work, bank, academic;

  const _ColorSet({
    required this.background, required this.surface, required this.surfaceLight,
    required this.primary, required this.secondary, required this.tertiary,
    required this.textPrimary, required this.textSecondary, required this.textMuted,
    required this.glassWhite, required this.glassBorder,
    required this.socialMedia, required this.work, required this.bank, required this.academic,
  });
}

enum CredentialCategory {
  socialMedia('🌐'),
  work('💼'),
  bank('🏦'),
  academic('🎓');

  final String emoji;
  const CredentialCategory(this.emoji);

  // Label localizado dinámico
  String get label {
    switch (this) {
      case CredentialCategory.socialMedia: return AppStrings.catSocialMedia;
      case CredentialCategory.work: return AppStrings.catWork;
      case CredentialCategory.bank: return AppStrings.catBank;
      case CredentialCategory.academic: return AppStrings.catAcademic;
    }
  }

  Color get color {
    switch (this) {
      case CredentialCategory.socialMedia: return AppColors.socialMedia;
      case CredentialCategory.work: return AppColors.work;
      case CredentialCategory.bank: return AppColors.bank;
      case CredentialCategory.academic: return AppColors.academic;
    }
  }
}
