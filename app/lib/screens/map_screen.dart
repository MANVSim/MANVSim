import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manvsim/models/map_data.dart';
import 'package:manvsim/services/map_service.dart';
import 'package:manvsim/widgets/api_future_builder.dart';
import 'package:manvsim/widgets/logout_button.dart';
import 'package:manvsim/widgets/map_overlay.dart';

class PatientMapScreen extends StatefulWidget {
  const PatientMapScreen({super.key});

  @override
  State<PatientMapScreen> createState() => _PatientMapScreenState();
}

class _PatientMapScreenState extends State<PatientMapScreen> {
  late Future<MapData?> futureMapData;

  @override
  void initState() {
    futureMapData = MapService.fetchMapData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(AppLocalizations.of(context)!.mapScreenName),
        actions: const <Widget>[LogoutButton()],
      ),
      body: RefreshIndicator(
          onRefresh: () {
            setState(() {
              futureMapData = MapService.fetchMapData();
            });
            return futureMapData;
          },
          child: ApiFutureBuilder<MapData>(
              future: futureMapData,
              builder: (context, mapData) =>
                  Center(child: PatientMapOverlay(mapData: mapData)))),
    );
  }
}
