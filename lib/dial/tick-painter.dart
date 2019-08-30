import 'dart:math';

import 'package:flutter/material.dart';

class TickPainter extends CustomPainter {
  final LONG_TICK = 14.0;
  final SHORT_TICK = 4.0;

  final tickCount;
  final ticksPerSection;
  final tickPaint;
  final TextPainter textPainter;
  final textStyle;

  TickPainter({
    this.ticksPerSection = 5,
    this.tickCount = 35.0,
  })  : tickPaint = Paint()
          ..color = Colors.black
          ..strokeWidth = 1.5,
        textPainter = TextPainter()..textDirection = TextDirection.ltr,
        textStyle = const TextStyle(
            color: Colors.black, fontFamily: 'BebasNeue', fontSize: 20.0);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    canvas.save();
    final radius = size.width / 2;

    for (var i = 0; i < tickCount; ++i) {
      final tickLength = i % ticksPerSection == 0 ? LONG_TICK : SHORT_TICK;
      canvas.drawLine(
        Offset(0.0, -radius),
        Offset(0.0, -radius - tickLength),
        tickPaint,
      );

      if (tickLength == LONG_TICK) {
        // paint text
        canvas.save();
        canvas.translate(0.0, -radius - 30.0);
        textPainter.text = TextSpan(text: '$i', style: textStyle);
        textPainter.layout();

        textAlignment(i, tickCount, canvas);
  
        textPainter.paint(
            canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
        canvas.restore();
      }

      canvas.rotate(2 * pi / tickCount);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

getTextQuadrant(tickPercent) {

  // Figure out which quadrant the text is in
  var quadrant;

  if (tickPercent < 0.25) {
    quadrant = 1;
  } else if (tickPercent < 0.50) {
    quadrant = 4;
  } else if (tickPercent < 0.75) {
    quadrant = 3;
  } else {
    quadrant = 2;
  }
  return quadrant;
}

textAlignment(i, tickCount, canvas) {

  final tickPercent = i / tickCount;
  var quadrant = getTextQuadrant(tickPercent);

  switch (quadrant) {
    case 4:
      canvas.rotate(-pi / 2);
      break;
    case 2:
    case 3:
      canvas.rotate(pi / 2);
      break;
  }
}
