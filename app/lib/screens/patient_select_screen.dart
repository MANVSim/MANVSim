import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manvsim/screens/qr_screen.dart';
import 'package:manvsim/services/location_service.dart';
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

  final List<bool> _selectedSearchType = [true, false];

  final List<Icon> _selectedIcon = [
    const Icon(Icons.person),
    const Icon(Icons.map)
  ];

  handleScan(TextEditingController textController) async {
    final scannedQR = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QRScreen(),
      ),
    );
    if (scannedQR case String scannedText) {
      // TODO check only digits (maybe also error handling)
      textController.text = scannedText;
    }
  }

  handleSubmit() {
    int id = int.parse(_idController.text);
    if (_selectedSearchType[0]) {
      PatientService.goToPatientScreen(id, context);
    } else {
      LocationService.goToLocationScreen(id, context);
    }
  }

  @override
  Widget build(BuildContext context) {

    final List<String> searchType = [
      AppLocalizations.of(context)!.selectScreenTypePatient,
      AppLocalizations.of(context)!.selectScreenTypeLocation
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(AppLocalizations.of(context)!.selectScreenName),
        actions: const <Widget>[LogoutButton()],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ToggleButtons(
                onPressed: (int index) {
                  setState(() {
                    // The button that is tapped is set to true, and the others to false.
                    for (int i = 0; i < _selectedSearchType.length; i++) {
                      _selectedSearchType[i] = i == index;
                    }
                  });
                },
                borderRadius: BorderRadius.circular(2),
                isSelected: _selectedSearchType,
                constraints: BoxConstraints(minWidth: (MediaQuery.of(context).size.width - 20) / 2),
                children: [
                  Row(children: [_selectedIcon[0], Text(searchType[0])]),
                  Row(children: [_selectedIcon[1],  Text(searchType[1])])
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.selectScreenTextField(_selectedSearchType[0] ? searchType[0] : searchType[1]),
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
                    onPressed: () async => handleScan(_idController),
                  ),
                ),
                const SizedBox(width: 8),
                ValueListenableBuilder(
                  valueListenable: _idController,
                  builder: (context, patientIdValue, child) => Expanded(
                    child: ElevatedButton.icon(
                      icon: _selectedSearchType[0] ? _selectedIcon[0] : _selectedIcon[1],
                      onPressed: patientIdValue.text.isEmpty
                          ? null
                          : () => handleSubmit(),
                      label: Text(
                          AppLocalizations.of(context)!.selectScreenSubmit(_selectedSearchType[0] ? searchType[0] : searchType[1]),),
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
