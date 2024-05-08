import 'package:flutter/material.dart';

import 'screens/login_screen.dart';


void main() {
  runApp(const ManvSimApp());
}

class ManvSimApp extends StatelessWidget {

  const ManvSimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ManvSim',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
