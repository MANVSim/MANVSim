import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:manvsim/constants/manv_icons.dart';
import 'package:manvsim/screens/home_screen.dart';
import 'package:manvsim/screens/location_list_screen.dart';
import 'package:manvsim/screens/notifications_screen.dart';
import 'package:manvsim/screens/patient_list_screen.dart';
import 'package:manvsim/services/notification_service.dart';

class AppFrame extends StatefulWidget {
  const AppFrame({super.key});

  @override
  State<AppFrame> createState() => _AppFrameState();
}

class _AppFrameState extends State<AppFrame> {
  int _currentPageIndex = 0;
  late NotificationService _notificationService;

  @override
  void initState() {
    super.initState();

    _notificationService = GetIt.I.get<NotificationService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: _currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: const Icon(Icons.home_outlined),
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.frameHome,
          ),
          NavigationDestination(
              selectedIcon: const Icon(ManvIcons.patientOutlined),
              icon: const Icon(ManvIcons.patient),
              label: AppLocalizations.of(context)!.framePatients),
          NavigationDestination(
              selectedIcon: const Icon(ManvIcons.locationOutlined),
              icon: const Icon(ManvIcons.location),
              label: AppLocalizations.of(context)!.frameLocations),
          NavigationDestination(
            selectedIcon: const Icon(Icons.notifications_outlined),
            icon: ListenableBuilder(
                listenable: _notificationService,
                builder: (context, child) => Badge(
                    isLabelVisible: _notificationService.hasUnreadNotifications,
                    child: const Icon(Icons.notifications_sharp))),
            label: AppLocalizations.of(context)!.frameNotifications,
          )
        ],
      ),
      body: const <Widget>[
        /// Home page
        HomeScreen(),
        PatientListScreen(),
        LocationListScreen(),
        NotificationsScreen()
      ][_currentPageIndex],
    );
  }
}
