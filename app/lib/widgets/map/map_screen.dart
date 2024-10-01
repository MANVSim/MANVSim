import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manvsim/constants/manv_icons.dart';
import 'package:manvsim/models/map_data.dart';
import 'package:manvsim/services/map_service.dart';
import 'package:manvsim/widgets/map/map_overlay.dart';
import 'package:manvsim/widgets/util/custom_future_builder.dart';

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

  Future _refresh() {
    setState(() {
      futureMapData = MapService.fetchMapData();
    });
    return futureMapData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.mapScreenName),
          actions: [
            if (kIsWeb)
              IconButton(
                  onPressed: _refresh, icon: const Icon(ManvIcons.refresh))
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: CustomFutureBuilder<MapData>(
              future: futureMapData,
              builder: (context, mapData) => Center(
                  child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Center(
                          child: PatientMapOverlay(
                              mapData: mapData, refreshData: _refresh))))),
        ));
  }
}
