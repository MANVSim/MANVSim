import 'dart:async';

import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  final Duration duration;
  final VoidCallback? onTimerComplete;

  const TimerWidget({super.key, required this.duration, this.onTimerComplete});

  @override
  TimerWidgetState createState() => TimerWidgetState();
}

class TimerWidgetState extends State<TimerWidget> {
  /// Remaining time in seconds.
  late int _remainingTime;

  Timer? _timer;

  /// Timer ticks every second.

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.duration.inSeconds;
    _startTimer();
  }

  void _startTimer() {
    if (_remainingTime <= 0) {
      if (widget.onTimerComplete != null) {
        widget.onTimerComplete!();
      }
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime <= 0) {
        _timer?.cancel();
        widget.onTimerComplete?.call();
      } else {
        setState(() {
          _remainingTime--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(TimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _timer?.cancel();
      _remainingTime = widget.duration.inSeconds;
      _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    double progressValue = _remainingTime / widget.duration.inSeconds;

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
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        Text(
          _remainingTime >= 0 ? '$_remainingTime' : '0',
          style: const TextStyle(fontSize: 48),
        ),
      ],
    );
  }
}
