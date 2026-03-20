import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_text_styles.dart';
import '../../providers/theme_notifier.dart';
import '../../theme/app_color_tokens.dart';
import '../theme/theme_circle_animation.dart';

class PortfolioScaffold extends StatefulWidget {
  final Widget child;
  const PortfolioScaffold({super.key, required this.child});

  @override
  State<PortfolioScaffold> createState() => _PortfolioScaffoldState();
}

class _PortfolioScaffoldState extends State<PortfolioScaffold> {
  bool _isScrolled = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<_NavItem> _navItems = const [
    _NavItem(label: 'Home',       path: '/',           icon: Icons.home_rounded),
    _NavItem(label: 'About',      path: '/about',      icon: Icons.person_rounded),
    _NavItem(label: 'Experience', path: '/experience', icon: Icons.work_rounded),
    _NavItem(label: 'Skills',     path: '/skills',     icon: Icons.code_rounded),
    _NavItem(label: 'Projects',   path: '/projects',   icon: Icons.rocket_launch_rounded),
    _NavItem(label: 'Contact',    path: '/contact',    icon: Icons.mail_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final location = GoRouterState.of(context).uri.toString();
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: colors.background,
      drawer: isMobile
          ? _SideDrawer(navItems: _navItems, location: location)
          : null,
      body: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          final scrolled = n.metrics.pixels > 20;
          if (scrolled != _isScrolled) setState(() => _isScrolled = scrolled);
          return false;
        },
        child: Stack(
          children: [
            if (isMobile)
              RefreshIndicator(
                onRefresh: () async {
                  final location = GoRouterState.of(context).uri.toString();
                  context.go(location);
                },
                color: colors.accent,
                backgroundColor: colors.cardBackground,
                strokeWidth: 2.5,
                displacement: 80,
                child: widget.child,
              )
            else
              widget.child,
            // Navbar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: _isScrolled
                      ? colors.backgroundSecondary.withOpacity(0.95)
                      : Colors.transparent,
                  border: _isScrolled
                      ? Border(
                          bottom: BorderSide(
                            color: colors.cardBorder,
                            width: 1,
                          ),
                        )
                      : null,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : 40,
                    vertical: isMobile ? 14 : 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo
                      _Logo(),
                      if (!isMobile) ...[
                        // Nav Links
                        Row(
                          children: _navItems.map((item) {
                            final isActive = location == item.path ||
                                (item.path == '/' && location == '');
                            return _NavLink(
                              item: item,
                              isActive: isActive,
                            );
                          }).toList(),
                        ),
                        // Theme toggle + CTA
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const _ThemeToggleButton(),
                            const SizedBox(width: 12),
                            _HireMeButton(),
                          ],
                        ),
                      ] else
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const _ThemeToggleButton(),
                            _MobileMenuButton(
                              onTap: () => _scaffoldKey.currentState?.openDrawer(),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 800.ms, delay: 200.ms)
                  .slideY(begin: -0.5, end: 0, curve: Curves.easeOutCubic),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Theme Toggle Button ────────────────────────────────────────────────────────

class _ThemeToggleButton extends StatefulWidget {
  const _ThemeToggleButton();

  @override
  State<_ThemeToggleButton> createState() => _ThemeToggleButtonState();
}

class _ThemeToggleButtonState extends State<_ThemeToggleButton> {
  bool _hovered = false;
  final _buttonKey = GlobalKey();

  void _onTap(BuildContext outerContext, bool isDark) {
    final box =
        _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    Offset? origin;
    RRect? exclusionRRect;

    if (box != null && box.hasSize) {
      // Expand from the sun side (light→dark) or moon side (dark→light)
      final targetX = isDark
          ? box.size.width * 0.25   // going to light: expand from left (sun)
          : box.size.width * 0.75;  // going to dark:  expand from right (moon)
      origin =
          box.localToGlobal(Offset(targetX, box.size.height / 2));

      final topLeft = box.localToGlobal(Offset.zero);
      exclusionRRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
            topLeft.dx, topLeft.dy, box.size.width, box.size.height),
        Radius.circular(box.size.height / 2),
      );
    }

    ThemeCircleAnimation.of(outerContext)?.toggle(
      onToggle: () => themeNotifier.value =
          isDark ? ThemeMode.light : ThemeMode.dark,
      origin: origin,
      isReverse: isDark,
      exclusionRRect: exclusionRRect,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, mode, __) {
        final isDark = mode == ThemeMode.dark;
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: () => _onTap(context, isDark),
            child: AnimatedContainer(
              key: _buttonKey,
              duration: const Duration(milliseconds: 200),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: _hovered
                    ? LinearGradient(colors: colors.heroGradient)
                    : null,
                color: _hovered ? null : colors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _hovered
                      ? colors.accent.withOpacity(0.0)
                      : colors.cardBorder,
                  width: 1,
                ),
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                          color: colors.accent.withOpacity(0.3),
                          blurRadius: 16,
                          spreadRadius: 1,
                        ),
                      ]
                    : [],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: Icon(
                  isDark
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  key: ValueKey(isDark),
                  color: _hovered ? Colors.white : colors.accent,
                  size: 18,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Logo ──────────────────────────────────────────────────────────────────────

class _Logo extends StatefulWidget {
  @override
  State<_Logo> createState() => _LogoState();
}

class _LogoState extends State<_Logo> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go('/'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: colors.heroGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: _hovered
                      ? [
                          BoxShadow(
                            color: colors.accent.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 2,
                          )
                        ]
                      : [],
                ),
                child: const Center(
                  child: Text(
                    'DK',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Desktop nav link ──────────────────────────────────────────────────────────

class _NavLink extends StatefulWidget {
  final _NavItem item;
  final bool isActive;
  const _NavLink({required this.item, required this.isActive});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.go(widget.item.path),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: widget.isActive
                    ? AppTextStyles.navLinkActive.copyWith(color: colors.accent)
                    : _hovered
                        ? AppTextStyles.navLink.copyWith(color: colors.textPrimary)
                        : AppTextStyles.navLink.copyWith(color: colors.textSecondary),
                child: Text(widget.item.label),
              ),
              const SizedBox(height: 3),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: widget.isActive ? 20 : 0,
                decoration: BoxDecoration(
                  color: colors.accent,
                  borderRadius: BorderRadius.circular(1),
                  boxShadow: [
                    BoxShadow(
                      color: colors.accent.withOpacity(0.6),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Hire Me button ────────────────────────────────────────────────────────────

class _HireMeButton extends StatefulWidget {
  @override
  State<_HireMeButton> createState() => _HireMeButtonState();
}

class _HireMeButtonState extends State<_HireMeButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go('/contact'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors.heroGradient),
            borderRadius: BorderRadius.circular(24),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: colors.accent.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: colors.accent.withOpacity(0.15),
                      blurRadius: 10,
                    ),
                  ],
          ),
          child: Text(
            'Hire Me',
            style: AppTextStyles.buttonLabel.copyWith(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Mobile hamburger ──────────────────────────────────────────────────────────

class _MobileMenuButton extends StatelessWidget {
  final VoidCallback onTap;
  const _MobileMenuButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return IconButton(
      onPressed: onTap,
      icon: Icon(Icons.menu_rounded, color: colors.textPrimary),
    );
  }
}

// ── Side Drawer ───────────────────────────────────────────────────────────────

class _SideDrawer extends StatelessWidget {
  final List<_NavItem> navItems;
  final String location;
  const _SideDrawer({required this.navItems, required this.location});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Drawer(
      backgroundColor: colors.backgroundSecondary,
      width: 280,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 16, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo badge
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: colors.heroGradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: colors.accent.withOpacity(0.4),
                              blurRadius: 12,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'DK',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dhiren Kokal',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Mobile Engineer',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: colors.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Close button
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close_rounded,
                      color: colors.textMuted,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              color: colors.cardBorder,
            ),
            const SizedBox(height: 12),

            // Nav items
            ...navItems.map((item) {
              final isActive = location == item.path ||
                  (item.path == '/' && location == '');
              return _DrawerNavItem(
                item: item,
                isActive: isActive,
                onTap: () {
                  Navigator.pop(context);
                  context.go(item.path);
                },
              );
            }),

            const Spacer(),

            // Footer
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 1, color: colors.cardBorder),
                  const SizedBox(height: 16),
                  Text(
                    'Available for Work',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: colors.accent,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'dhirenkokal@gmail.com',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: colors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerNavItem extends StatefulWidget {
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;
  const _DrawerNavItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_DrawerNavItem> createState() => _DrawerNavItemState();
}

class _DrawerNavItemState extends State<_DrawerNavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: widget.isActive
                ? colors.accent.withOpacity(0.12)
                : _hovered
                    ? colors.cardBackground.withOpacity(0.5)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: widget.isActive
                ? Border.all(color: colors.accent.withOpacity(0.3), width: 1)
                : null,
          ),
          child: Row(
            children: [
              // Icon
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: widget.isActive
                      ? colors.accent.withOpacity(0.2)
                      : colors.cardBackground.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  widget.item.icon,
                  size: 18,
                  color: widget.isActive
                      ? colors.accent
                      : _hovered
                          ? colors.textPrimary
                          : colors.textMuted,
                ),
              ),
              const SizedBox(width: 14),
              // Label
              Text(
                widget.item.label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: widget.isActive
                      ? colors.accent
                      : _hovered
                          ? colors.textPrimary
                          : colors.textSecondary,
                  fontWeight:
                      widget.isActive ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              // Active indicator
              if (widget.isActive)
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: colors.accent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colors.accent.withOpacity(0.6),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Data ──────────────────────────────────────────────────────────────────────

class _NavItem {
  final String label;
  final String path;
  final IconData icon;
  const _NavItem({required this.label, required this.path, required this.icon});
}
