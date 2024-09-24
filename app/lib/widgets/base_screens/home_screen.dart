import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manvsim/constants/manv_icons.dart';
import 'package:manvsim/services/location_service.dart';
import 'package:manvsim/services/patient_service.dart';
import 'package:manvsim/widgets/player/player_overview.dart';
import 'package:manvsim/widgets/util/error_box.dart';
import 'package:manvsim/widgets/util/qr_screen.dart';

import '../../services/size_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final _idController = TextEditingController();

  final List<bool> _selectedSearchType = [true, false];

  String? _qrCodeError;

  final List<Icon> _selectedIcon = [
    const Icon(ManvIcons.patient),
    const Icon(ManvIcons.location)
  ];

  handleScan(TextEditingController textController) async {
    final scannedQR = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QRScreen(),
      ),
    );
    if (scannedQR case String scannedText) {
      final splitScan = scannedText.split(';');
      if (splitScan.length != 2) {
        setState(() {
          _qrCodeError = AppLocalizations.of(context)!.homeScreenQrCodeError;
        });
        return;
      }

      setState(() {
        if (splitScan[0].toLowerCase() == 'patient') {
          _selectedSearchType[0] = true;
          _selectedSearchType[1] = false;
        } else if (splitScan[0].toLowerCase() == 'location') {
          _selectedSearchType[0] = false;
          _selectedSearchType[1] = true;
        } else {
          _qrCodeError = AppLocalizations.of(context)!.homeScreenQrCodeError;
          return;
        }

        try {
          int id = int.parse(splitScan[1]);
          textController.text = id.toString();
          _qrCodeError = null;
        } catch (e) {
          _qrCodeError = AppLocalizations.of(context)!.homeScreenQrCodeError;
          return;
        }
      });
    } else {
      setState(() {
        _qrCodeError = AppLocalizations.of(context)!.homeScreenQrCodeError;
      });
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
      AppLocalizations.of(context)!.homeScreenTypePatient,
      AppLocalizations.of(context)!.homeScreenTypeLocation
    ];

    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.homeScreenName),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const PlayerOverview(),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_qrCodeError != null) ...[
                      ErrorBox(errorText: _qrCodeError!),
                      const SizedBox(height: 8)
                    ],
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
                      constraints: BoxConstraints(
                          minWidth:
                              (SizeService.getScreenWidth(context) - 20) / 2),
                      children: [
                        Row(children: [_selectedIcon[0], Text(searchType[0])]),
                        Row(children: [_selectedIcon[1], Text(searchType[1])])
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _idController,
                      onChanged: (value) {
                        setState(() {
                          _qrCodeError = null;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!
                            .homeScreenTextField(_selectedSearchType[0]
                                ? searchType[0]
                                : searchType[1]),
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
                          label: Text(
                              AppLocalizations.of(context)!.qrCodeScanButton),
                          onPressed: () async => handleScan(_idController),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ValueListenableBuilder(
                        valueListenable: _idController,
                        builder: (context, patientIdValue, child) => Expanded(
                          child: ElevatedButton.icon(
                            icon: _selectedSearchType[0]
                                ? _selectedIcon[0]
                                : _selectedIcon[1],
                            onPressed: patientIdValue.text.isEmpty
                                ? null
                                : () => handleSubmit(),
                            label: Text(
                              AppLocalizations.of(context)!.homeScreenSubmit(
                                  _selectedSearchType[0]
                                      ? searchType[0]
                                      : searchType[1]),
                            ),
                          ),
                        ),
                      ),
                    ])
                  ],
                ),
              ),
            ),
          )
        ]));
  }
}
