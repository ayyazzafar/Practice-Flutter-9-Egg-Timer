import 'package:egg_timer/dial/tick-painter.dart';
import 'package:flutter/material.dart';
import '../egg_timer.dart';
import 'dial-turn-gesture-detector.dart';
import 'egg_timer_knob.dart';

final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

class EggTimerDial extends StatefulWidget {
  final EggTimerState eggTimerState;
  final Duration currentTime;
  final Duration maxTime;
  final int ticksPerSection;
  final Function(Duration) onTimeSelected;
  final Function(Duration) onDialStopTurning;

  EggTimerDial({
    this.eggTimerState,
    this.currentTime = const Duration(minutes: 0),
    this.maxTime = const Duration(minutes: 35),
    this.ticksPerSection = 5,
    this.onTimeSelected,
    this.onDialStopTurning,
  });

  @override
  _EggTimerDialState createState() => new _EggTimerDialState();
}

class _EggTimerDialState extends State<EggTimerDial>
    with TickerProviderStateMixin {
  static const RESET_SPEED_PERCENT_PER_SECOND = 4.0;

  EggTimerState prevEggTimerState;
  double prevRotationPercent = 0.0;
  AnimationController resetToZeroController;
  Animation resettingAnimation;

  @override
  void initState() {
    super.initState();

    resetToZeroController = new AnimationController(vsync: this);
  }

  @override
  void dispose() {
    resetToZeroController.dispose();
    super.dispose();
  }

  _rotationPercent() {
    return widget.currentTime.inSeconds / widget.maxTime.inSeconds;
  }

  @override
  Widget build(BuildContext context) {
    _resetToZeroAnimation();

    prevEggTimerState = widget.eggTimerState;
    prevRotationPercent = _rotationPercent();

    return DialTurnGestureDetector(
      currentTime: widget.currentTime,
      maxTime: widget.maxTime,
      onTimeSelected: widget.onTimeSelected,
      onDialStopTurning: widget.onDialStopTurning,
      child: theDial(),
    );
  }

  _resetToZeroAnimation() {
    if (widget.currentTime.inSeconds == 0 &&
        prevEggTimerState != EggTimerState.ready) {
      resettingAnimation = Tween(
        begin: prevRotationPercent,
        end: 0.0,
      ).animate(resetToZeroController)
        ..addListener(() => setState(() {}))
        ..addStatusListener(
          (status) {
            if (status == AnimationStatus.completed) {
              setState(() => resettingAnimation = null);
            }
          },
        );

      resetToZeroController.duration = new Duration(
          milliseconds:
              ((prevRotationPercent / RESET_SPEED_PERCENT_PER_SECOND) * 1000)
                  .round());
      resetToZeroController.forward(from: 0.0);
    }
  }

  Widget theDial() {
    return new Container(
      width: double.infinity,
      child: new Padding(
        padding: const EdgeInsets.only(left: 45.0, right: 45.0, top: 20),
        child: new AspectRatio(
          aspectRatio: 1.0,
          child: new Container(
            decoration: drawCircle(),
            child: new Stack(
              children: [
                ticks(),
                knob(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ticks() {
    return new Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(55.0),
      child: new CustomPaint(
        painter: new TickPainter(
          tickCount: widget.maxTime.inMinutes,
          ticksPerSection: widget.ticksPerSection,
        ),
      ),
    );
  }

  Widget knob() {
    return Padding(
      padding: const EdgeInsets.all(65.0),
      child: new EggTimerKnob(
        rotationPercent: resettingAnimation == null
            ? _rotationPercent()
            : resettingAnimation.value,
      ),
    );
  }

  BoxDecoration drawCircle() {
    return BoxDecoration(
      shape: BoxShape.circle,
      gradient: new LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [GRADIENT_TOP, GRADIENT_BOTTOM],
      ),
      boxShadow: [
        new BoxShadow(
          color: const Color(0x44000000),
          blurRadius: 2.0,
          spreadRadius: 1.0,
          offset: const Offset(0.0, 2.0),
        ),
      ],
    );
  }
}
