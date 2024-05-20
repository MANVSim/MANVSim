import 'package:flutter/material.dart';
import 'dart:async';



class TimerWidget extends StatefulWidget {
  final int duration;
  final VoidCallback? onTimerComplete;

  const TimerWidget({super.key, required this.duration, this.onTimerComplete});

  @override
  TimerWidgetState createState() => TimerWidgetState();
}

class TimerWidgetState extends State<TimerWidget> {
  late int _remainingTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.duration;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
          if (widget.onTimerComplete != null) {
            widget.onTimerComplete!();
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progressValue = _remainingTime / widget.duration;

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        SizedBox(
          width: 200,
          height: 200,
          child: CircularProgressIndicator(
            value: progressValue,
            strokeWidth: 8.0,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
        Text(
          '$_remainingTime',
          style: const TextStyle(fontSize: 48),
        ),
      ],
    );
  }
}