import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/credential.dart';
import '../providers/vault_provider.dart';
import '../services/crypto_service.dart';
import '../utils/constants.dart';
import '../utils/app_strings.dart';
import '../widgets/glass_card.dart';

// ============================================================
// PANTALLA DE DETALLE - Ver y gestionar una credencial
// Muestra/oculta contraseña, copiar, editar, eliminar
// ============================================================

class DetailScreen extends StatefulWidget {
  final Credential credential;

  const DetailScreen({super.key, required this.credential});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    final credential = widget.credential;
    final strength = CryptoService.evaluateStrength(credential.password);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 2,
            colors: [
              credential.category.color.withValues(alpha: 0.08),
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
                        AppStrings.detail,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Botón eliminar
                    GestureDetector(
                      onTap: () => _confirmDelete(context),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.redAccent,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(20),
                  children: [
                    // ---- CABECERA CON CATEGORÍA ----
                    GlassCard(
                      accentColor: credential.category.color,
                      showAccentBorder: true,
                      padding: EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: credential.category.color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                credential.category.emoji,
                                style: TextStyle(fontSize: 32),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            credential.title,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: credential.category.color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              credential.category.label,
                              style: TextStyle(
                                color: credential.category.color,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),

                    // ---- CAMPO: USUARIO ----
                    _buildField(
                      label: AppStrings.userEmail,
                      value: credential.username,
                      icon: Icons.person_outline_rounded,
                      color: AppColors.cyan,
                    ),

                    // ---- CAMPO: CONTRASEÑA ----
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
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _showPassword
                                      ? credential.password
                                      : '•' * credential.password.length.clamp(8, 20),
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 18,
                                    fontFamily: _showPassword ? null : null,
                                    letterSpacing: _showPassword ? 0 : 3,
                                  ),
                                ),
                              ),
                              // Mostrar/ocultar
                              GestureDetector(
                                onTap: () =>
                                    setState(() => _showPassword = !_showPassword),
                                child: Icon(
                                  _showPassword
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                  color: AppColors.textMuted,
                                  size: 22,
                                ),
                              ),
                              SizedBox(width: 12),
                              // Copiar
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(
                                    ClipboardData(text: credential.password),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(AppStrings.passwordCopied),
                                      backgroundColor: AppColors.green,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.copy_rounded,
                                  color: AppColors.cyan,
                                  size: 22,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          // Barra de fortaleza
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: strength,
                                    backgroundColor:
                                        AppColors.surfaceLight,
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
                          ),
                        ],
                      ),
                    ),

                    // ---- CAMPO: URL (si existe) ----
                    if (credential.url != null && credential.url!.isNotEmpty)
                      _buildField(
                        label: 'URL',
                        value: credential.url!,
                        icon: Icons.link_rounded,
                        color: AppColors.green,
                      ),

                    // ---- CAMPO: NOTAS (si existen) ----
                    if (credential.notes != null && credential.notes!.isNotEmpty)
                      _buildField(
                        label: AppStrings.notes,
                        value: credential.notes!,
                        icon: Icons.note_outlined,
                        color: AppColors.academic,
                      ),

                    // ---- INFO DE FECHAS ----
                    SizedBox(height: 8),
                    GlassCard(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildDateRow(AppStrings.created, credential.createdAt),
                          Divider(color: AppColors.glassBorder, height: 20),
                          _buildDateRow(AppStrings.modified, credential.updatedAt),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---- Widget para campos de información ----
  Widget _buildField({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return GlassCard(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
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
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: value));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$label ${AppStrings.copied}'),
                      backgroundColor: AppColors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
                child: Icon(
                  Icons.copy_rounded,
                  color: AppColors.textMuted,
                  size: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---- Fila de fecha ----
  Widget _buildDateRow(String label, DateTime date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
        Text(
          '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      ],
    );
  }

  // ---- Diálogo de confirmación para eliminar ----
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(AppStrings.deleteCredential,
            style: TextStyle(color: AppColors.textPrimary)),
        content: Text(
          AppStrings.deleteConfirm(widget.credential.title),
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppStrings.cancel,
                style: TextStyle(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () {
              context
                  .read<VaultProvider>()
                  .deleteCredential(widget.credential.id);
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: Text(AppStrings.delete,
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
