import 'package:flutter/material.dart';
import 'package:manvsim/models/location.dart';

import 'package:manvsim/services/location_service.dart';
import 'package:manvsim/services/player_service.dart';
import 'package:manvsim/widgets/location_overview.dart';
import 'package:manvsim/widgets/api_future_builder.dart';
import 'package:manvsim/widgets/logout_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/resource_directory.dart';

class LocationScreen extends StatefulWidget {
  final int locationId;

  const LocationScreen({super.key, required this.locationId});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late Future<Location?> futureLocation;
  late Future<List<Location>?> futureInventory;

  List<int>? selectedInventoryIdPath;
  List<int>? selectedLocationIdPath;

  @override
  void initState() {
    super.initState();
    futureLocation = _findLocationById(widget.locationId);
    futureInventory = _getInventory();
  }

  _findLocationById(int locationId) {
    return LocationService.fetchLocations().then((locations) =>
        locations.firstWhere((location) => location.id == locationId));
  }

  _getInventory() {
    return PlayerService.getInventory();
  }

  _canTake() {
    return selectedLocationIdPath != null;
  }

  _canPut() {
    return selectedInventoryIdPath != null;
  }

  _handleTake() {
    if (_canTake()) {

    }
  }

  _handlePut() {
    if (_canPut()) {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(AppLocalizations.of(context)!.locationScreenName),
          actions: const <Widget>[LogoutButton()],
        ),
        body: ApiFutureBuilder<Location>(
            future: futureLocation,
            builder: (context, location) {
              return Column(children: [
                Card(child: LocationOverview(location: location)),
                Text(AppLocalizations.of(context)!
                    .locationScreenAvailableSubLocations),
                RefreshIndicator(
                    onRefresh: () => refreshLocation(null),
                    child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(children: [
                          ResourceDirectory(
                            rootLocationsSelectable: false,
                            initiallyExpanded: true,
                            locations: [location],
                            resourceToggle: (resource) => {},
                            onLocationSelected:
                                (currentSelectedLocationIdPath) {
                              setState(() {
                                selectedLocationIdPath =
                                    currentSelectedLocationIdPath;
                              });
                            },
                          ),
                        ]))),
                Text(AppLocalizations.of(context)!.locationScreenInventory),
                ApiFutureBuilder<List<Location>>(
                    future: futureInventory,
                    builder: (context, inventory) {
                      return RefreshIndicator(
                          onRefresh: () => refreshInventory(),
                          child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Column(children: [
                                ResourceDirectory(
                                  locations: inventory,
                                  resourceToggle: (resource) => {},
                                  onLocationSelected:
                                      (currentSelectedLocationIdPath) {
                                    setState(() {
                                      selectedInventoryIdPath =
                                          currentSelectedLocationIdPath;
                                    });
                                  },
                                ),


                              ])));
                    }),
              ]);
            }),

        bottomNavigationBar:   Container(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: _canTake() ? _handleTake : null,
                      child: Text('Nehmen'),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: _canPut() ? _handlePut : null,
                      child: Text('Ablegen'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    );


  }

  Future refreshLocation(Location? location) {
    setState(() {
      futureLocation = location != null
          ? Future(() => location)
          : _findLocationById(widget.locationId);
    });
    return futureLocation;
  }

  Future refreshInventory() {
    setState(() {
      futureInventory = _getInventory();
    });
    return futureInventory;
  }
}
