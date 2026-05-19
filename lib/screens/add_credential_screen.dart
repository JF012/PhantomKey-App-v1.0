import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vault_provider.dart';
import '../services/crypto_service.dart';
import '../utils/constants.dart';
import '../utils/app_strings.dart';
import '../widgets/glass_card.dart';

// ============================================================
// PANTALLA AGREGAR CREDENCIAL - Formulario para nueva entrada
// ============================================================

class AddCredentialScreen extends StatefulWidget {
  const AddCredentialScreen({super.key});

  @override
  State<AddCredentialScreen> createState() => _AddCredentialScreenState();
}

class _AddCredentialScreenState extends State<AddCredentialScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _urlController = TextEditingController();
  final _notesController = TextEditingController();
  CredentialCategory _selectedCategory = CredentialCategory.socialMedia;
  bool _showPassword = false;

  @override
  void dispose() {
    _titleController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _urlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // ---- GUARDAR CREDENCIAL ----
  void _save() {
    if (_formKey.currentState!.validate()) {
      context.read<VaultProvider>().addCredential(
            title: _titleController.text.trim(),
            username: _usernameController.text.trim(),
            password: _passwordController.text,
            url: _urlController.text.trim().isEmpty
                ? null
                : _urlController.text.trim(),
            notes: _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
            category: _selectedCategory,
          );
      Navigator.pop(context);
    }
  }

  // ---- GENERAR CONTRASEÑA AUTOMÁTICA ----
  void _autoGenerate() {
    setState(() {
      _passwordController.text = CryptoService.generatePassword(
        length: 20,
        includeUppercase: true,
        includeLowercase: true,
        includeNumbers: true,
        includeSymbols: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 2,
            colors: [
              AppColors.green.withValues(alpha: 0.06),
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
                    Expanded(
                      child: Text(
                        AppStrings.newCredential,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _save,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.cyan, AppColors.violet],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          AppStrings.save,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ---- FORMULARIO ----
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: EdgeInsets.all(20),
                    children: [
                      // Selector de categoría
                      Text(
                        AppStrings.category,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: CredentialCategory.values.map((cat) {
                          final isSelected = _selectedCategory == cat;
                          return GlassChip(
                            label: cat.label,
                            emoji: cat.emoji,
                            color: cat.color,
                            isSelected: isSelected,
                            onTap: () =>
                                setState(() => _selectedCategory = cat),
                          );
                        }).toList(),
                      ),

                      SizedBox(height: 20),

                      // Campo: Título
                      _buildTextField(
                        controller: _titleController,
                        label: AppStrings.serviceTitle,
                        hint: AppStrings.serviceTitleHint,
                        icon: Icons.bookmark_outline_rounded,
                        validator: (val) =>
                            val == null || val.isEmpty ? AppStrings.required : null,
                      ),

                      // Campo: Usuario
                      _buildTextField(
                        controller: _usernameController,
                        label: AppStrings.userOrEmail,
                        hint: AppStrings.userOrEmailHint,
                        icon: Icons.person_outline_rounded,
                        validator: (val) =>
                            val == null || val.isEmpty ? AppStrings.required : null,
                      ),

                      // Campo: Contraseña con botón de generar
                      GlassCard(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.lock_outline_rounded,
                                    color: AppColors.violet, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  AppStrings.password,
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 13,
                                  ),
                                ),
                                const Spacer(),
                                // Botón generar automático
                                GestureDetector(
                                  onTap: _autoGenerate,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.violet.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.auto_fix_high_rounded,
                                            color: AppColors.violet, size: 14),
                                        SizedBox(width: 4),
                                        Text(
                                          AppStrings.generate,
                                          style: TextStyle(
                                            color: AppColors.violet,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: !_showPassword,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                hintText: AppStrings.passwordHint,
                                hintStyle:
                                    TextStyle(color: AppColors.textMuted),
                                border: InputBorder.none,
                                suffixIcon: GestureDetector(
                                  onTap: () => setState(
                                      () => _showPassword = !_showPassword),
                                  child: Icon(
                                    _showPassword
                                        ? Icons.visibility_off_rounded
                                        : Icons.visibility_rounded,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ),
                              validator: (val) => val == null || val.isEmpty
                                  ? AppStrings.required
                                  : null,
                            ),
                            // Indicador de fortaleza en tiempo real
                            if (_passwordController.text.isNotEmpty) ...[
                              SizedBox(height: 8),
                              _buildStrengthIndicator(),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(height: 6),

                      // Campo: URL (opcional)
                      _buildTextField(
                        controller: _urlController,
                        label: AppStrings.urlOptional,
                        hint: AppStrings.urlHint,
                        icon: Icons.link_rounded,
                      ),

                      // Campo: Notas (opcional)
                      _buildTextField(
                        controller: _notesController,
                        label: AppStrings.notesOptional,
                        hint: AppStrings.notesHint,
                        icon: Icons.note_outlined,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---- Widget de campo de texto con glass ----
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return GlassCard(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.textMuted, size: 18),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: AppColors.textMuted),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            validator: validator,
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }

  // ---- Indicador de fortaleza en tiempo real ----
  Widget _buildStrengthIndicator() {
    final strength =
        CryptoService.evaluateStrength(_passwordController.text);
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: strength,
              backgroundColor: AppColors.surfaceLight,
              color: strength < 0.3
                  ? Colors.redAccent
                  : strength < 0.6
                      ? AppColors.academic
                      : AppColors.green,
              minHeight: 4,
            ),
          ),
        ),
        SizedBox(width: 12),
        Text(
          CryptoService.strengthLabel(strength),
          style: TextStyle(
            color: strength < 0.3
                ? Colors.redAccent
                : strength < 0.6
                    ? AppColors.academic
                    : AppColors.green,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
