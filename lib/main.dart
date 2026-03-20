import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/providers/theme_notifier.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/cursor/glowing_orb_cursor.dart';
import 'core/widgets/preloader/cinematic_preloader.dart';
import 'core/widgets/theme/theme_circle_animation.dart';
import 'router/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  bool _showPreloader = true;

  void _onPreloaderComplete() {
    setState(() => _showPreloader = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_showPreloader) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: CinematicPreloader(onComplete: _onPreloaderComplete),
      );
    }

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, themeMode, _) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Dhiren Kokal — Portfolio',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeMode,
        routerConfig: appRouter,
        builder: (context, child) => ThemeCircleAnimation(
          child: GlowingOrbCursor(
            child: child ?? const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
