import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/hero_section.dart';
import '../widgets/live_counters.dart';
import '../widgets/mesh_background.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollCtrl = ScrollController();
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(() {
      setState(() => _scrollOffset = _scrollCtrl.offset);
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth < 1100;
    final hPad = isMobile ? 20.0 : isTablet ? 32.0 : screenWidth * 0.08;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Animated mesh background (full screen, fixed)
          Positioned.fill(
            child: MeshBackground(scrollOffset: _scrollOffset),
          ),

          // Scrollable content
          SingleChildScrollView(
            controller: _scrollCtrl,
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Hero Section ──────────────────────────────────────
                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: screenHeight),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      hPad,
                      isMobile ? 88 : isTablet ? 100 : 120,
                      hPad,
                      isMobile ? 40 : 60,
                    ),
                    child: const HeroSection(),
                  ),
                ),

                // ── Divider ───────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: hPad),
                  child: _GlowDivider(),
                ),

                // ── Live Counters ─────────────────────────────────────
                Padding(
                  padding: EdgeInsets.fromLTRB(hPad, 60, hPad, 80),
                  child: const LiveCounters(),
                ),

                // ── Scroll hint ───────────────────────────────────────
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 48),
                    child: _ScrollHint(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            AppColors.accent.withOpacity(0.3),
            AppColors.accent.withOpacity(0.6),
            AppColors.accent.withOpacity(0.3),
            Colors.transparent,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.2),
            blurRadius: 10,
          ),
        ],
      ),
    );
  }
}

class _ScrollHint extends StatefulWidget {
  @override
  State<_ScrollHint> createState() => _ScrollHintState();
}

class _ScrollHintState extends State<_ScrollHint>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) => Column(
        children: [
          Text(
            'SCROLL DOWN',
            style: TextStyle(
              color: AppColors.textMuted.withOpacity(0.4 + 0.3 * _anim.value),
              fontSize: 10,
              letterSpacing: 3,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Transform.translate(
            offset: Offset(0, 4 * _anim.value),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.accent.withOpacity(0.4 + 0.4 * _anim.value),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
