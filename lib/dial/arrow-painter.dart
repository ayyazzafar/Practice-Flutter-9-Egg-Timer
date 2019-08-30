import 'dart:math';

import 'package:flutter/material.dart';

class ArrowPainter extends CustomPainter {
  final Paint dialArrowPaint;
  final rotationPercentage;
  ArrowPainter({this.rotationPercentage})
      : dialArrowPaint = Paint()
          ..color = Colors.black
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    final radius = size.width / 2;

    canvas.translate(radius, radius);
    canvas.rotate(2 * pi * rotationPercentage);
    Path path = Path()
      ..moveTo(0.0, -radius - 10.0)
      ..lineTo(10.0, -radius + 5.0)
      ..lineTo(-10.0, -radius + 5.0)
      ..close();

    canvas.drawPath(path, dialArrowPaint);
    canvas.drawShadow(path, Colors.black, 3.0, false);

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
