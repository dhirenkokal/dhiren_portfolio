import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/about/presentation/pages/about_page.dart';
import '../features/experience/presentation/pages/experience_page.dart';
import '../features/skills/presentation/pages/skills_page.dart';
import '../features/projects/presentation/pages/projects_page.dart';
import '../features/contact/presentation/pages/contact_page.dart';
import '../core/widgets/scaffold/portfolio_scaffold.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => PortfolioScaffold(child: child),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => _fadeTransition(
            state,
            const HomePage(),
          ),
        ),
        GoRoute(
          path: '/about',
          pageBuilder: (context, state) => _fadeTransition(
            state,
            const AboutPage(),
          ),
        ),
        GoRoute(
          path: '/experience',
          pageBuilder: (context, state) => _fadeTransition(
            state,
            const ExperiencePage(),
          ),
        ),
        GoRoute(
          path: '/skills',
          pageBuilder: (context, state) => _fadeTransition(
            state,
            const SkillsPage(),
          ),
        ),
        GoRoute(
          path: '/projects',
          pageBuilder: (context, state) => _fadeTransition(
            state,
            const ProjectsPage(),
          ),
        ),
        GoRoute(
          path: '/contact',
          pageBuilder: (context, state) => _fadeTransition(
            state,
            const ContactPage(),
          ),
        ),
      ],
    ),
  ],
);

CustomTransitionPage<void> _fadeTransition(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 600),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ),
        child: child,
      );
    },
  );
}
