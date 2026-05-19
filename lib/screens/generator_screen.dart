import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/crypto_service.dart';
import '../utils/constants.dart';
import '../utils/app_strings.dart';
import '../widgets/glass_card.dart';

// ============================================================
// PANTALLA GENERADOR - Genera contraseñas seguras
// Configurable: longitud, mayúsculas, números, símbolos
// ============================================================

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  String _generatedPassword = '';
  double _length = 16;
  bool _includeUppercase = true;
  bool _includeLowercase = true;
  bool _includeNumbers = true;
  bool _includeSymbols = true;

  @override
  void initState() {
    super.initState();
    _generatePassword();
  }

  // Generar nueva contraseña con la configuración actual
  void _generatePassword() {
    setState(() {
      _generatedPassword = CryptoService.generatePassword(
        length: _length.toInt(),
        includeUppercase: _includeUppercase,
        includeLowercase: _includeLowercase,
        includeNumbers: _includeNumbers,
        includeSymbols: _includeSymbols,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final strength = CryptoService.evaluateStrength(_generatedPassword);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.bottomCenter,
            radius: 2,
            colors: [
              AppColors.cyan.withValues(alpha: 0.06),
              AppColors.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ---- HEADER ----
              Padding(
                padding: EdgeInsets.fromLTRB(8, 8, 20, 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      AppStrings.generator,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(20),
                  children: [
                    // ---- CONTRASEÑA GENERADA ----
                    GlassCard(
                      accentColor: AppColors.cyan,
                      showAccentBorder: true,
                      padding: EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // Contraseña con fuente monoespaciada
                          SelectableText(
                            _generatedPassword,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                              fontFamily: 'monospace',
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: 16),

                          // Barra de fortaleza
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: strength,
                              backgroundColor: AppColors.surfaceLight,
                              color: strength < 0.3
                                  ? Colors.redAccent
                                  : strength < 0.6
                                      ? AppColors.academic
                                      : AppColors.green,
                              minHeight: 6,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            CryptoService.strengthLabel(strength),
                            style: TextStyle(
                              color: strength < 0.3
                                  ? Colors.redAccent
                                  : strength < 0.6
                                      ? AppColors.academic
                                      : AppColors.green,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          SizedBox(height: 20),

                          // Botones de acción
                          Row(
                            children: [
                              Expanded(
                                child: GlassButton(
                                  label: AppStrings.copy,
                                  icon: Icons.copy_rounded,
                                  color: AppColors.cyan,
                                  onPressed: () {
                                    Clipboard.setData(
                                      ClipboardData(text: _generatedPassword),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text(AppStrings.passwordCopied),
                                        backgroundColor: AppColors.green,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: GlassButton(
                                  label: AppStrings.generate,
                                  icon: Icons.refresh_rounded,
                                  color: AppColors.violet,
                                  onPressed: _generatePassword,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    // ---- CONFIGURACIÓN ----
                    Text(
                      AppStrings.configuration,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),

                    // Longitud
                    GlassCard(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppStrings.length,
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.cyan.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${_length.toInt()}',
                                  style: TextStyle(
                                    color: AppColors.cyan,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Slider de longitud
                          SliderTheme(
                            data: SliderThemeData(
                              activeTrackColor: AppColors.cyan,
                              inactiveTrackColor: AppColors.surfaceLight,
                              thumbColor: AppColors.cyan,
                              overlayColor: AppColors.cyan.withValues(alpha: 0.2),
                            ),
                            child: Slider(
                              value: _length,
                              min: 6,
                              max: 32,
                              divisions: 26,
                              onChanged: (value) {
                                setState(() => _length = value);
                                _generatePassword();
                              },
                            ),
                          ),
                          // Etiquetas min/max
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('6',
                                  style: TextStyle(
                                      color: AppColors.textMuted, fontSize: 12)),
                              Text('32',
                                  style: TextStyle(
                                      color: AppColors.textMuted, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Opciones de caracteres
                    _buildToggle(AppStrings.uppercase, _includeUppercase, (val) {
                      setState(() => _includeUppercase = val);
                      _generatePassword();
                    }),
                    _buildToggle(AppStrings.lowercase, _includeLowercase, (val) {
                      setState(() => _includeLowercase = val);
                      _generatePassword();
                    }),
                    _buildToggle(AppStrings.numbers, _includeNumbers, (val) {
                      setState(() => _includeNumbers = val);
                      _generatePassword();
                    }),
                    _buildToggle(AppStrings.symbols, _includeSymbols, (val) {
                      setState(() => _includeSymbols = val);
                      _generatePassword();
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---- Widget toggle para opciones ----
  Widget _buildToggle(String label, bool value, Function(bool) onChanged) {
    return GlassCard(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.cyan.withValues(alpha: 0.3),
            inactiveTrackColor: AppColors.surfaceLight,
          ),
        ],
      ),
    );
  }
}
