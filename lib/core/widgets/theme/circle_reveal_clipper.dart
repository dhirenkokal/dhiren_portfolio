import 'package:flutter/material.dart';

/// Custom clipper that drives the circular reveal animation.
///
/// [isReverse] = false → clip = (screen − circle)
///   Screenshot visible OUTSIDE the growing circle; new theme visible inside.
///   Effect: new theme grows outward from [center] like a spotlight.
///
/// [isReverse] = true  → clip = circle
///   Screenshot visible INSIDE the shrinking circle; new theme visible outside.
///   Effect: old theme collapses inward toward [center], new theme spreads from edges.
///
/// [exclusionRRect] (optional) carves the toggle button out of the clip so
/// the button always shows the live (new-theme) UI and never freezes.
/// Only applied for the [isReverse]=true case — when false the circle
/// originates from the button itself, so it clears the button immediately.
class CircleRevealClipper extends CustomClipper<Path> {
  final Offset center;
  final double radius;
  final bool isReverse;
  final double exclusionRadius;
  final RRect? exclusionRRect;

  const CircleRevealClipper({
    required this.center,
    required this.radius,
    required this.isReverse,
    this.exclusionRadius = 0,
    this.exclusionRRect,
  });

  @override
  Path getClip(Size size) {
    final path = Path()..fillType = PathFillType.evenOdd;

    if (!isReverse) {
      // Forward: screenshot fills everything OUTSIDE the expanding circle.
      // evenOdd: rect(filled) + circle(hole) = screenshot outside circle only.
      path
        ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
        ..addOval(Rect.fromCircle(center: center, radius: radius));
      // Exclusion not needed here: origin IS the button, so the circle
      // clears the button area within the first frame.
    } else {
      // Reverse: screenshot fills the INSIDE of the shrinking circle.
      // evenOdd: circle(filled) + exclusion(hole) = screenshot inside circle
      // except at the button, which always shows the new theme.
      path.addOval(Rect.fromCircle(center: center, radius: radius));
      if (exclusionRRect != null) {
        path.addRRect(exclusionRRect!);
      }
      if (exclusionRadius > 0) {
        path.addOval(Rect.fromCircle(center: center, radius: exclusionRadius));
      }
    }

    return path;
  }

  @override
  bool shouldReclip(CircleRevealClipper old) =>
      old.radius != radius ||
      old.center != center ||
      old.isReverse != isReverse ||
      old.exclusionRadius != exclusionRadius ||
      old.exclusionRRect != exclusionRRect;
}
