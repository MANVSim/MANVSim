import 'package:flutter/material.dart';
import 'package:manvsim/screens/notifications_screen.dart';
import 'package:manvsim/screens/patient_list_screen.dart';
import 'package:manvsim/screens/tan_screen.dart';

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
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
              selectedIcon: Icon(Icons.list_outlined),
              icon: Icon(Icons.list),
              label: 'Patients'
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.notifications_sharp)),
            label: 'Notifications',
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