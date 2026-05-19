import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/credential.dart';
import '../providers/vault_provider.dart';
import '../utils/constants.dart';
import '../utils/app_strings.dart';
import '../widgets/glass_card.dart';
import '../widgets/living_background.dart';
import 'detail_screen.dart';
import 'generator_screen.dart';
import 'add_credential_screen.dart';

// ============================================================
// PANTALLA PRINCIPAL - Con toggle de tema e idioma
// ============================================================

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LivingBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildSearchBar(context),
              _buildCategoryFilters(context),
              Expanded(child: _buildCredentialList(context)),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final provider = context.watch<VaultProvider>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 400),
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
                child: Text(AppStrings.appName),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 400),
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                child: Text(
                  AppStrings.passwordsCount(provider.totalCredentials),
                ),
              ),
            ],
          ),
          Row(
            children: [
              // ---- BOTÓN IDIOMA (ES/EN) ----
              GestureDetector(
                onTap: () => provider.toggleLanguage(),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.glassWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: ScaleTransition(scale: anim, child: child),
                    ),
                    child: Text(
                      provider.isSpanish ? 'ES' : 'EN',
                      key: ValueKey(provider.isSpanish),
                      style: TextStyle(
                        color: AppColors.green,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // ---- TOGGLE TEMA ----
              _ThemeToggle(
                isDark: provider.isDarkMode,
                onToggle: () => provider.toggleTheme(),
              ),
              const SizedBox(width: 8),
              // Generador
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, _, _) => const GeneratorScreen(),
                    transitionsBuilder: (_, anim, _, child) =>
                        FadeTransition(opacity: anim, child: child),
                    transitionDuration: const Duration(milliseconds: 300),
                  ),
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.glassWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Icon(
                    Icons.auto_fix_high_rounded,
                    color: AppColors.cyan,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Bloquear
              GestureDetector(
                onTap: () => context.read<VaultProvider>().lock(),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.glassWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.textMuted,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        borderRadius: 16,
        blurStrength: 8,
        child: TextField(
          onChanged: (v) => context.read<VaultProvider>().setSearchQuery(v),
          style: TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: AppStrings.searchHint,
            hintStyle: TextStyle(color: AppColors.textMuted),
            prefixIcon: Icon(Icons.search_rounded, color: AppColors.textMuted),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilters(BuildContext context) {
    final provider = context.watch<VaultProvider>();
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GlassChip(
              label: AppStrings.allFilter,
              emoji: '🔑',
              color: AppColors.cyan,
              isSelected: provider.selectedCategory == null,
              onTap: () => provider.setCategory(null),
            ),
          ),
          ...CredentialCategory.values.map(
            (cat) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GlassChip(
                label: cat.label,
                emoji: cat.emoji,
                color: cat.color,
                isSelected: provider.selectedCategory == cat,
                onTap: () => provider.setCategory(
                  provider.selectedCategory == cat ? null : cat,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCredentialList(BuildContext context) {
    final provider = context.watch<VaultProvider>();
    if (provider.isLoading) {
      return Center(child: CircularProgressIndicator(color: AppColors.cyan));
    }
    final credentials = provider.credentials;
    if (credentials.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shield_outlined,
              size: 64,
              color: AppColors.textMuted.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.noCredentials,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.addFirstPassword,
              style: TextStyle(color: AppColors.textMuted, fontSize: 14),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      itemCount: credentials.length,
      itemBuilder: (context, index) =>
          _CredentialTile(credential: credentials[index]),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.cyan, AppColors.violet]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: () => Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, _, _) => const AddCredentialScreen(),
            transitionsBuilder: (_, anim, _, child) => SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
                  ),
              child: FadeTransition(opacity: anim, child: child),
            ),
            transitionDuration: const Duration(milliseconds: 350),
          ),
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }
}

// ---- TOGGLE TEMA ----
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
        width: 56,
        height: 30,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isDark ? AppColors.surface : const Color(0xFFE8E0D8),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.06),
            width: 0.5,
          ),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOutCubic,
          alignment: isDark ? Alignment.centerLeft : Alignment.centerRight,
          child: Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? AppColors.cyan.withValues(alpha: 0.9)
                  : const Color(0xFFFF9800),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? AppColors.cyan.withValues(alpha: 0.25)
                      : const Color(0xFFFF9800).withValues(alpha: 0.3),
                  blurRadius: 8,
                ),
              ],
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) => RotationTransition(
                turns: Tween(begin: 0.8, end: 1.0).animate(anim),
                child: ScaleTransition(scale: anim, child: child),
              ),
              child: Icon(
                isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                key: ValueKey(isDark),
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---- CREDENTIAL TILE ----
class _CredentialTile extends StatelessWidget {
  final Credential credential;
  const _CredentialTile({required this.credential});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, _, _) => DetailScreen(credential: credential),
          transitionsBuilder: (_, anim, _, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 300),
        ),
      ),
      accentColor: credential.category.color,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: credential.category.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                credential.category.emoji,
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  credential.title,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  credential.username,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textMuted,
            size: 22,
          ),
        ],
      ),
    );
  }
}
