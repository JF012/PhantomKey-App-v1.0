import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/constants.dart';

// ============================================================
// FONDO VIVO - Gradientes orgánicos más visibles
// ============================================================

class LivingBackground extends StatefulWidget {
  final Widget child;

  const LivingBackground({super.key, required this.child});

  @override
  State<LivingBackground> createState() => _LivingBackgroundState();
}

class _LivingBackgroundState extends State<LivingBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _LivingBgPainter(
            progress: _controller.value,
            isDark: AppColors.isDark,
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _LivingBgPainter extends CustomPainter {
  final double progress;
  final bool isDark;

  _LivingBgPainter({required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final double t = progress * 2 * pi;

    // Fondo base
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = AppColors.background,
    );

    // BLOB 1: Primario — grande, lento
    _drawBlob(
      canvas: canvas, size: size,
      cx: size.width * (0.3 + 0.2 * sin(t * 0.7 + 1.2)),
      cy: size.height * (0.2 + 0.15 * sin(t * 0.5 + 0.8)),
      radius: size.width * 0.55,
      color: AppColors.cyan,
      opacity: isDark ? 0.14 : 0.09,
    );

    // BLOB 2: Secundario — medio
    _drawBlob(
      canvas: canvas, size: size,
      cx: size.width * (0.7 + 0.25 * sin(t * 0.9 + 2.5)),
      cy: size.height * (0.6 + 0.2 * cos(t * 0.6 + 1.0)),
      radius: size.width * 0.45,
      color: AppColors.violet,
      opacity: isDark ? 0.12 : 0.07,
    );

    // BLOB 3: Terciario — rápido, pequeño
    _drawBlob(
      canvas: canvas, size: size,
      cx: size.width * (0.5 + 0.3 * cos(t * 1.1 + 0.3)),
      cy: size.height * (0.8 + 0.15 * sin(t * 0.8 + 3.7)),
      radius: size.width * 0.35,
      color: AppColors.green,
      opacity: isDark ? 0.10 : 0.06,
    );

    // BLOB 4: Acento — diagonal
    _drawBlob(
      canvas: canvas, size: size,
      cx: size.width * (0.15 + 0.2 * sin(t * 0.6 + 4.2)),
      cy: size.height * (0.5 + 0.25 * cos(t * 0.4 + 2.1)),
      radius: size.width * 0.4,
      color: AppColors.cyan,
      opacity: isDark ? 0.08 : 0.05,
    );

    // BLOB 5: Profundidad — muy grande, sutil
    _drawBlob(
      canvas: canvas, size: size,
      cx: size.width * (0.8 + 0.15 * cos(t * 0.3 + 5.0)),
      cy: size.height * (0.3 + 0.1 * sin(t * 0.7 + 1.5)),
      radius: size.width * 0.6,
      color: AppColors.violet,
      opacity: isDark ? 0.07 : 0.04,
    );
  }

  void _drawBlob({
    required Canvas canvas, required Size size,
    required double cx, required double cy,
    required double radius, required Color color,
    required double opacity,
  }) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: opacity),
          color.withValues(alpha: opacity * 0.3),
          color.withValues(alpha: 0),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(
        Rect.fromCircle(center: Offset(cx, cy), radius: radius),
      );
    canvas.drawCircle(Offset(cx, cy), radius, paint);
  }

  @override
  bool shouldRepaint(_LivingBgPainter old) =>
      old.progress != progress || old.isDark != isDark;
}
