import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'circle_reveal_clipper.dart';

class ThemeCircleAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const ThemeCircleAnimation({
    required this.child,
    super.key,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeIn,
  });

  static ThemeCircleAnimationState? of(BuildContext context) {
    return context.findAncestorStateOfType<ThemeCircleAnimationState>();
  }

  @override
  ThemeCircleAnimationState createState() => ThemeCircleAnimationState();
}

class ThemeCircleAnimationState extends State<ThemeCircleAnimation>
    with SingleTickerProviderStateMixin {
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  late AnimationController _controller;
  late Animation<double> _animation;

  ui.Image? _capturedImage;
  Offset _animationOrigin = Offset.zero;
  bool _isAnimating = false;
  bool _isReversed = false;
  double _maxRadius = 0;
  double _exclusionRadius = 0;
  RRect? _exclusionRRect;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: widget.duration);
    _animation =
        CurvedAnimation(parent: _controller, curve: widget.curve);
  }

  @override
  void didUpdateWidget(ThemeCircleAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isAnimating) {
      if (widget.duration != oldWidget.duration) {
        _controller.duration = widget.duration;
      }
      if (widget.curve != oldWidget.curve) {
        _animation =
            CurvedAnimation(parent: _controller, curve: widget.curve);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _capturedImage?.dispose();
    super.dispose();
  }

  bool get isAnimating => _isAnimating;

  Future<ui.Image?> _captureScreen() async {
    try {
      final boundary = _repaintBoundaryKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final pixelRatio = MediaQuery.of(context).devicePixelRatio;
      return await boundary.toImage(pixelRatio: pixelRatio);
    } catch (e) {
      debugPrint('ThemeCircleAnimation: Error capturing screen: $e');
      return null;
    }
  }

  double _calculateMaxRadius(Size screenSize, Offset origin) {
    final corners = [
      Offset.zero,
      Offset(screenSize.width, 0),
      Offset(0, screenSize.height),
      Offset(screenSize.width, screenSize.height),
    ];
    return corners.map((c) => (origin - c).distance).reduce(max);
  }

  static Offset? originFromContext(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return null;
    return box.localToGlobal(
        Offset(box.size.width / 2, box.size.height / 2));
  }

  Future<void> toggleFromWidget({
    required BuildContext context,
    required VoidCallback onToggle,
    Duration? duration,
    Curve? curve,
    bool isReverse = false,
    double exclusionRadius = 0,
  }) {
    return toggle(
      onToggle: onToggle,
      origin: originFromContext(context),
      duration: duration,
      curve: curve,
      isReverse: isReverse,
      exclusionRadius: exclusionRadius,
    );
  }

  Future<void> toggle({
    required VoidCallback onToggle,
    Offset? origin,
    Duration? duration,
    Curve? curve,
    bool isReverse = false,
    double exclusionRadius = 0,
    RRect? exclusionRRect,
  }) async {
    if (_isAnimating) return;
    _isAnimating = true;

    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) {
      _isAnimating = false;
      return;
    }

    final image = await _captureScreen();
    if (image == null || !mounted) {
      onToggle();
      _isAnimating = false;
      return;
    }

    final screenSize = MediaQuery.of(context).size;
    _animationOrigin =
        origin ?? Offset(screenSize.width / 2, screenSize.height / 2);
    _maxRadius = _calculateMaxRadius(screenSize, _animationOrigin);
    _capturedImage = image;
    _isReversed = isReverse;
    _exclusionRadius = exclusionRadius;
    _exclusionRRect = exclusionRRect;

    if (duration != null) _controller.duration = duration;
    if (curve != null) {
      _animation = CurvedAnimation(parent: _controller, curve: curve);
    }

    onToggle();

    setState(() {});

    await WidgetsBinding.instance.endOfFrame;

    try {
      await _controller.forward(from: 0.0);
    } on TickerCanceled {
      // Widget was disposed during animation
    } finally {
      _cleanup(duration, curve);
    }
  }

  void _cleanup(Duration? overrideDuration, Curve? overrideCurve) {
    _capturedImage?.dispose();
    _capturedImage = null;
    _isAnimating = false;
    _isReversed = false;
    _exclusionRadius = 0;
    _exclusionRRect = null;
    _controller.reset();

    if (overrideDuration != null) _controller.duration = widget.duration;
    if (overrideCurve != null) {
      _animation =
          CurvedAnimation(parent: _controller, curve: widget.curve);
    }

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        RepaintBoundary(key: _repaintBoundaryKey, child: widget.child),
        if (_isAnimating && _capturedImage != null)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return ClipPath(
                  clipper: CircleRevealClipper(
                    center: _animationOrigin,
                    radius: _isReversed
                        ? _maxRadius * (1 - _animation.value)
                        : _maxRadius * _animation.value,
                    isReverse: _isReversed,
                    exclusionRadius: _exclusionRadius,
                    exclusionRRect: _exclusionRRect,
                  ),
                  child: child,
                );
              },
              child: IgnorePointer(
                child: _ScreenshotWidget(image: _capturedImage!),
              ),
            ),
          ),
      ],
    );
  }
}

class _ScreenshotWidget extends LeafRenderObjectWidget {
  final ui.Image image;

  const _ScreenshotWidget({required this.image});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderScreenshot(image: image);
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderScreenshot renderObject) {
    renderObject.image = image;
  }
}

class _RenderScreenshot extends RenderBox {
  ui.Image _image;

  _RenderScreenshot({required ui.Image image}) : _image = image;

  set image(ui.Image value) {
    if (_image == value) return;
    _image = value;
    markNeedsPaint();
  }

  @override
  bool get sizedByParent => true;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.biggest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final src = Rect.fromLTWH(
        0, 0, _image.width.toDouble(), _image.height.toDouble());
    final dst = offset & size;
    context.canvas.drawImageRect(_image, src, dst, Paint());
  }
}
