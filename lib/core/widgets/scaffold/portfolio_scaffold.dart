import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

class PortfolioScaffold extends StatefulWidget {
  final Widget child;
  const PortfolioScaffold({super.key, required this.child});

  @override
  State<PortfolioScaffold> createState() => _PortfolioScaffoldState();
}

class _PortfolioScaffoldState extends State<PortfolioScaffold> {
  bool _isScrolled = false;

  final List<_NavItem> _navItems = const [
    _NavItem(label: 'Home', path: '/'),
    _NavItem(label: 'About', path: '/about'),
    _NavItem(label: 'Experience', path: '/experience'),
    _NavItem(label: 'Skills', path: '/skills'),
    _NavItem(label: 'Projects', path: '/projects'),
    _NavItem(label: 'Contact', path: '/contact'),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          final scrolled = n.metrics.pixels > 20;
          if (scrolled != _isScrolled) setState(() => _isScrolled = scrolled);
          return false;
        },
        child: Stack(
          children: [
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
                      ? AppColors.backgroundSecondary.withOpacity(0.95)
                      : Colors.transparent,
                  border: _isScrolled
                      ? const Border(
                          bottom: BorderSide(
                            color: AppColors.cardBorder,
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
                        // CTA
                        _HireMeButton(),
                      ] else
                        _MobileMenuButton(navItems: _navItems),
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

class _Logo extends StatefulWidget {
  @override
  State<_Logo> createState() => _LogoState();
}

class _LogoState extends State<_Logo> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
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
                    colors: AppColors.heroGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: _hovered
                      ? [
                          BoxShadow(
                            color: AppColors.accent.withOpacity(0.5),
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
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go(widget.item.path),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: (widget.isActive || _hovered)
                    ? AppTextStyles.navLinkActive
                    : AppTextStyles.navLink,
                child: Text(widget.item.label),
              ),
              const SizedBox(height: 3),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: widget.isActive ? 20 : (_hovered ? 10 : 0),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(1),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.6),
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

class _HireMeButton extends StatefulWidget {
  @override
  State<_HireMeButton> createState() => _HireMeButtonState();
}

class _HireMeButtonState extends State<_HireMeButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
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
            gradient: LinearGradient(
              colors: AppColors.heroGradient,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.15),
                      blurRadius: 10,
                    ),
                  ],
          ),
          child: Text(
            'Hire Me',
            style: AppTextStyles.buttonLabel.copyWith(fontSize: 13),
          ),
        ),
      ),
    );
  }
}

class _MobileMenuButton extends StatelessWidget {
  final List<_NavItem> navItems;
  const _MobileMenuButton({required this.navItems});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: AppColors.backgroundSecondary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => _MobileMenu(navItems: navItems),
        );
      },
      icon: const Icon(Icons.menu, color: AppColors.textPrimary),
    );
  }
}

class _MobileMenu extends StatelessWidget {
  final List<_NavItem> navItems;
  const _MobileMenu({required this.navItems});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: navItems
            .map((item) => ListTile(
                  title: Text(item.label, style: AppTextStyles.navLink),
                  onTap: () {
                    Navigator.pop(context);
                    context.go(item.path);
                  },
                ))
            .toList(),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final String path;
  const _NavItem({required this.label, required this.path});
}
