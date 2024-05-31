import 'package:flutter/material.dart';

import 'wait_screen.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NameScreen extends StatelessWidget {
  const NameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.nameScreenName),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.nameName,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const WaitScreen()),
                        (Route<dynamic> route) =>
                    false, // Removes all previous routes
                  );
                },
                icon: const Icon(Icons.start),
                label: Text(AppLocalizations.of(context)!.nameSubmit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
