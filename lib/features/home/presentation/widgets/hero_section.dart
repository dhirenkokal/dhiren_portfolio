import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_color_tokens.dart';
import 'magnetic_button.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 768;
    final isTablet = w < 1100;

    return SizedBox(
      width: double.infinity,
      child: isMobile
          ? _MobileHero()
          : _DesktopHero(isTablet: isTablet),
    );
  }
}

class _DesktopHero extends StatelessWidget {
  final bool isTablet;
  const _DesktopHero({required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: isTablet ? 7 : 6,
          child: const _HeroContent(isMobile: false),
        ),
        Expanded(
          flex: isTablet ? 3 : 4,
          child: _HeroVisual(size: isTablet ? 240 : 340),
        ),
      ],
    );
  }
}

class _MobileHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _HeroVisual(size: 200),
        const SizedBox(height: 32),
        _HeroContent(isMobile: true),
      ],
    );
  }
}

class _HeroContent extends StatelessWidget {
  final bool isMobile;
  const _HeroContent({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final w = MediaQuery.of(context).size.width;
    final isTablet = w < 1100 && w >= 768;
    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // Tag line
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: colors.accent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border:
                Border.all(color: colors.accent.withOpacity(0.3), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: colors.accent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colors.accent.withOpacity(0.8),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Available for Work',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colors.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms)
            .slideY(begin: -0.3, end: 0, curve: Curves.easeOutCubic),

        const SizedBox(height: 24),

        // Name
        _GradientText(
          isMobile: isMobile,
          isTablet: isTablet,
        )
            .animate()
            .fadeIn(duration: 700.ms, delay: 150.ms)
            .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),

        const SizedBox(height: 16),

        // Title
        Text(
          'Mobile Application Engineer',
          style: (isMobile
                  ? AppTextStyles.heroTitleMobile
                  : AppTextStyles.heroTitle)
              .copyWith(color: colors.accent),
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 300.ms)
            .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),

        const SizedBox(height: 12),

        // Subtitle
        Text(
          'Flutter  ·  Android  ·  Clean Architecture',
          style: AppTextStyles.heroSubtitle
              .copyWith(color: colors.textSecondary),
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 400.ms)
            .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),

        const SizedBox(height: 20),

        // Summary
        _HeroSummary(isMobile: isMobile)
            .animate()
            .fadeIn(duration: 600.ms, delay: 500.ms),

        const SizedBox(height: 40),

        // CTAs
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          children: [
            MagneticButton(
              label: 'Download CV',
              icon: Icons.download_rounded,
              variant: MagneticButtonVariant.primary,
              onTap: () async {
                final uri = Uri.parse('mailto:dhirenkokal@gmail.com?subject=CV Request');
                if (await canLaunchUrl(uri)) launchUrl(uri);
              },
            ),
            MagneticButton(
              label: 'Contact Me',
              icon: Icons.arrow_forward_rounded,
              variant: MagneticButtonVariant.outline,
              onTap: () async {
                final uri = Uri.parse('mailto:dhirenkokal@gmail.com');
                if (await canLaunchUrl(uri)) launchUrl(uri);
              },
            ),
          ],
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 650.ms)
            .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),

        const SizedBox(height: 48),

        // Social links
        _SocialLinks(isMobile: isMobile)
            .animate()
            .fadeIn(duration: 600.ms, delay: 800.ms),
      ],
    );
  }
}

class _HeroSummary extends StatelessWidget {
  final bool isMobile;
  const _HeroSummary({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final align = isMobile ? TextAlign.center : TextAlign.start;
    final crossAxis =
        isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    final base = AppTextStyles.bodyMedium.copyWith(color: colors.textSecondary);
    final strong = base.copyWith(
      color: colors.textPrimary,
      fontWeight: FontWeight.w600,
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: Column(
        crossAxisAlignment: crossAxis,
        children: [
          RichText(
            textAlign: align,
            text: TextSpan(
              style: base,
              children: [
                const TextSpan(text: 'I build '),
                TextSpan(text: 'cross-platform mobile apps', style: strong),
                const TextSpan(
                    text:
                        ' that are fast, maintainable, and production-ready. Proficient in '),
                _codeChip('Flutter', colors),
                const TextSpan(text: ' and native '),
                _codeChip('Android', colors),
                const TextSpan(text: ' ('),
                _codeChip('Kotlin', colors),
                const TextSpan(text: ' + '),
                _codeChip('Jetpack Compose', colors),
                TextSpan(text: "), I've architected a "),
                TextSpan(text: '747K+ line', style: strong),
                const TextSpan(
                    text: ' IoT platform from scratch — spanning '),
                TextSpan(text: 'BLE device control', style: strong),
                const TextSpan(text: ', real-time dashboards, and '),
                TextSpan(text: 'AI-assisted', style: strong),
                const TextSpan(text: ' development workflows.'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Tech tag row
          Wrap(
            alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
            spacing: 8,
            runSpacing: 8,
            children: const [
              'Flutter',
              'Kotlin',
              'Jetpack Compose',
              'Clean Architecture',
              'BLE / IoT',
              'Firebase',
            ].map((tag) => _TechTag(label: tag)).toList(),
          ),
        ],
      ),
    );
  }
}

InlineSpan _codeChip(String label, AppColorTokens colors) {
  return WidgetSpan(
    alignment: PlaceholderAlignment.middle,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: colors.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5),
        border:
            Border.all(color: colors.accent.withOpacity(0.25), width: 1),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(
          fontFamily: 'JetBrainsMono',
          fontSize: 13,
          color: colors.textPrimary,
          fontWeight: FontWeight.w500,
          height: 1,
        ),
      ),
    ),
  );
}

class _TechTag extends StatelessWidget {
  final String label;
  const _TechTag({required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors.accent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
        border:
            Border.all(color: colors.accent.withOpacity(0.2), width: 1),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(
          fontSize: 12,
          color: colors.textSecondary,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _GradientText extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;
  const _GradientText({required this.isMobile, this.isTablet = false});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final style = isMobile
        ? AppTextStyles.heroNameMobile
        : isTablet
            ? AppTextStyles.heroName.copyWith(fontSize: 52, letterSpacing: -1)
            : AppTextStyles.heroName;

    // Dark theme: white → light-blue gradient
    // Light theme: dark-navy → deep-blue gradient (visible on light bg)
    final gradientColors = colors.isDark
        ? [Colors.white, const Color(0xFFB8E0FF)]
        : [const Color(0xFF0A1628), colors.accentGlow];

    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => LinearGradient(
        colors: gradientColors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Text(
        'DHIREN\nKOKAL',
        style: style,
        textAlign: isMobile ? TextAlign.center : TextAlign.start,
      ),
    );
  }
}

class _HeroVisual extends StatefulWidget {
  final double size;
  const _HeroVisual({this.size = 340});

  @override
  State<_HeroVisual> createState() => _HeroVisualState();
}

class _HeroVisualState extends State<_HeroVisual>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatCtrl;
  late Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -12, end: 12).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return AnimatedBuilder(
      animation: _floatAnim,
      builder: (context, _) => Transform.translate(
        offset: Offset(0, _floatAnim.value),
        child: Center(
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  painter: _AvatarPainter(
                    accent: colors.accent,
                    cardBackground: colors.cardBackground,
                    backgroundSecondary: colors.backgroundSecondary,
                  ),
                  size: Size(widget.size, widget.size),
                ),
                ClipOval(
                  child: Image.asset(
                    'assets/images/luffy.jpeg',
                    width: widget.size * 0.76,
                    height: widget.size * 0.76,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          )
              .animate(delay: 300.ms)
              .fadeIn(duration: 800.ms)
              .scale(
                begin: const Offset(0.85, 0.85),
                end: const Offset(1, 1),
                curve: Curves.easeOutCubic,
              ),
        ),
      ),
    );
  }
}

class _AvatarPainter extends CustomPainter {
  final Color accent;
  final Color cardBackground;
  final Color backgroundSecondary;

  const _AvatarPainter({
    required this.accent,
    required this.cardBackground,
    required this.backgroundSecondary,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    // Outer glow ring
    canvas.drawCircle(
      Offset(cx, cy),
      r - 10,
      Paint()
        ..color = accent.withOpacity(0.08)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30),
    );

    // Orbit ring
    canvas.drawCircle(
      Offset(cx, cy),
      r * 0.92,
      Paint()
        ..color = accent.withOpacity(0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // Orbit dots
    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * math.pi;
      final dx = cx + r * 0.92 * math.cos(angle);
      final dy = cy + r * 0.92 * math.sin(angle);
      canvas.drawCircle(
        Offset(dx, dy),
        3,
        Paint()..color = accent.withOpacity(0.5),
      );
    }

    // Main avatar circle
    final avatarPaint = Paint()
      ..shader = RadialGradient(
        colors: [cardBackground, backgroundSecondary],
        center: Alignment.topLeft,
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.8));

    canvas.drawCircle(Offset(cx, cy), r * 0.78, avatarPaint);

    // Glowing border
    canvas.drawCircle(
      Offset(cx, cy),
      r * 0.78,
      Paint()
        ..color = accent.withOpacity(0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
  }

  @override
  bool shouldRepaint(_AvatarPainter old) =>
      old.accent != accent ||
      old.cardBackground != cardBackground ||
      old.backgroundSecondary != backgroundSecondary;
}

class _SocialLinks extends StatelessWidget {
  final bool isMobile;
  const _SocialLinks({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        _SocialIcon(
          icon: Icons.email_rounded,
          label: 'Email',
          url: 'mailto:dhirenkokal@gmail.com',
        ),
        const SizedBox(width: 16),
        _SocialIcon(
          icon: Icons.code_rounded,
          label: 'GitHub',
          url: 'https://github.com/dhirenkokal',
        ),
        const SizedBox(width: 16),
        _SocialIcon(
          icon: Icons.phone_rounded,
          label: 'Phone',
          url: 'tel:+919172185008',
        ),
      ],
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final IconData icon;
  final String label;
  final String url;
  const _SocialIcon({
    required this.icon,
    required this.label,
    required this.url,
  });

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(widget.url);
          if (await canLaunchUrl(uri)) launchUrl(uri);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _hovered
                ? colors.accent.withOpacity(0.15)
                : colors.cardBackground.withOpacity(0.6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered
                  ? colors.accent.withOpacity(0.5)
                  : colors.cardBorder,
              width: 1,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: colors.accent.withOpacity(0.2),
                      blurRadius: 12,
                    ),
                  ]
                : [],
          ),
          child: Icon(
            widget.icon,
            color: _hovered ? colors.accent : colors.textMuted,
            size: 20,
          ),
        ),
      ),
    );
  }
}
