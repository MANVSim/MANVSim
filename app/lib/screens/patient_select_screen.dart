import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:manvsim/services/patient_service.dart';
import 'package:manvsim/widgets/logout_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PatientSelectScreen extends StatefulWidget {
  const PatientSelectScreen({super.key});

  @override
  State<StatefulWidget> createState() => PatientSelectScreenState();
}

class PatientSelectScreenState extends State<PatientSelectScreen> {
  final _idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(AppLocalizations.of(context)!.patientSelectScreenName),
        actions: const <Widget>[LogoutButton()],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)!.patientSelectTextField,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              const SizedBox(height: 32),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.qr_code_scanner),
                    label: Text(AppLocalizations.of(context)!.qrCodeScanButton),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 8),
                ValueListenableBuilder(
                  valueListenable: _idController,
                  builder: (context, value, child) => Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.person),
                      onPressed: value.text.isEmpty
                          ? null
                          : () => PatientService.goToPatientPage(
                              int.parse(_idController.text), context),
                      label: Text(
                          AppLocalizations.of(context)!.patientSelectSubmit),
                    ),
                  ),
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
