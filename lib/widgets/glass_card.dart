import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/constants.dart';

// ============================================================
// WIDGET GLASS CARD - Efecto Liquid Glass
// Crea tarjetas translúcidas con blur, bordes luminosos
// y gradientes ambientales
// ============================================================

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? accentColor;       // Color del borde luminoso
  final double borderRadius;
  final double blurStrength;      // Intensidad del blur
  final VoidCallback? onTap;
  final bool showAccentBorder;    // Mostrar borde de color

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.accentColor,
    this.borderRadius = 20,
    this.blurStrength = 12,
    this.onTap,
    this.showAccentBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final accent = accentColor ?? AppColors.cyan;

    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: BackdropFilter(
            // Efecto blur de fondo (Liquid Glass)
            filter: ImageFilter.blur(
              sigmaX: blurStrength,
              sigmaY: blurStrength,
            ),
            child: Container(
              padding: padding ?? const EdgeInsets.all(16),
              decoration: BoxDecoration(
                // Fondo semi-transparente
                color: AppColors.glassWhite,
                borderRadius: BorderRadius.circular(borderRadius),
                // Borde translúcido con brillo sutil
                border: Border.all(
                  color: showAccentBorder
                      ? accent.withValues(alpha: 0.4)
                      : AppColors.glassBorder,
                  width: showAccentBorder ? 1.5 : 0.8,
                ),
                // Gradiente de luz ambiente
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.08),
                    Colors.white.withValues(alpha: 0.02),
                    accent.withValues(alpha: 0.03),
                  ],
                ),
                // Sombra sutil
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: showAccentBorder ? 0.1 : 0.05),
                    blurRadius: 20,
                    spreadRadius: -5,
                  ),
                ],
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// WIDGET GLASS CHIP - Chips con efecto glass para categorías
// ============================================================

class GlassChip extends StatelessWidget {
  final String label;
  final String emoji;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const GlassChip({
    super.key,
    required this.label,
    required this.emoji,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.2) : AppColors.glassWhite,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? color.withValues(alpha: 0.6) : AppColors.glassBorder,
            width: isSelected ? 1.5 : 0.8,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : AppColors.textSecondary,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// WIDGET GLASS BUTTON - Botones con efecto glass
// ============================================================

class GlassButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;
  final VoidCallback onPressed;
  final bool isExpanded;

  const GlassButton({
    super.key,
    required this.label,
    this.icon,
    required this.color,
    required this.onPressed,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final button = GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withValues(alpha: 0.7)],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );

    return isExpanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}
