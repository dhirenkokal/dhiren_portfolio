import 'package:flutter/material.dart';

/// Custom color tokens as a ThemeExtension — works with Flutter's theme system
/// and automatically lerps during theme transitions.
class AppColorTokens extends ThemeExtension<AppColorTokens> {
  final Color background;
  final Color backgroundSecondary;
  final Color cardBackground;
  final Color cardBorder;
  final Color accent;
  final Color accentBright;
  final Color accentGlow;
  final Color accentDim;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final List<Color> heroGradient;
  final List<Color> meshGradient;
  final bool isDark;

  const AppColorTokens({
    required this.background,
    required this.backgroundSecondary,
    required this.cardBackground,
    required this.cardBorder,
    required this.accent,
    required this.accentBright,
    required this.accentGlow,
    required this.accentDim,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.heroGradient,
    required this.meshGradient,
    required this.isDark,
  });

  // ── Dark palette (deep space + electric blue) ────────────────────────────
  static AppColorTokens get dark => const AppColorTokens(
        background: Color(0xFF050A14),
        backgroundSecondary: Color(0xFF0A1628),
        cardBackground: Color(0xFF0D1929),
        cardBorder: Color(0xFF1A2840),
        accent: Color(0xFF00B4FF),
        accentBright: Color(0xFF40CFFF),
        accentGlow: Color(0xFF0066FF),
        accentDim: Color(0xFF003366),
        textPrimary: Color(0xFFFFFFFF),
        textSecondary: Color(0xFFB0B8C8),
        textMuted: Color(0xFF5A6478),
        heroGradient: [Color(0xFF00B4FF), Color(0xFF0066FF)],
        meshGradient: [
          Color(0xFF050A14),
          Color(0xFF071220),
          Color(0xFF0A1628),
          Color(0xFF050A14),
        ],
        isDark: true,
      );

  // ── Light palette (electric sky blue — distinct, not white) ─────────────
  static AppColorTokens get light => const AppColorTokens(
        background: Color(0xFFE8EFFF),       // clear sky blue — not white
        backgroundSecondary: Color(0xFFDAE3FF), // navbar on scroll
        cardBackground: Color(0xFFF6F9FF),   // near-white card on blue bg
        cardBorder: Color(0xFFC0CFEE),
        accent: Color(0xFF0070CC),
        accentBright: Color(0xFF3EAAFF),
        accentGlow: Color(0xFF003EBF),
        accentDim: Color(0xFFD6E8FF),
        textPrimary: Color(0xFF0A1628),
        textSecondary: Color(0xFF364B6A),
        textMuted: Color(0xFF7A8EAA),
        heroGradient: [Color(0xFF0090E0), Color(0xFF0044CC)],
        meshGradient: [
          Color(0xFFE8EFFF),
          Color(0xFFDAE3FF),
          Color(0xFFD0DCFF),
          Color(0xFFE8EFFF),
        ],
        isDark: false,
      );

  @override
  AppColorTokens copyWith({
    Color? background,
    Color? backgroundSecondary,
    Color? cardBackground,
    Color? cardBorder,
    Color? accent,
    Color? accentBright,
    Color? accentGlow,
    Color? accentDim,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    List<Color>? heroGradient,
    List<Color>? meshGradient,
    bool? isDark,
  }) =>
      AppColorTokens(
        background: background ?? this.background,
        backgroundSecondary: backgroundSecondary ?? this.backgroundSecondary,
        cardBackground: cardBackground ?? this.cardBackground,
        cardBorder: cardBorder ?? this.cardBorder,
        accent: accent ?? this.accent,
        accentBright: accentBright ?? this.accentBright,
        accentGlow: accentGlow ?? this.accentGlow,
        accentDim: accentDim ?? this.accentDim,
        textPrimary: textPrimary ?? this.textPrimary,
        textSecondary: textSecondary ?? this.textSecondary,
        textMuted: textMuted ?? this.textMuted,
        heroGradient: heroGradient ?? this.heroGradient,
        meshGradient: meshGradient ?? this.meshGradient,
        isDark: isDark ?? this.isDark,
      );

  @override
  AppColorTokens lerp(AppColorTokens? other, double t) {
    if (other == null) return this;
    return AppColorTokens(
      background: Color.lerp(background, other.background, t)!,
      backgroundSecondary:
          Color.lerp(backgroundSecondary, other.backgroundSecondary, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentBright: Color.lerp(accentBright, other.accentBright, t)!,
      accentGlow: Color.lerp(accentGlow, other.accentGlow, t)!,
      accentDim: Color.lerp(accentDim, other.accentDim, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      heroGradient: [
        Color.lerp(heroGradient[0], other.heroGradient[0], t)!,
        Color.lerp(heroGradient[1], other.heroGradient[1], t)!,
      ],
      meshGradient: [
        Color.lerp(meshGradient[0], other.meshGradient[0], t)!,
        Color.lerp(meshGradient[1], other.meshGradient[1], t)!,
        Color.lerp(meshGradient[2], other.meshGradient[2], t)!,
        Color.lerp(meshGradient[3], other.meshGradient[3], t)!,
      ],
      isDark: t < 0.5 ? isDark : other.isDark,
    );
  }
}

/// Convenience accessor — use `context.appColors.accent` in any widget.
extension AppColorTokensX on BuildContext {
  AppColorTokens get appColors =>
      Theme.of(this).extension<AppColorTokens>()!;
}
