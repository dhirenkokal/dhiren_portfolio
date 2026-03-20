import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_color_tokens.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColorTokens.dark.background,
        colorScheme: ColorScheme.dark(
          primary: AppColorTokens.dark.accent,
          secondary: AppColorTokens.dark.accentGlow,
          surface: AppColorTokens.dark.cardBackground,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: AppColorTokens.dark.textPrimary,
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        extensions: [AppColorTokens.dark],
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
      );

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFE8EFFF),
        colorScheme: ColorScheme.light(
          primary: AppColorTokens.light.accent,
          secondary: AppColorTokens.light.accentGlow,
          surface: AppColorTokens.light.cardBackground,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: AppColorTokens.light.textPrimary,
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        extensions: [AppColorTokens.light],
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
      );
}
