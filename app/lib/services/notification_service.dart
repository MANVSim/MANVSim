import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manvsim/services/api_service.dart';

typedef Notification = String;
typedef Notifications = List<Notification>;

class NotificationService extends ChangeNotifier{
  int _nextId = 0;
  int _consumedId = 0;
  final Notifications _notifications = [];

  Timer? _timer;

  void startPolling({Duration interval = const Duration(seconds: 5)}) {

    if(_timer != null) {
      return;
    }

    _pollNotifications();
    _timer = Timer.periodic(interval, (timer) {
      try {
        _pollNotifications();
      } catch (e) {
        // ignore
      }
    });

  }

  void stopPolling() {
    _timer?.cancel();
    _timer = null;
    _notifications.clear();
    _nextId = 0;
    _consumedId = 0;
  }

  bool get hasUnreadNotifications => _nextId > _consumedId;

  Notifications consumeNotifications() {
    _consumedId = _nextId;
    notifyListeners();
    return _notifications;
  }

  void _pollNotifications() async {
    ApiService apiService = GetIt.I<ApiService>();
    var response = await apiService.api.notificationsGet(_nextId);
    if (response != null) {
      _notifications.addAll(response.notifications);
      _nextId = response.nextId!;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    stopPolling();
  }
}