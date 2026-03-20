import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';

class CinematicPreloader extends StatefulWidget {
  final VoidCallback onComplete;
  const CinematicPreloader({super.key, required this.onComplete});

  @override
  State<CinematicPreloader> createState() => _CinematicPreloaderState();
}

class _CinematicPreloaderState extends State<CinematicPreloader>
    with TickerProviderStateMixin {
  late AnimationController _sequenceCtrl;
  late AnimationController _ambientCtrl;
  late AnimationController _exitCtrl;

  // Derived sequence animations
  late Animation<double> _gridFade;
  late Animation<double> _dhirenReveal;
  late Animation<double> _lineSwipe;
  late Animation<double> _kokalReveal;
  late Animation<double> _subtitleFade;
  late Animation<double> _tagFade;
  late Animation<double> _progressFill;

  // Exit
  late Animation<double> _exitFade;
  late Animation<double> _exitScale;
  late Animation<double> _burstProgress;

  final math.Random _rng = math.Random(7);
  late final List<_AmbientDot> _dots;
  late final List<_BurstParticle> _burst;

  @override
  void initState() {
    super.initState();

    _dots = List.generate(55, (_) => _AmbientDot(_rng));
    _burst = List.generate(130, (_) => _BurstParticle(_rng));

    // ── Sequence: 3.6 s total ──────────────────────────────────────────
    _sequenceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    );

    Animation<double> _seq(double s, double e, [Curve c = Curves.easeOut]) =>
        Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _sequenceCtrl,
            curve: Interval(s, e, curve: c),
          ),
        );

    _gridFade = _seq(0.00, 0.10);
    _dhirenReveal = _seq(0.06, 0.28, Curves.easeOutCubic);
    _lineSwipe = _seq(0.26, 0.42, Curves.easeOutCubic);
    _kokalReveal = _seq(0.38, 0.58, Curves.easeOutCubic);
    _subtitleFade = _seq(0.55, 0.68);
    _tagFade = _seq(0.62, 0.74);
    _progressFill = _seq(0.68, 0.97, Curves.easeInOut);

    // ── Ambient: loops ─────────────────────────────────────────────────
    _ambientCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();

    // ── Exit: 900 ms ───────────────────────────────────────────────────
    _exitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _exitFade = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _exitCtrl,
        curve: const Interval(0.35, 1.0, curve: Curves.easeIn),
      ),
    );
    _exitScale = Tween<double>(begin: 1.0, end: 1.07).animate(
      CurvedAnimation(
        parent: _exitCtrl,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
      ),
    );
    _burstProgress = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _exitCtrl,
        curve: const Interval(0.0, 0.75, curve: Curves.easeOut),
      ),
    );

    _runSequence();
  }

  Future<void> _runSequence() async {
    await Future.delayed(const Duration(milliseconds: 180));
    await _sequenceCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 350));
    await _exitCtrl.forward();
    widget.onComplete();
  }

  @override
  void dispose() {
    _sequenceCtrl.dispose();
    _ambientCtrl.dispose();
    _exitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(decoration: TextDecoration.none),
      child: AnimatedBuilder(
        animation: Listenable.merge([_sequenceCtrl, _ambientCtrl, _exitCtrl]),
        builder: (context, _) {
          return Opacity(
            opacity: _exitFade.value,
            child: Transform.scale(
            scale: _exitScale.value,
            child: Container(
              color: AppColors.background,
              child: Stack(
                children: [
                  // Subtle grid
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _GridPainter(
                        opacity: _gridFade.value * 0.10,
                      ),
                    ),
                  ),

                  // Ambient floating dots
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _AmbientDotPainter(
                        dots: _dots,
                        t: _ambientCtrl.value,
                        opacity: _gridFade.value,
                      ),
                    ),
                  ),

                  // Burst particles on exit
                  if (_burstProgress.value > 0)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _BurstPainter(
                          particles: _burst,
                          progress: _burstProgress.value,
                        ),
                      ),
                    ),

                  // Center content — responsive via LayoutBuilder
                  Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final w = MediaQuery.of(context).size.width;
                        final isMobile = w < 600;
                        final isTablet = w < 960;
                        final fontSize = isMobile ? 44.0 : isTablet ? 64.0 : 88.0;
                        final dhirenSpacing = isMobile ? 10.0 : isTablet ? 16.0 : 22.0;
                        final kokalSpacing = isMobile ? 6.0 : isTablet ? 10.0 : 14.0;
                        final lineWidth = isMobile ? 220.0 : isTablet ? 300.0 : 360.0;
                        final progressWidth = isMobile ? 200.0 : 260.0;

                        return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // ── Badge / eyebrow ─────────────────────────
                        _FadeSlide(
                          progress: _dhirenReveal.value,
                          slideDistance: 20,
                          child: _Badge(),
                        ),

                        SizedBox(height: isMobile ? 20 : 28),

                        // ── DHIREN — ultra thin, wide tracking ──────
                        _ClipReveal(
                          progress: _dhirenReveal.value,
                          child: ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (b) =>
                                const LinearGradient(
                              colors: [Color(0xFFFFFFFF), Color(0xFFDDEEFF)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ).createShader(b),
                            child: Text(
                              'DHIREN',
                              style: GoogleFonts.inter(
                                fontSize: fontSize,
                                fontWeight: FontWeight.w200,
                                letterSpacing: dhirenSpacing,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // ── Sweeping accent line ─────────────────────
                        _SweepLine(progress: _lineSwipe.value, width: lineWidth),

                        const SizedBox(height: 10),

                        // ── KOKAL — ultra bold, gradient ─────────────
                        _ClipReveal(
                          progress: _kokalReveal.value,
                          child: ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (b) =>
                                const LinearGradient(
                              colors: [
                                Color(0xFF80D8FF),
                                AppColors.accent,
                                Color(0xFF0066FF),
                              ],
                              stops: [0.0, 0.5, 1.0],
                            ).createShader(b),
                            child: Text(
                              'KOKAL',
                              style: GoogleFonts.inter(
                                fontSize: fontSize,
                                fontWeight: FontWeight.w900,
                                letterSpacing: kokalSpacing,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ── Subtitle ─────────────────────────────────
                        _FadeSlide(
                          progress: _subtitleFade.value,
                          slideDistance: 16,
                          child: Text(
                            'Mobile Application Engineer',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              color: AppColors.textSecondary,
                              letterSpacing: 4,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ── Skills tags ───────────────────────────────
                        _FadeSlide(
                          progress: _tagFade.value,
                          slideDistance: 10,
                          child: _SkillTags(),
                        ),

                        SizedBox(height: isMobile ? 36 : 52),

                        // ── Progress bar ──────────────────────────────
                        _FadeSlide(
                          progress: _tagFade.value,
                          slideDistance: 12,
                          child: _ProgressBar(
                            progress: _progressFill.value,
                            width: progressWidth,
                          ),
                        ),
                      ],
                    );
                  },
                    ),
                  ),
                ],
              ),
            ),
          ),
          );
        },
      ),
    );
  }
}

// ── Clip reveal (slides text up into view from bottom) ────────────────────

class _ClipReveal extends StatelessWidget {
  final Widget child;
  final double progress;
  const _ClipReveal({required this.child, required this.progress});

  @override
  Widget build(BuildContext context) {
    final eased = Curves.easeOutCubic.transform(progress.clamp(0.0, 1.0));
    return ClipRect(
      child: Opacity(
        opacity: eased,
        child: Transform.translate(
          offset: Offset(0, 72 * (1.0 - eased)),
          child: child,
        ),
      ),
    );
  }
}

// ── Fade + slight slide up ─────────────────────────────────────────────────

class _FadeSlide extends StatelessWidget {
  final Widget child;
  final double progress;
  final double slideDistance;
  const _FadeSlide({
    required this.child,
    required this.progress,
    this.slideDistance = 16,
  });

  @override
  Widget build(BuildContext context) {
    final eased = Curves.easeOut.transform(progress.clamp(0.0, 1.0));
    return Opacity(
      opacity: eased,
      child: Transform.translate(
        offset: Offset(0, slideDistance * (1.0 - eased)),
        child: child,
      ),
    );
  }
}

// ── Sweep line ─────────────────────────────────────────────────────────────

class _SweepLine extends StatelessWidget {
  final double progress;
  final double width;
  const _SweepLine({required this.progress, this.width = 360.0});

  @override
  Widget build(BuildContext context) {
    final totalWidth = width;
    return SizedBox(
      width: totalWidth,
      height: 18,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Full track (dim)
          Container(
            height: 1,
            width: totalWidth,
            color: AppColors.cardBorder,
          ),
          // Active fill
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 1.5,
              width: totalWidth * progress,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0044AA),
                    AppColors.accent,
                    Color(0xFF80D8FF),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.7),
                    blurRadius: 14,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
          // Travelling glow dot at tip
          if (progress > 0.01 && progress < 0.99)
            Positioned(
              left: totalWidth * progress - 4,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.9),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Badge / eyebrow label ──────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 0.8,
          color: AppColors.accent.withOpacity(0.5),
        ),
        const SizedBox(width: 12),
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withOpacity(0.9),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Text(
          'PORTFOLIO',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 10,
            color: AppColors.accent,
            letterSpacing: 4,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 14),
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withOpacity(0.9),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 32,
          height: 0.8,
          color: AppColors.accent.withOpacity(0.5),
        ),
      ],
    );
  }
}

// ── Skill tags ─────────────────────────────────────────────────────────────

class _SkillTags extends StatelessWidget {
  static const _tags = ['Flutter', 'Android', 'Clean Architecture'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _tags.asMap().entries.map((e) {
        final isLast = e.key == _tags.length - 1;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              e.value,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.textMuted,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w400,
              ),
            ),
            if (!isLast)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  width: 3,
                  height: 3,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        );
      }).toList(),
    );
  }
}

// ── Progress bar ───────────────────────────────────────────────────────────

class _ProgressBar extends StatelessWidget {
  final double progress;
  final double width;
  const _ProgressBar({required this.progress, this.width = 260.0});

  @override
  Widget build(BuildContext context) {
    final pct = (progress * 100).round();
    final w = width;
    return SizedBox(
      width: w,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                pct < 100 ? 'Initializing...' : 'Ready',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  color: AppColors.textMuted,
                  letterSpacing: 1,
                ),
              ),
              Text(
                '$pct%',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  color: pct == 100
                      ? AppColors.accentBright
                      : AppColors.accent,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              // Track
              Container(
                height: 2,
                width: w,
                decoration: BoxDecoration(
                  color: AppColors.cardBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Fill
              AnimatedContainer(
                duration: Duration.zero,
                height: 2,
                width: w * progress,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.accentGlow, AppColors.accent],
                  ),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.6),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Grid painter ───────────────────────────────────────────────────────────

class _GridPainter extends CustomPainter {
  final double opacity;
  _GridPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity <= 0) return;
    final p = Paint()
      ..color = AppColors.cardBorder.withOpacity(opacity)
      ..strokeWidth = 0.5;
    const s = 64.0;
    for (double x = 0; x < size.width; x += s) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y < size.height; y += s) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => old.opacity != opacity;
}

// ── Ambient dots ───────────────────────────────────────────────────────────

class _AmbientDot {
  final double x, y, speed, size, phase, opacity;
  _AmbientDot(math.Random r)
      : x = r.nextDouble(),
        y = r.nextDouble(),
        speed = 0.25 + r.nextDouble() * 0.75,
        size = 0.8 + r.nextDouble() * 2.2,
        phase = r.nextDouble() * math.pi * 2,
        opacity = 0.15 + r.nextDouble() * 0.4;
}

class _AmbientDotPainter extends CustomPainter {
  final List<_AmbientDot> dots;
  final double t;
  final double opacity;
  _AmbientDotPainter({required this.dots, required this.t, required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity <= 0) return;
    for (final d in dots) {
      final drift = math.sin(t * 2 * math.pi * d.speed + d.phase) * 16;
      final x = d.x * size.width + drift;
      final y = (d.y * size.height + t * size.height * 0.05 * d.speed) %
          size.height;
      canvas.drawCircle(
        Offset(x, y),
        d.size,
        Paint()
          ..color = AppColors.accent.withOpacity(d.opacity * opacity * 0.5)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, d.size),
      );
    }
  }

  @override
  bool shouldRepaint(_AmbientDotPainter old) =>
      old.t != t || old.opacity != opacity;
}

// ── Burst particles ────────────────────────────────────────────────────────

class _BurstParticle {
  final double angle, speed, size, opacity, delay;
  _BurstParticle(math.Random r)
      : angle = r.nextDouble() * math.pi * 2,
        speed = 100 + r.nextDouble() * 320,
        size = 1.2 + r.nextDouble() * 3.5,
        opacity = 0.4 + r.nextDouble() * 0.6,
        delay = r.nextDouble() * 0.25;
}

class _BurstPainter extends CustomPainter {
  final List<_BurstParticle> particles;
  final double progress;
  _BurstPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    for (final p in particles) {
      final t = ((progress - p.delay) / (1.0 - p.delay)).clamp(0.0, 1.0);
      if (t <= 0) continue;
      final eased = Curves.easeOut.transform(t);
      final dist = p.speed * eased;
      final pos = Offset(
        cx + math.cos(p.angle) * dist,
        cy + math.sin(p.angle) * dist,
      );
      final fade = (1.0 - t * 0.85).clamp(0.0, 1.0);
      final r = p.size * fade;
      canvas.drawCircle(
        pos,
        r,
        Paint()
          ..color = AppColors.accent.withOpacity(p.opacity * fade)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, r),
      );
    }
  }

  @override
  bool shouldRepaint(_BurstPainter old) => old.progress != progress;
}
