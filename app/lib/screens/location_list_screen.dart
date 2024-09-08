import 'package:flutter/material.dart';
import 'package:manvsim/models/location.dart';
import 'package:manvsim/services/location_service.dart';

import 'package:manvsim/widgets/api_future_builder.dart';
import 'package:manvsim/widgets/logout_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:manvsim/constants/manv_icons.dart';

class LocationListScreen extends StatefulWidget {
  const LocationListScreen({super.key});

  @override
  State<LocationListScreen> createState() => _LocationListScreenState();
}

class _LocationListScreenState extends State<LocationListScreen> {
  late Future<List<Location>?> futureLocationIdList;
  final List<bool> _selectedShowAs = [true, false];

  @override
  void initState() {
    futureLocationIdList = LocationService.fetchLocations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> showAs = [
      AppLocalizations.of(context)!.locationListScreenTypeName,
      AppLocalizations.of(context)!.locationListScreenTypeId,
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(AppLocalizations.of(context)!.locationListScreenName),
        actions: const <Widget>[LogoutButton()],
      ),
      body: Column(children: [
        const SizedBox(height: 4),
        ToggleButtons(
          onPressed: (int index) {
            setState(() {
              // The button that is tapped is set to true, and the others to false.
              for (int i = 0; i < _selectedShowAs.length; i++) {
                _selectedShowAs[i] = i == index;
              }
            });
          },
          borderRadius: BorderRadius.circular(2),
          isSelected: _selectedShowAs,
          constraints: BoxConstraints(
              minWidth: (MediaQuery.of(context).size.width - 8) / 2),
          children: [
            Text(showAs[0]),
            Text(showAs[1]),
          ],
        ),
        Expanded(
            child: RefreshIndicator(
          onRefresh: () {
            setState(() {
              futureLocationIdList = LocationService.fetchLocations();
            });
            return futureLocationIdList;
          },
          child: ApiFutureBuilder<List<Location>>(
              future: futureLocationIdList,
              builder: (context, locationIds) => ListView.builder(
                  itemCount: locationIds.length,
                  itemBuilder: (context, index) => Card(
                      child: ListTile(
                          leading: const Icon(ManvIcons.location),
                          title: Text(_selectedShowAs[0]
                              ? locationIds[index].name
                              : AppLocalizations.of(context)!
                                  .locationNameFromId(locationIds[index].id)),
                          onTap: () => LocationService.goToLocationScreen(
                              locationIds[index].id, context))))),
        ))
      ]),
    );
  }
}
