import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import '../providers/vault_provider.dart';
import '../utils/constants.dart';
import '../utils/app_strings.dart';
import '../widgets/glass_card.dart';
import '../widgets/living_background.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});
  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> with TickerProviderStateMixin {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isAuthenticating = false;
  _BiometricType _biometricType = _BiometricType.none;

  late AnimationController _entranceController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.0, 0.7, curve: Curves.easeOut)),
    );
    _slideUp = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.1, 0.8, curve: Curves.easeOutCubic)),
    );
    _entranceController.forward();

    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _detectBiometrics();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _detectBiometrics() async {
    if (kIsWeb) { setState(() => _biometricType = _BiometricType.none); return; }
    try {
      final canAuth = await _localAuth.canCheckBiometrics;
      final isSupported = await _localAuth.isDeviceSupported();
      if (!canAuth || !isSupported) { setState(() => _biometricType = _BiometricType.none); return; }
      final biometrics = await _localAuth.getAvailableBiometrics();
      setState(() {
        if (biometrics.contains(BiometricType.face)) { _biometricType = _BiometricType.faceId; }
        else if (biometrics.contains(BiometricType.fingerprint)) { _biometricType = _BiometricType.fingerprint; }
        else if (biometrics.contains(BiometricType.strong) || biometrics.contains(BiometricType.weak)) { _biometricType = _BiometricType.fingerprint; }
        else { _biometricType = _BiometricType.none; }
      });
    } catch (e) { setState(() => _biometricType = _BiometricType.none); }
  }

  IconData get _biometricIcon {
    switch (_biometricType) {
      case _BiometricType.faceId: return Icons.face_rounded;
      case _BiometricType.fingerprint: return Icons.fingerprint_rounded;
      case _BiometricType.none: return Icons.lock_open_rounded;
    }
  }

  String get _biometricLabel {
    switch (_biometricType) {
      case _BiometricType.faceId: return AppStrings.faceId;
      case _BiometricType.fingerprint: return AppStrings.fingerprint;
      case _BiometricType.none: return AppStrings.unlock;
    }
  }

  String get _statusMessage {
    switch (_biometricType) {
      case _BiometricType.faceId: return AppStrings.useFaceId;
      case _BiometricType.fingerprint: return AppStrings.useFingerprint;
      case _BiometricType.none: return AppStrings.tapToUnlock;
    }
  }

  String get _authReason {
    switch (_biometricType) {
      case _BiometricType.faceId: return AppStrings.faceIdReason;
      case _BiometricType.fingerprint: return AppStrings.fingerprintReason;
      case _BiometricType.none: return AppStrings.genericReason;
    }
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating) return;
    setState(() => _isAuthenticating = true);
    bool authenticated = false;
    if (kIsWeb) {
      await Future.delayed(const Duration(milliseconds: 800));
      authenticated = true;
    } else {
      try {
        final canAuth = await _localAuth.canCheckBiometrics;
        final isSupported = await _localAuth.isDeviceSupported();
        if (canAuth && isSupported) {
          authenticated = await _localAuth.authenticate(localizedReason: _authReason);
        } else { authenticated = true; }
      } catch (e) { authenticated = true; }
    }
    if (authenticated && mounted) {
      final provider = context.read<VaultProvider>();
      provider.unlock();
      await provider.loadCredentials();
    } else if (mounted) {
      setState(() => _isAuthenticating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LivingBackground(
        child: FadeTransition(
          opacity: _fadeIn,
          child: SlideTransition(
            position: _slideUp,
            child: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) => Transform.scale(scale: _pulseAnimation.value, child: child),
                        child: GlassCard(
                          padding: const EdgeInsets.all(32),
                          accentColor: AppColors.cyan, showAccentBorder: true, blurStrength: 20,
                          child: Icon(Icons.shield_rounded, size: 64, color: AppColors.cyan.withValues(alpha: 0.9)),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(AppStrings.appName,
                        style: TextStyle(color: AppColors.textPrimary, fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 2)),
                      const SizedBox(height: 8),
                      Text(AppStrings.appSlogan, style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                      const SizedBox(height: 48),
                      GlassCard(
                        onTap: _authenticate,
                        accentColor: AppColors.cyan, showAccentBorder: true,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(_isAuthenticating ? Icons.lock_clock_rounded : _biometricIcon, color: AppColors.cyan, size: 28),
                            const SizedBox(width: 12),
                            Text(_isAuthenticating ? AppStrings.verifying : _biometricLabel,
                              style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(_isAuthenticating ? AppStrings.verifying : _statusMessage,
                        style: TextStyle(color: AppColors.textMuted, fontSize: 14), textAlign: TextAlign.center),
                      const SizedBox(height: 48),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock_outline, color: AppColors.green, size: 16),
                          const SizedBox(width: 6),
                          Text('AES-256 · ${_biometricType == _BiometricType.faceId ? 'Face ID' : _biometricType == _BiometricType.fingerprint ? AppStrings.fingerprint : 'Local'}',
                            style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _BiometricType { faceId, fingerprint, none }
