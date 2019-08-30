import 'dart:math';

import 'package:flutter/material.dart';

import 'arrow-painter.dart';

final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

class EggTimerKnob extends StatefulWidget {
  final rotationPercent;

  const EggTimerKnob({Key key, this.rotationPercent}) : super(key: key);

  @override
  _EggTimerKnobState createState() => _EggTimerKnobState();
}

class _EggTimerKnobState extends State<EggTimerKnob> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          child: CustomPaint(
            painter: ArrowPainter(rotationPercentage: widget.rotationPercent),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          decoration: drawCircle(),
          child: Container(
            decoration: drawInnerCircle(),
            child: Center(
              child: Transform(
                transform: Matrix4.rotationZ(2 * pi * widget.rotationPercent),
                alignment: Alignment.center,
                child: Image.network(
                  'https://miro.medium.com/max/1000/1*ilC2Aqp5sZd1wi0CopD1Hw.png',
                  width: 90.0,
                  height: 90.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

BoxDecoration drawCircle() {
  return BoxDecoration(
    shape: BoxShape.circle,
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [GRADIENT_TOP, GRADIENT_BOTTOM],
    ),
    boxShadow: [
      BoxShadow(
          color: Color(0x44000000),
          blurRadius: 2.0,
          spreadRadius: 1,
          offset: Offset(0.0, 1.0))
    ],
  );
}

BoxDecoration drawInnerCircle() {
  return BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(color: Color(0xFFDFDFDF), width: 1.5),
  );
}
