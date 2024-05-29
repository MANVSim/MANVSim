import 'package:flutter/material.dart';
import 'package:manvsim/screens/notifications_screen.dart';
import 'package:manvsim/screens/patient_list_screen.dart';
import 'package:manvsim/screens/tan_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            selectedIcon: const Icon(Icons.home),
            icon: const Icon(Icons.home_outlined),
            label: AppLocalizations.of(context)!.frameHome,
          ),
          NavigationDestination(
              selectedIcon: const Icon(Icons.list_outlined),
              icon: const Icon(Icons.list),
              label: AppLocalizations.of(context)!.framePatients
          ),
          NavigationDestination(
            icon: const Badge(child: Icon(Icons.notifications_sharp)),
            label: AppLocalizations.of(context)!.frameNotifications,
          ),
        ],
      ),
      body: const <Widget>[
        /// Home page
        TanScreen(),
        PatientListScreen(),
        NotificationsScreen()
      ][currentPageIndex],
    );
  }
}