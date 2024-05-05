import 'package:flutter/material.dart';

import 'package:manvsim/models/patient.dart';
import 'package:manvsim/services/patient_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Future<List<Patient>> patientList;

  Future<void> _updatePatientList() async {
    setState(() {
      patientList = fetchPatientList();
    });
  }

  @override
  void initState() {
    super.initState();
    patientList = fetchPatientList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Notifications'),
        ),
        body: RefreshIndicator(
          onRefresh: _updatePatientList,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Card(
                  child: ListTile(
                    leading: Icon(Icons.notifications_sharp),
                    title: Text('Notification 1'),
                    subtitle: Text('This is a notification'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.notifications_sharp),
                    title: Text('Notification 2'),
                    subtitle: Text('This is a notification'),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}