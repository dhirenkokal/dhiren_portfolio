import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class _TrailParticle {
  final Offset position;
  final int timestamp;
  _TrailParticle({required this.position, required this.timestamp});
}

class GlowingOrbCursor extends StatefulWidget {
  final Widget child;
  const GlowingOrbCursor({super.key, required this.child});

  @override
  State<GlowingOrbCursor> createState() => _GlowingOrbCursorState();
}

class _GlowingOrbCursorState extends State<GlowingOrbCursor>
    with SingleTickerProviderStateMixin {
  Offset _cursorPos = Offset.zero;
  Offset _smoothPos = Offset.zero;
  final List<_TrailParticle> _trail = [];
  late AnimationController _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _ticker.addListener(_tick);
  }

  void _tick() {
    final now = DateTime.now().millisecondsSinceEpoch;
    _trail.removeWhere((p) => now - p.timestamp > 700);
    // Smooth cursor following
    _smoothPos = Offset(
      _smoothPos.dx + (_cursorPos.dx - _smoothPos.dx) * 0.15,
      _smoothPos.dy + (_cursorPos.dy - _smoothPos.dy) * 0.15,
    );
    if (mounted) setState(() {});
  }

  void _onHover(PointerEvent event) {
    final now = DateTime.now().millisecondsSinceEpoch;
    _cursorPos = event.localPosition;
    _trail.add(_TrailParticle(position: event.localPosition, timestamp: now));
    if (_trail.length > 40) _trail.removeAt(0);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.none,
      onHover: _onHover,
      child: Stack(
        children: [
          widget.child,
          Positioned.fill(
            child: IgnorePointer(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: _OrbCursorPainter(
                    position: _cursorPos,
                    smoothPosition: _smoothPos,
                    trail: List.unmodifiable(_trail),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrbCursorPainter extends CustomPainter {
  final Offset position;
  final Offset smoothPosition;
  final List<_TrailParticle> trail;

  _OrbCursorPainter({
    required this.position,
    required this.smoothPosition,
    required this.trail,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (position == Offset.zero) return;
    final now = DateTime.now().millisecondsSinceEpoch;

    // Trail particles
    for (int i = 0; i < trail.length; i++) {
      final p = trail[i];
      final age = now - p.timestamp;
      final progress = 1.0 - (age / 700.0);
      if (progress <= 0) continue;

      final ratio = i / trail.length.toDouble();
      final radius = 3.0 * ratio * progress;
      final opacity = 0.7 * ratio * progress;

      canvas.drawCircle(
        p.position,
        radius,
        Paint()
          ..color = AppColors.accent.withOpacity(opacity)
          ..maskFilter =
              MaskFilter.blur(BlurStyle.normal, 4 * ratio * progress),
      );
    }

    // Outer diffuse glow
    canvas.drawCircle(
      smoothPosition,
      30,
      Paint()
        ..color = AppColors.accent.withOpacity(0.08)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25),
    );

    // Mid glow ring
    canvas.drawCircle(
      smoothPosition,
      14,
      Paint()
        ..color = AppColors.accent.withOpacity(0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    // Inner bright core
    canvas.drawCircle(
      smoothPosition,
      5,
      Paint()
        ..color = AppColors.accent.withOpacity(0.85)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // Solid center dot
    canvas.drawCircle(
      smoothPosition,
      2.5,
      Paint()..color = Colors.white.withOpacity(0.95),
    );

    // Crosshair lines (subtle)
    final linePaint = Paint()
      ..color = AppColors.accent.withOpacity(0.3)
      ..strokeWidth = 0.5
      ..strokeCap = StrokeCap.round;

    const lineLen = 8.0;
    canvas.drawLine(
      smoothPosition.translate(-lineLen - 7, 0),
      smoothPosition.translate(-7, 0),
      linePaint,
    );
    canvas.drawLine(
      smoothPosition.translate(7, 0),
      smoothPosition.translate(lineLen + 7, 0),
      linePaint,
    );
    canvas.drawLine(
      smoothPosition.translate(0, -lineLen - 7),
      smoothPosition.translate(0, -7),
      linePaint,
    );
    canvas.drawLine(
      smoothPosition.translate(0, 7),
      smoothPosition.translate(0, lineLen + 7),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(_OrbCursorPainter old) => true;
}
