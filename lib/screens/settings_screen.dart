import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vault_provider.dart';
import '../utils/constants.dart';
import '../utils/app_strings.dart';
import '../widgets/glass_card.dart';
import '../widgets/living_background.dart';

// ============================================================
// PANTALLA DE AJUSTES - Tema, idioma, info de la app
// ============================================================

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VaultProvider>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LivingBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 20, 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
                    ),
                    Text(AppStrings.settings,
                      style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // ---- SECCIÓN: APARIENCIA ----
                    _SectionTitle(title: AppStrings.appearance),
                    const SizedBox(height: 8),

                    // Toggle tema
                    GlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Icon(
                            provider.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                            color: AppColors.violet,
                            size: 24,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppStrings.theme,
                                  style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w500)),
                                const SizedBox(height: 2),
                                Text(
                                  provider.isDarkMode ? AppStrings.darkMode : AppStrings.lightMode,
                                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          // Toggle animado
                          _ThemeToggle(
                            isDark: provider.isDarkMode,
                            onToggle: () => provider.toggleTheme(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ---- SECCIÓN: IDIOMA ----
                    _SectionTitle(title: AppStrings.language),
                    const SizedBox(height: 8),

                    // Opción Español
                    _LanguageOption(
                      flag: '🇪🇸',
                      label: 'Español',
                      isSelected: provider.isSpanish,
                      onTap: () {
                        if (!provider.isSpanish) provider.toggleLanguage();
                      },
                    ),

                    // Opción English
                    _LanguageOption(
                      flag: '🇺🇸',
                      label: 'English',
                      isSelected: !provider.isSpanish,
                      onTap: () {
                        if (provider.isSpanish) provider.toggleLanguage();
                      },
                    ),

                    const SizedBox(height: 20),

                    // ---- SECCIÓN: SEGURIDAD ----
                    _SectionTitle(title: AppStrings.security),
                    const SizedBox(height: 8),

                    GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.shield_rounded, color: AppColors.green, size: 24),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppStrings.encryption,
                                  style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w500)),
                                const SizedBox(height: 2),
                                Text('AES-256-CBC', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                              ],
                            ),
                          ),
                          Icon(Icons.check_circle_rounded, color: AppColors.green, size: 22),
                        ],
                      ),
                    ),

                    GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.storage_rounded, color: AppColors.cyan, size: 24),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppStrings.storage,
                                  style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w500)),
                                const SizedBox(height: 2),
                                Text(AppStrings.localOnly, style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                              ],
                            ),
                          ),
                          Icon(Icons.check_circle_rounded, color: AppColors.cyan, size: 22),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ---- SECCIÓN: ACERCA DE ----
                    _SectionTitle(title: AppStrings.about),
                    const SizedBox(height: 8),

                    GlassCard(
                      padding: const EdgeInsets.all(20),
                      accentColor: AppColors.cyan,
                      child: Column(
                        children: [
                          Icon(Icons.shield_rounded, size: 48, color: AppColors.cyan.withValues(alpha: 0.8)),
                          const SizedBox(height: 12),
                          Text('PhantomKey',
                            style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1)),
                          const SizedBox(height: 4),
                          Text('v1.0.0', style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
                          const SizedBox(height: 8),
                          Text(AppStrings.appSlogan,
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                            textAlign: TextAlign.center),
                          const SizedBox(height: 12),
                          Text('Made with Flutter 💙',
                            style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---- Título de sección ----
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        color: AppColors.textMuted,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
      ),
    );
  }
}

// ---- Opción de idioma ----
class _LanguageOption extends StatelessWidget {
  final String flag;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.flag,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      accentColor: isSelected ? AppColors.cyan : null,
      showAccentBorder: isSelected,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Text(flag, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              )),
          ),
          if (isSelected)
            Icon(Icons.check_circle_rounded, color: AppColors.cyan, size: 22),
        ],
      ),
    );
  }
}

// ---- Toggle de tema (reutilizado) ----
class _ThemeToggle extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggle;
  const _ThemeToggle({required this.isDark, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        width: 56, height: 30, padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isDark ? AppColors.surface : const Color(0xFFE8E0D8),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06),
            width: 0.5,
          ),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOutCubic,
          alignment: isDark ? Alignment.centerLeft : Alignment.centerRight,
          child: Container(
            width: 26, height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? AppColors.cyan.withValues(alpha: 0.9) : const Color(0xFFFF9800),
              boxShadow: [BoxShadow(
                color: isDark ? AppColors.cyan.withValues(alpha: 0.25) : const Color(0xFFFF9800).withValues(alpha: 0.3),
                blurRadius: 8,
              )],
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) => RotationTransition(
                turns: Tween(begin: 0.8, end: 1.0).animate(anim),
                child: ScaleTransition(scale: anim, child: child),
              ),
              child: Icon(
                isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                key: ValueKey(isDark), size: 14, color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
