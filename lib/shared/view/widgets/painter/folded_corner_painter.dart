import 'package:flutter/material.dart';

class FoldedCornerPainter extends CustomPainter {
  final Color color;
  final double foldSize;
  final double borderRadius;

  FoldedCornerPainter({
    required this.color,
    this.foldSize = 25,
    this.borderRadius = 10, // Control the circular edges
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    // Path for main shape with rounded corners on three sides
    Path path = Path()
      ..moveTo(borderRadius, 0)
      ..lineTo(size.width - foldSize, 0)
      ..lineTo(size.width, foldSize)
      ..lineTo(size.width, size.height - borderRadius)
      ..arcToPoint(Offset(size.width - borderRadius, size.height), radius: Radius.circular(borderRadius))
      ..lineTo(borderRadius, size.height)
      ..arcToPoint(Offset(0, size.height - borderRadius), radius: Radius.circular(borderRadius))
      ..lineTo(0, borderRadius)
      ..arcToPoint(Offset(borderRadius, 0), radius: Radius.circular(borderRadius))
      ..close();

    canvas.drawPath(path, paint);

    // Folded corner effect
    Path foldPath = Path()
      ..moveTo(size.width - foldSize, 0)
      ..lineTo(size.width, foldSize)
      ..lineTo(size.width - foldSize, foldSize)
      ..close();

    final foldPaint = Paint()
      ..color = _lightenColor(color, 0.1);

    canvas.drawPath(foldPath, foldPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  Color _lightenColor(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final lightened = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return lightened.toColor();
  }
}