import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manv_api/api.dart';
import 'package:manvsim/appframe.dart';
import 'package:manvsim/services/api_service.dart';
import 'package:manvsim/services/notification_service.dart';
import 'package:manvsim/widgets/error_box.dart';
import 'package:manvsim/widgets/logout_button.dart';
import 'package:manvsim/widgets/timer_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/player_overview.dart';

class WaitScreen extends StatefulWidget {
  const WaitScreen({super.key});

  @override
  State<StatefulWidget> createState() => _WaitScreenState();
}

enum _WaitState {
  initial,
  waitingForStartTime,
  waitingForStart,
  waitingForTravelTime,
  waitingForArrival,
  waitingForStartAndArrival,
}

class _WaitScreenState extends State<WaitScreen> {
  Timer? _pollingTimer;
  final ApiService _apiService = GetIt.instance.get<ApiService>();

  int _waitTimeSeconds = 0;
  _WaitState _waitState = _WaitState.initial;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _updateStatus();
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await _updateStatus();
    });
  }

  void _onError(String? errorText) {
    if (errorText == null || errorText.isEmpty || errorText == _errorText) {
      return;
    }

    setState(() {
      _errorText = errorText;
    });
  }

  _updateStatus() async {
    _WaitState newState = _waitState;
    int newWaitTime = 0;

    try {
      final response = await _apiService.api.scenarioStartTimeGet();
      if (response != null) {
        final int currentTimeSeconds =
            DateTime.now().millisecondsSinceEpoch ~/ 1000;
        newState = _calculateState(
            currentTimeSeconds, response.startingTime, response.arrivalTime);
        newWaitTime = _calculateWaitTime(currentTimeSeconds,
            response.startingTime, response.arrivalTime, newState);
      } else {
        // no response (same as HTTP code 204)
        newState = _WaitState.waitingForStartTime;
      }
    } on ApiException catch (e) {
      if (e.code == 204) {
        // scenario has not started yet - wait for start time
        newState = _WaitState.waitingForStartTime;
      } else if (!_apiService.handleErrorCode(e, context)) {
        // error not handled by apiService -> warn
        _onError(e.message);
        return;
      }
    } catch (e) {
      // other errors
      // should not happen -> warn
      _onError(e.toString());
      return;
    }

    if (_waitState == _WaitState.initial &&
        _isNavigationState(newState) &&
        newWaitTime <= 0) {
      _goToHome();
    }

    if (newState != _waitState) {
      setState(() {
        _waitState = newState;
        _waitTimeSeconds = newWaitTime;
        _errorText = null;
      });
    }
  }

  _WaitState _calculateState(
      int currentTime, int scenarioStartTime, int? travelTime) {
    if (scenarioStartTime > currentTime) {
      if (travelTime != null && travelTime == scenarioStartTime) {
        return _WaitState.waitingForStartAndArrival;
      } else {
        return _WaitState.waitingForStart;
      }
    } else {
      if (travelTime == null) {
        return _WaitState.waitingForTravelTime;
      } else {
        return _WaitState.waitingForArrival;
      }
    }
  }

  int _calculateWaitTime(int currentTime, int scenarioStartTime,
      int? travelTime, _WaitState state) {
    switch (state) {
      case _WaitState.waitingForStartTime:
      case _WaitState.waitingForTravelTime:
        return 0;
      case _WaitState.waitingForStart:
      case _WaitState.waitingForStartAndArrival:
        return scenarioStartTime - currentTime;
      case _WaitState.waitingForArrival:
        return travelTime! - currentTime;
      default:
        return 0;
    }
  }

  bool _showTimer() {
    return _waitState == _WaitState.waitingForStart ||
        _waitState == _WaitState.waitingForArrival ||
        _waitState == _WaitState.waitingForStartAndArrival;
  }

  bool _showError() {
    return _errorText != null && _errorText!.isNotEmpty;
  }

  String _waitStateText() {
    switch (_waitState) {
      case _WaitState.waitingForStartTime:
        return AppLocalizations.of(context)!.waitTextWaitForStartTime;
      case _WaitState.waitingForStart:
        return AppLocalizations.of(context)!.waitTextWaitForStart;
      case _WaitState.waitingForTravelTime:
        return AppLocalizations.of(context)!.waitTextWaitForTravelTime;
      case _WaitState.waitingForArrival:
        return AppLocalizations.of(context)!.waitTextWaitForArrival;
      case _WaitState.waitingForStartAndArrival:
        return AppLocalizations.of(context)!.waitTextWaitForStartAndArrival;
      case _WaitState.initial:
        return AppLocalizations.of(context)!.waitTextInitial;
      default:
        return '';
    }
  }

  bool _isNavigationState(_WaitState state) {
    return state == _WaitState.waitingForArrival ||
        state == _WaitState.waitingForStartAndArrival;
  }

  void _handleTimerComplete() {
    if (_isNavigationState(_waitState)) {
      _goToHome();
    }
  }

  void _goToHome() {

    NotificationService notificationService = GetIt.I<NotificationService>();
    notificationService.startPolling();

    _apiService.api
        .runLocationLeavePost()
        .whenComplete(() => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const AppFrame()),
              (Route<dynamic> route) => false, // Removes previous routes
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(AppLocalizations.of(context)!.waitText),
      ),
      body: Column(children: [
        const PlayerOverview(),
        Expanded(child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_showError()) ...[
              ErrorBox(
                  errorText: AppLocalizations.of(context)!
                      .waitErrorOccurred(_errorText!)),
              const SizedBox(height: 32),
            ],
            Text(_waitStateText()),
            const SizedBox(height: 32),
            if (_showTimer())
              TimerWidget(
                  duration: Duration(seconds: _waitTimeSeconds),
                  onTimerComplete: _handleTimerComplete)
            else
              const CircularProgressIndicator(),
            if (true) ...[
              // TODO: #228 use kDebugMode instead of true
              const SizedBox(height: 64),
              ElevatedButton.icon(
                icon: const Icon(Icons.skip_next),
                onPressed: _goToHome,
                label: Text(AppLocalizations.of(context)!.waitSkip),
              )
            ],
          ],
        ),
      )),
    ]));
  }
}
