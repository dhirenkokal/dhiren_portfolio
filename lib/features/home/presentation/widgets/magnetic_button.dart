import 'package:flutter/material.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_color_tokens.dart';

enum MagneticButtonVariant { primary, outline }

class MagneticButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final MagneticButtonVariant variant;
  final IconData? icon;

  const MagneticButton({
    super.key,
    required this.label,
    required this.onTap,
    this.variant = MagneticButtonVariant.primary,
    this.icon,
  });

  @override
  State<MagneticButton> createState() => _MagneticButtonState();
}

class _MagneticButtonState extends State<MagneticButton>
    with SingleTickerProviderStateMixin {
  Offset _offset = Offset.zero;
  bool _hovered = false;
  late AnimationController _resetCtrl;
  late Animation<Offset> _resetAnim;
  Offset _lastOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _resetCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _resetAnim = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _resetCtrl,
      curve: Curves.easeOutCubic,
    ));
    _resetAnim.addListener(() {
      setState(() => _offset = _resetAnim.value);
    });
  }

  void _onHover(PointerEvent event) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    final localPos = box.globalToLocal(event.position);
    final center = Offset(box.size.width / 2, box.size.height / 2);
    final delta = localPos - center;
    const magnetRadius = 80.0;
    const maxPull = 5.0;

    final distance = delta.distance;
    if (distance < magnetRadius) {
      final strength = 1.0 - (distance / magnetRadius);
      _lastOffset = Offset(
        delta.dx * strength * maxPull / box.size.width,
        delta.dy * strength * maxPull / box.size.height,
      );
      if (!_hovered) {
        setState(() {
          _hovered = true;
          _offset = _lastOffset;
        });
      } else {
        setState(() => _offset = _lastOffset);
      }
    } else if (_hovered) {
      _exitMagnetic();
    }
  }

  void _exitMagnetic() {
    _hovered = false;
    _resetAnim = Tween<Offset>(
      begin: _lastOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _resetCtrl,
      curve: Curves.easeOutCubic,
    ))
      ..addListener(() => setState(() => _offset = _resetAnim.value));
    _resetCtrl.forward(from: 0);
  }

  @override
  void dispose() {
    _resetCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isPrimary = widget.variant == MagneticButtonVariant.primary;
    // Primary button always has white text/icon (sits on gradient)
    // Outline button adapts to theme text color
    final contentColor = isPrimary ? Colors.white : colors.textPrimary;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: _onHover,
      onExit: (_) => _exitMagnetic(),
      child: Listener(
        onPointerHover: _onHover,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Transform.translate(
            offset: _offset * 6,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                gradient: isPrimary
                    ? LinearGradient(
                        colors: colors.heroGradient,
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      )
                    : null,
                color: isPrimary ? null : Colors.transparent,
                borderRadius: BorderRadius.circular(50),
                border: isPrimary
                    ? null
                    : Border.all(
                        color: _hovered
                            ? colors.accent
                            : colors.accent.withOpacity(0.5),
                        width: 1.5,
                      ),
                boxShadow: _hovered
                    ? isPrimary
                        ? [
                            BoxShadow(
                              color: colors.accent.withOpacity(0.45),
                              blurRadius: 30,
                              spreadRadius: 4,
                            ),
                            BoxShadow(
                              color: colors.accentGlow.withOpacity(0.2),
                              blurRadius: 60,
                              spreadRadius: 8,
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: colors.accent.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ]
                    : isPrimary
                        ? [
                            BoxShadow(
                              color: colors.accent.withOpacity(0.2),
                              blurRadius: 15,
                            ),
                          ]
                        : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      color: contentColor,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.label,
                    style: AppTextStyles.buttonLabel.copyWith(
                      color: contentColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
