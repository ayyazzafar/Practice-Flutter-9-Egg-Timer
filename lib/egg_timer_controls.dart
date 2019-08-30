import 'package:egg_timer/egg_timer.dart';
import 'package:egg_timer/egg_timer_button.dart';
import 'package:flutter/material.dart';

class EggTimerControls extends StatefulWidget {
  final eggTimerState;
  final Function onPause;
  final Function onResume;
  final Function onRestart;

  final Function onReset;

  const EggTimerControls(
      {Key key,
      this.eggTimerState,
      this.onPause,
      this.onResume,
      this.onRestart,
      this.onReset})
      : super(key: key);

  @override
  _EggTimerControlsState createState() => _EggTimerControlsState();
}

class _EggTimerControlsState extends State<EggTimerControls>
    with TickerProviderStateMixin {
  AnimationController pauseResumeSlideAnimationController;
  AnimationController restartResetFadeController;

  @override
  void initState() {
    super.initState();
    pauseResumeSlideAnimationController = AnimationController(
      duration: Duration(milliseconds: 450),

      vsync: this,
    )
    ..addListener((){
      setState((){});
    });

    pauseResumeSlideAnimationController.value = 1.0;

    restartResetFadeController = AnimationController(
      duration: Duration(milliseconds: 450),
      value: 1.0,
      vsync: this,
    ) ..addListener((){
      setState((){});
    });

    restartResetFadeController.value = 1.0;
  }

  @override
  void dispose() {
    super.dispose();
    pauseResumeSlideAnimationController.dispose();
    restartResetFadeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.eggTimerState) {
      case EggTimerState.ready:
        pauseResumeSlideAnimationController.forward();
        restartResetFadeController.forward();
        break;

      case EggTimerState.running:
        pauseResumeSlideAnimationController.reverse();
        restartResetFadeController.forward();
        break;

      case EggTimerState.paused:
        pauseResumeSlideAnimationController.reverse();
        restartResetFadeController.reverse();
        break;
    }
    print('@@@@@'+pauseResumeSlideAnimationController.value.toString());
    return Column(
      children: <Widget>[
        Opacity(
          
          opacity: 1.0 - restartResetFadeController.value,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              EggTimerButton(
                width:  MediaQuery.of(context).size.width/2.25,
                icon: Icons.refresh,
                text: 'RESTART',
                onPressed: widget.onRestart,
              ),
          
              EggTimerButton(
                width: MediaQuery.of(context).size.width/2.50,
                icon: Icons.arrow_back,
                text: 'RESET',
                onPressed: widget.onReset,
              )
            ],
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(0.0, 
          100 * pauseResumeSlideAnimationController.value,
           0.0),
          child: EggTimerButton(
              icon: widget.eggTimerState == EggTimerState.running
                  ? Icons.pause
                  : Icons.play_arrow,
              text: widget.eggTimerState == EggTimerState.running
                  ? 'Pause'
                  : 'Resume',
              onPressed: widget.eggTimerState == EggTimerState.running
                  ? widget.onPause
                  : widget.onResume),
        )
      ],
    );
  }
}
