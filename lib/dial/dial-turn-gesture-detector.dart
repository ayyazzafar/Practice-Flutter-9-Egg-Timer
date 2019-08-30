import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttery/gestures.dart';

class DialTurnGestureDetector extends StatefulWidget {

  final currentTime;
  final maxTime;
  final child;
  final Function(Duration) onTimeSelected;
  final Function(Duration) onDialStopTurning;

  DialTurnGestureDetector({
    this.currentTime,
    this.maxTime,
    this.child,
    this.onTimeSelected,
    this.onDialStopTurning,
  });

  @override
  _DialTurnGestureDecetorState createState() => new _DialTurnGestureDecetorState();
}

class _DialTurnGestureDecetorState extends State<DialTurnGestureDetector> {

  PolarCoord startDragCoord;
  Duration startDragTime;
  Duration selectedTime;

  _onRadialDragEnd() {
    
    widget.onDialStopTurning(selectedTime);

    startDragCoord = null;
    selectedTime = null;
    startDragTime = null;
  }

  _onRadialDragStart(PolarCoord coord) {
    startDragCoord = coord;
    startDragTime = widget.currentTime;
  }

  _onRadialDragUpdate(PolarCoord coord) {
    if (startDragCoord != null) {
      var angleDiff = coord.angle - startDragCoord.angle;
      angleDiff = angleDiff >= 0.0 ? angleDiff : angleDiff + (2 * pi);

      final anglePercentage = angleDiff / (2 * pi);
      final timeDiff = (anglePercentage * widget.maxTime.inSeconds).round();
      selectedTime = Duration(seconds: startDragTime.inSeconds + timeDiff);
      widget.onTimeSelected(selectedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RadialDragGestureDetector(
      child: widget.child,
      onRadialDragEnd: _onRadialDragEnd,
      onRadialDragStart: _onRadialDragStart,
      onRadialDragUpdate: _onRadialDragUpdate,
    );
  }
}
