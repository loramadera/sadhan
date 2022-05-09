import 'dart:async';
import 'package:flutter/material.dart';

import '../app_scaffold.dart';
import '../../common/form_input/input_fields.dart';

class MeditateComponent extends StatefulWidget {
  @override
  _MeditateComponentState createState() => _MeditateComponentState();
}

class _MeditateComponentState extends State<MeditateComponent> {
  InputFields _inputFields = InputFields();

  var formVals = {
    'timeMinutes': 60,
  };
  Timer? _timer = null;
  int _startSeconds = 60 * 60;
  int _elapsedSeconds = 0;
  String _timeState = "stopped"; // "stopped" or "running"

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String buttonText = _timeState == "running" ? "Pause" : "Start";
    int elapsedMinutes = (_elapsedSeconds / 60).floor();
    int elapsedSeconds = (_elapsedSeconds % 60);
    return AppScaffoldComponent(
      body: ListView(
        children: [
          _inputFields.inputNumber(context, formVals, 'timeMinutes', label: 'Minutes', debounceChange: 1000, onChange: (double? val) {
            stopTimer();
            _startSeconds = (val! * 60).floor();
            _elapsedSeconds = 0;
          }),
          ElevatedButton(
            onPressed: () {
              toggleTimerState();
            },
            child: Text(buttonText),
          ),
          Text('${elapsedMinutes.toString()}:${elapsedSeconds.toString()} ${_startSeconds.toString()}'),
        ]
      )
    );
  }

  @override
  void dispose() {
    clearTimer();
    super.dispose();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_startSeconds == 0) {
          if (_timer != null) {
            stopTimer();
          }
        } else {
          if (_timeState == "running") {
            setState(() {
              _startSeconds--;
              _elapsedSeconds++;
            });
          }
        }
      },
    );
  }

  void clearTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  void stopTimer() {
    _timeState = "stopped";
    clearTimer();
    setState(() {
      _timeState = _timeState;
    });
  }

  void toggleTimerState() {
    if (_timeState == "running") {
      stopTimer();
    } else {
      _timeState = "running";
      setState(() {
        _timeState = _timeState;
      });
      startTimer();
    }
  }
}
