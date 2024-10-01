import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:manvsim/constants/manv_icons.dart';
import 'package:manvsim/services/notification_service.dart';
import 'package:manvsim/widgets/base_screens/home_screen.dart';
import 'package:manvsim/widgets/base_screens/notifications_screen.dart';
import 'package:manvsim/widgets/location/location_list_screen.dart';
import 'package:manvsim/widgets/map/map_screen.dart';
import 'package:manvsim/widgets/patient/patient_list_screen.dart';
import 'package:provider/provider.dart';

import 'models/config.dart';

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

    final Config config = Provider.of<Config>(context, listen: false);

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
              label: AppLocalizations.of(context)!.frameHome),
          if (config.showMap)NavigationDestination(
              selectedIcon: const Icon(ManvIcons.mapOutlined),
              icon: const Icon(ManvIcons.map),
              label: AppLocalizations.of(context)!.frameMap),
          if (config.showPatientList)NavigationDestination(
              selectedIcon: const Icon(ManvIcons.patientOutlined),
              icon: const Icon(ManvIcons.patient),
              label: AppLocalizations.of(context)!.framePatients),
          if (config.showLocationList)NavigationDestination(
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
      body: <Widget>[
        /// Home page
        const HomeScreen(),
        if(config.showMap) const PatientMapScreen(),
        if(config.showPatientList) const PatientListScreen(),
        if(config.showLocationList)const LocationListScreen(),
        const NotificationsScreen()
      ][_currentPageIndex],
    );
  }
}
