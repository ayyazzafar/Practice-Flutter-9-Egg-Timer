import 'package:egg_timer/egg_timer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EggTimerTimeDisplay extends StatefulWidget {
  final EggTimerState eggTimerState;
  final Duration selectionTime;
  final Duration countDownTime;

  const EggTimerTimeDisplay({
    Key key,
    this.eggTimerState,
    this.selectionTime = const Duration(seconds: 0),
    this.countDownTime = const Duration(seconds: 0),
  }) : super(key: key);
  @override
  _EggTimerTimeDisplayState createState() => _EggTimerTimeDisplayState();
}




class _EggTimerTimeDisplayState extends State<EggTimerTimeDisplay> with TickerProviderStateMixin {

  final DateFormat selectionTimeFormat = new DateFormat('mm');
  final DateFormat countdownTimerFormat = new DateFormat('mm:ss');

  AnimationController selectionTimeSlideController;
  AnimationController countDownTimeFadeController;


  

get formattedSelectionTime{
  DateTime dateTime = DateTime(DateTime.now().year, 0,0,0,0, widget.selectionTime.inSeconds);
  return selectionTimeFormat.format(dateTime);
}

get formattedCountDownTime{
  DateTime dateTime = DateTime(DateTime.now().year, 0,0,0,0, widget.countDownTime.inSeconds);
  return countdownTimerFormat.format(dateTime);
}

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectionTimeSlideController = AnimationController(duration: Duration(milliseconds: 450),vsync: this)
    ..addListener((){
      setState((){});
    });

    countDownTimeFadeController = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this)
    ..addListener((){
      setState((){});
    });
    countDownTimeFadeController.value = 1.0;
  }

  @override
  void dispose(){
    selectionTimeSlideController.dispose();
    countDownTimeFadeController.dispose();
    super.dispose();
  }

  @override



  Widget build(BuildContext context) {


    if(widget.eggTimerState==EggTimerState.ready){
      selectionTimeSlideController.reverse();
      countDownTimeFadeController.forward();
    } else {
      selectionTimeSlideController.forward();
      countDownTimeFadeController.reverse();
    }


    return Padding(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Transform(
            transform: Matrix4.translationValues(
                0.0,
                -200.0 *selectionTimeSlideController.value,
                0.0),
            child: Text(
              formattedSelectionTime,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'BebasNeue',
                  fontSize: 80.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 10.0),
            ),
          ),
          Opacity(
            opacity: 1-countDownTimeFadeController.value,
            child: Text(
              formattedCountDownTime,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'BebasNeue',
                  fontSize: 80.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 10.0),
            ),
          )
        ],
      ),
      padding: const EdgeInsets.only(top: 40.0),
    );
  }
}
