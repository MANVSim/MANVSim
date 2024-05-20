import 'package:flutter/material.dart';
import 'package:manvsim/appframe.dart';
import 'package:manvsim/widgets/logout_button.dart';
import 'package:manvsim/widgets/timer_widget.dart';

class WaitScreen extends StatelessWidget {
  const WaitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const <Widget>[LogoutButton()],
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Waiting for simulation to start'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TimerWidget(
              duration: 10,
              onTimerComplete: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AppFrame()),
                      (Route<dynamic> route) => false, // Removes previous routes
                );
              },
            ),
            const SizedBox(height: 64),

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
