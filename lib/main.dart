import 'package:egg_timer/egg_timer.dart';
import 'package:egg_timer/egg_timer_controls.dart';
import 'package:egg_timer/egg_timer_time_display.dart';
import 'package:flutter/material.dart';

import 'dial/egg_timer_dial.dart';

final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  _onDialStopTurning(Duration newTime) {
    setState(() {
      eggTimer.currentTime = newTime;
      eggTimer.resume();
    });
  }

  EggTimer eggTimer;

  _MyAppState() {
    eggTimer = EggTimer(
      maxTime: Duration(
        minutes: 35,
      ),
      onTimerUpdate: _onTimerUpdate,
    );
  }

  _onTimerUpdate() {
    setState(() {});
  }

  _onTimeSelected(Duration newTime) {
    setState(() {
      eggTimer.currentTime = newTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [GRADIENT_TOP, GRADIENT_BOTTOM],
            ),
          ),
          child: Center(
            child: Column(
              children: <Widget>[
                EggTimerTimeDisplay(
                  eggTimerState: eggTimer.state,
                  selectionTime: eggTimer.lastStartTime,
                  countDownTime: eggTimer.currentTime,
                ),
                EggTimerDial(
                  eggTimerState: eggTimer.state,
                  currentTime: eggTimer.currentTime,
                  maxTime: eggTimer.maxTime,
                  ticksPerSection: 5,
                  onTimeSelected: _onTimeSelected,
                  onDialStopTurning: _onDialStopTurning,
                ),
                Expanded(
                  child: Container(),
                ),
                EggTimerControls(
                  eggTimerState: eggTimer.state,
                  onPause: () {
                    eggTimer.pause();
                  },
                  onResume: () {
                    eggTimer.resume();
                  },
                  onRestart: () {
                    eggTimer.restart();
                  },
                  onReset: () {
                    eggTimer.reset();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
