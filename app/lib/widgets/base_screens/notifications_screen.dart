import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manvsim/services/notification_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late NotificationService _notificationService;

  @override
  void initState() {
    super.initState();
    _notificationService = GetIt.I<NotificationService>();
    _notificationService.addListener(_onNotificationsUpdated);
  }

  void _onNotificationsUpdated() {
    setState(() {});
  }

  @override
  void dispose() {
    _notificationService.removeListener(_onNotificationsUpdated);
    super.dispose();
  }

  Notifications _getNotifications() {
    _notificationService.removeListener(_onNotificationsUpdated);
    var notifications = _notificationService.consumeNotifications();
    _notificationService.addListener(_onNotificationsUpdated);
    return notifications;
  }

  @override
  Widget build(BuildContext context) {
    final notifications = _getNotifications();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(AppLocalizations.of(context)!.notificationScreenName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: notifications.isEmpty
            ? Center(
                child: Text(AppLocalizations.of(context)!
                    .notificationScreenNoNotifications),
              )
            : ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.notifications_sharp),
                      title: Text(notification),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
