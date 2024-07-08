import 'package:flutter/material.dart';
import 'package:manvsim/screens/patient_screen.dart';
import 'package:manvsim/widgets/logout_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manvsim/widgets/tan_input.dart';

class TanScreen extends StatelessWidget {
  const TanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(AppLocalizations.of(context)!.homeScreenName),
        actions: const <Widget>[LogoutButton()],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.homeTAN),
              TanInputField(controller: TanInputController(),
                decoration: const InputDecoration(
              labelText: "",
              fillColor:  null,
              filled: false,
              border: UnderlineInputBorder(),
            ),
                onChanged: (value) {},
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.qr_code_scanner),
                label: Text(AppLocalizations.of(context)!.qrCodeScanButton),
                onPressed: () {
                  // TODO
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PatientScreen(patientId: 0)));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
