import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'LoginScreen.dart';


class WaitScreen extends StatelessWidget {
  const WaitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (Route<dynamic> route) => false, // Removes all previous routes
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingAnimationWidget.threeRotatingDots(
              color: Colors.black,
              size: 32,
            ),
            const SizedBox(height: 32),
            const Text("waiting for the simulation to start"),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.skip_next),
              onPressed: () {},
              label: const Text('skip'),
            ),
          ],
        ),

      ),
    );
  }
}