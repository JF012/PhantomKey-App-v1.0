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
import 'settings_screen.dart';

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

  // ---- HEADER LIMPIO: título + 3 botones ----
  Widget _buildHeader(BuildContext context) {
    final provider = context.watch<VaultProvider>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          // Título
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 400),
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 1),
                  child: Text(AppStrings.appName),
                ),
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 400),
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  child: Text(AppStrings.passwordsCount(provider.totalCredentials)),
                ),
              ],
            ),
          ),
          // Botón Settings
          _HeaderButton(
            icon: Icons.settings_rounded,
            color: AppColors.textSecondary,
            onTap: () => Navigator.push(context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const SettingsScreen(),
                transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
                transitionDuration: const Duration(milliseconds: 300),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Botón Generador
          _HeaderButton(
            icon: Icons.auto_fix_high_rounded,
            color: AppColors.cyan,
            onTap: () => Navigator.push(context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const GeneratorScreen(),
                transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
                transitionDuration: const Duration(milliseconds: 300),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Botón Bloquear
          _HeaderButton(
            icon: Icons.lock_outline_rounded,
            color: AppColors.textMuted,
            onTap: () => context.read<VaultProvider>().lock(),
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
        borderRadius: 16, blurStrength: 8,
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
              label: AppStrings.allFilter, emoji: '🔑', color: AppColors.cyan,
              isSelected: provider.selectedCategory == null,
              onTap: () => provider.setCategory(null),
            ),
          ),
          ...CredentialCategory.values.map((cat) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GlassChip(
              label: cat.label, emoji: cat.emoji, color: cat.color,
              isSelected: provider.selectedCategory == cat,
              onTap: () => provider.setCategory(provider.selectedCategory == cat ? null : cat),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildCredentialList(BuildContext context) {
    final provider = context.watch<VaultProvider>();
    if (provider.isLoading) return Center(child: CircularProgressIndicator(color: AppColors.cyan));
    final credentials = provider.credentials;
    if (credentials.isEmpty) {
      return Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shield_outlined, size: 64, color: AppColors.textMuted.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(AppStrings.noCredentials, style: TextStyle(color: AppColors.textSecondary, fontSize: 18, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text(AppStrings.addFirstPassword, style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
        ],
      ));
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      itemCount: credentials.length,
      itemBuilder: (context, index) => _CredentialTile(credential: credentials[index]),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.cyan, AppColors.violet]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.cyan.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: FloatingActionButton(
        backgroundColor: Colors.transparent, elevation: 0,
        onPressed: () => Navigator.push(context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const AddCredentialScreen(),
            transitionsBuilder: (_, anim, __, child) => SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
                  .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
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

// ---- Botón del header reutilizable ----
class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _HeaderButton({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.glassWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}

// ---- Credential Tile ----
class _CredentialTile extends StatelessWidget {
  final Credential credential;
  const _CredentialTile({required this.credential});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: () => Navigator.push(context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => DetailScreen(credential: credential),
          transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 300),
        ),
      ),
      accentColor: credential.category.color,
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: credential.category.color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(credential.category.emoji, style: const TextStyle(fontSize: 22))),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(credential.title, style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(credential.username, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          ])),
          Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 22),
        ],
      ),
    );
  }
}
