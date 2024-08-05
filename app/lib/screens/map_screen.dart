import 'package:flutter/material.dart';
import 'package:manvsim/widgets/logout_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PatientMapScreen extends StatefulWidget {
  const PatientMapScreen({super.key});

  @override
  State<StatefulWidget> createState() => PatientMapScreenState();
}

class PatientMapScreenState extends State<PatientMapScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(AppLocalizations.of(context)!.patientSelectScreenName),
        actions: const <Widget>[LogoutButton()],
      ),
      body: const Center(child: SingleChildScrollView(child: Placeholder())),
    );
  }
}
