import 'package:flutter/material.dart';
import 'package:manvsim/screens/login_screen.dart';
import 'package:manvsim/screens/notifications_screen.dart';
import 'package:manvsim/screens/patient_list_screen.dart';

class AppFrame extends StatefulWidget {
  const AppFrame({super.key});

  @override
  State<AppFrame> createState() => _AppFrameState();
}

class _AppFrameState extends State<AppFrame> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          if (index == 3) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false, // Removes all previous routes
            );
          } else {
          setState(() {
            currentPageIndex = index;
          });
          }
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
          NavigationDestination(
            icon: Icon(Icons.logout),
            label: 'Logout'
          ),
        ],
      ),
      body: const <Widget>[
        /// Home page
        Placeholder(),
        PatientListScreen(),
        NotificationsScreen(),
        /// Logout Placeholder Page
        Placeholder()
      ][currentPageIndex],
    );
  }
}