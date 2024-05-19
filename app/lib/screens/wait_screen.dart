import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:manvsim/appframe.dart';
import 'package:manvsim/widgets/logout_button.dart';

class WaitScreen extends StatelessWidget {
  const WaitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const <Widget>[LogoutButton()],
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AppFrame()),
                  (Route<dynamic> route) => false, // Removes previous routes
                );
              },
              label: const Text('skip'),
            ),
          ],
        ),
      ),
    );
  }
}
