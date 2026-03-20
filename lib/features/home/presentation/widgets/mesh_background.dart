import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_color_tokens.dart';

class MeshBackground extends StatefulWidget {
  final double scrollOffset;
  const MeshBackground({super.key, this.scrollOffset = 0});

  @override
  State<MeshBackground> createState() => _MeshBackgroundState();
}

class _MeshBackgroundState extends State<MeshBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) => RepaintBoundary(
        child: CustomPaint(
          painter: _MeshPainter(
            t: _ctrl.value,
            scrollOffset: widget.scrollOffset,
            colors: colors,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _MeshPainter extends CustomPainter {
  final double t;
  final double scrollOffset;
  final AppColorTokens colors;

  _MeshPainter({
    required this.t,
    required this.scrollOffset,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Solid base
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = colors.background,
    );

    final scrollFactor = scrollOffset * 0.0003;

    // In dark mode: dark navy blobs on near-black base
    // In light mode: saturated mid-blues on sky-blue base — must be visible
    final blob1Color = colors.isDark ? const Color(0xFF001A3A) : const Color(0xFF3D73D8);
    final blob2Color = colors.isDark ? const Color(0xFF001F3D) : const Color(0xFF4A7BE5);
    final blob3Color = colors.isDark ? const Color(0xFF002040) : const Color(0xFF2E64CC);

    final blobs = [
      _Blob(
        center: Offset(
          size.width * (0.15 + 0.12 * math.sin(t * 2 * math.pi + 0.0)),
          size.height * (0.2 + 0.08 * math.cos(t * 2 * math.pi + 1.0) + scrollFactor),
        ),
        radius: size.width * 0.35,
        color: blob1Color,
        opacity: colors.isDark ? 0.9 : 0.28,
      ),
      _Blob(
        center: Offset(
          size.width * (0.85 + 0.1 * math.cos(t * 2 * math.pi + 2.0)),
          size.height * (0.15 + 0.1 * math.sin(t * 2 * math.pi + 0.5) + scrollFactor * 0.5),
        ),
        radius: size.width * 0.3,
        color: blob2Color,
        opacity: colors.isDark ? 0.8 : 0.22,
      ),
      _Blob(
        center: Offset(
          size.width * (0.5 + 0.08 * math.sin(t * 2 * math.pi + 3.0)),
          size.height * (0.6 + 0.1 * math.cos(t * 2 * math.pi + 1.5) + scrollFactor * 1.2),
        ),
        radius: size.width * 0.4,
        color: blob3Color,
        opacity: colors.isDark ? 0.6 : 0.18,
      ),
      // Accent glow blob
      _Blob(
        center: Offset(
          size.width * (0.2 + 0.15 * math.cos(t * 2 * math.pi + 4.0)),
          size.height * (0.7 + 0.1 * math.sin(t * 2 * math.pi + 2.0) + scrollFactor * 0.8),
        ),
        radius: size.width * 0.2,
        color: colors.accentGlow,
        opacity: colors.isDark ? 0.04 : 0.14,
      ),
      _Blob(
        center: Offset(
          size.width * (0.8 + 0.1 * math.sin(t * 2 * math.pi + 5.0)),
          size.height * (0.5 + 0.12 * math.cos(t * 2 * math.pi + 3.0) + scrollFactor),
        ),
        radius: size.width * 0.18,
        color: colors.accent,
        opacity: colors.isDark ? 0.03 : 0.10,
      ),
    ];

    for (final blob in blobs) {
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            blob.color.withOpacity(blob.opacity),
            blob.color.withOpacity(0),
          ],
        ).createShader(
          Rect.fromCircle(center: blob.center, radius: blob.radius),
        );
      canvas.drawCircle(blob.center, blob.radius, paint);
    }

    // Subtle grid overlay
    _drawGrid(canvas, size);
  }

  void _drawGrid(Canvas canvas, Size size) {
    const gridSpacing = 60.0;
    final paint = Paint()
      ..color = colors.cardBorder.withOpacity(colors.isDark ? 0.15 : 0.3)
      ..strokeWidth = 0.5;

    for (double x = 0; x < size.width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_MeshPainter old) =>
      old.t != t || old.scrollOffset != scrollOffset || old.colors.isDark != colors.isDark;
}

class _Blob {
  final Offset center;
  final double radius;
  final Color color;
  final double opacity;
  const _Blob({
    required this.center,
    required this.radius,
    required this.color,
    required this.opacity,
  });
}
