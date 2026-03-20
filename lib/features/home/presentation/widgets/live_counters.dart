import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class LiveCounters extends StatefulWidget {
  const LiveCounters({super.key});

  @override
  State<LiveCounters> createState() => _LiveCountersState();
}

class _LiveCountersState extends State<LiveCounters>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  bool _started = false;

  final List<_CounterData> _counters = const [
    _CounterData(
      end: 2,
      suffix: '+',
      label: 'YEARS EXPERIENCE',
      icon: Icons.timeline_rounded,
    ),
    _CounterData(
      end: 3,
      suffix: '',
      label: 'COMPANIES',
      icon: Icons.business_rounded,
    ),
    _CounterData(
      end: 747,
      suffix: 'K+',
      label: 'LINES OF FLUTTER CODE',
      icon: Icons.code_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
  }

  void _start() {
    if (!_started) {
      _started = true;
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) _ctrl.forward();
      });
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return VisibilityDetector(
      key: const Key('live-counters'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.3) _start();
      },
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _counters
                  .asMap()
                  .entries
                  .map((e) => _CounterCard(
                        data: e.value,
                        anim: _anim,
                        delay: e.key * 200,
                        isMobile: true,
                      ))
                  .toList(),
            )
          : IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _counters
                    .asMap()
                    .entries
                    .expand((e) => [
                          Expanded(
                            child: _CounterCard(
                              data: e.value,
                              anim: _anim,
                              delay: e.key * 200,
                              isMobile: false,
                            ),
                          ),
                          if (e.key < _counters.length - 1)
                            const SizedBox(width: 20),
                        ])
                    .toList(),
              ),
            ),
    );
  }
}

class _CounterCard extends StatefulWidget {
  final _CounterData data;
  final Animation<double> anim;
  final int delay;
  final bool isMobile;
  const _CounterCard({required this.data, required this.anim, required this.delay, this.isMobile = false});

  @override
  State<_CounterCard> createState() => _CounterCardState();
}

class _CounterCardState extends State<_CounterCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = widget.isMobile;

    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedBuilder(
        animation: widget.anim,
        builder: (context, _) {
          final value =
              (widget.data.end * widget.anim.value).round();
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: isMobile
                ? const EdgeInsets.symmetric(vertical: 6)
                : EdgeInsets.zero,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: _hovered
                  ? AppColors.cardBackground
                  : AppColors.cardBackground.withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _hovered
                    ? AppColors.accent.withOpacity(0.4)
                    : AppColors.cardBorder,
                width: 1,
              ),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.12),
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  widget.data.icon,
                  color: AppColors.accent.withOpacity(0.8),
                  size: isMobile ? 20 : 24,
                ),
                const SizedBox(height: 12),
                Text(
                  '$value${widget.data.suffix}',
                  style: isMobile
                      ? AppTextStyles.counterValueMobile
                      : AppTextStyles.counterValue,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  widget.data.label,
                  style: AppTextStyles.counterLabel.copyWith(
                    fontSize: isMobile ? 10 : 12,
                    letterSpacing: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ).animate(delay: widget.delay.ms).fadeIn(duration: 600.ms).slideY(
                begin: 0.3,
                end: 0,
                curve: Curves.easeOutCubic,
                duration: 600.ms,
              );
        },
      ),
    );
  }
}

// Simple visibility detector implementation
class VisibilityDetector extends StatefulWidget {
  final Widget child;
  final void Function(VisibilityInfo) onVisibilityChanged;
  const VisibilityDetector({
    required super.key,
    required this.child,
    required this.onVisibilityChanged,
  });

  @override
  State<VisibilityDetector> createState() => _VisibilityDetectorState();
}

class _VisibilityDetectorState extends State<VisibilityDetector> {
  bool _triggered = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_triggered && mounted) {
        _triggered = true;
        widget.onVisibilityChanged(VisibilityInfo(visibleFraction: 1.0));
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class VisibilityInfo {
  final double visibleFraction;
  const VisibilityInfo({required this.visibleFraction});
}

class _CounterData {
  final int end;
  final String suffix;
  final String label;
  final IconData icon;
  const _CounterData({
    required this.end,
    required this.suffix,
    required this.label,
    required this.icon,
  });
}
