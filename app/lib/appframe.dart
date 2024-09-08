import 'package:flutter/material.dart';
import 'package:manvsim/screens/location_list_screen.dart';
import 'package:manvsim/screens/notifications_screen.dart';
import 'package:manvsim/screens/patient_list_screen.dart';
import 'package:manvsim/screens/patient_select_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manvsim/constants/icons.dart' as constants;

class AppFrame extends StatefulWidget {
  const AppFrame({super.key});

  @override
  State<AppFrame> createState() => _AppFrameState();
}

class _AppFrameState extends State<AppFrame> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: const Icon(Icons.home_outlined),
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.frameHome,
          ),
          NavigationDestination(
              selectedIcon: const Icon(constants.Icons.patientOutlined),
              icon: const Icon(constants.Icons.patient),
              label: AppLocalizations.of(context)!.framePatients),
          NavigationDestination(
              selectedIcon: const Icon(constants.Icons.locationOutlined),
              icon: const Icon(constants.Icons.location),
              label: AppLocalizations.of(context)!.frameLocations),
          NavigationDestination(
            icon: const Badge(child: Icon(Icons.notifications_sharp)),
            label: AppLocalizations.of(context)!.frameNotifications,
          ),
        ],
      ),
      body: const <Widget>[
        /// Home page
        PatientSelectScreen(),
        PatientListScreen(),
        LocationListScreen(),
        NotificationsScreen()
      ][currentPageIndex],
    );
  }
}
