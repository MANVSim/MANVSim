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
  late Future<Location?> _futureLocation;
  late Future<List<Location>?> _futureInventory;

  late Location _fetchedLocation;

  List<Location>? _selectedInventoryPath;
  List<Location>? _selectedLocationPath;

  @override
  void initState() {
    super.initState();
    _futureLocation = _findLocationById(widget.locationId);
    _futureInventory = _getInventory();
  }

  List<String> get _selectedInventoryPathNames {
    String inventoryName = AppLocalizations.of(context)!.locationScreenInventory;
    return _selectedInventoryPath != null
        ? [inventoryName, ..._selectedInventoryPath!.map((e) => e.name)]
        : [inventoryName];
  }

  List<String> get _selectedLocationPathNames {
    return _selectedLocationPath != null
        ? _selectedLocationPath!.map((e) => e.name).toList()
        : [_fetchedLocation.name];
  }

  _findLocationById(int locationId) {
    return LocationService.fetchLocations().then((locations) =>
        locations.firstWhere((location) => location.id == locationId));
  }

  _getInventory() {
    return PlayerService.getInventory();
  }

  _canTake() {
    return _selectedLocationPath != null;
  }

  _canPut() {
    return _selectedInventoryPath != null;
  }

  _handleTake() {
    if (_canTake()) {
      print(_selectedInventoryPathNames);
      print(_selectedLocationPathNames);
    }
  }

  _handlePut() {
    if (_canPut()) {
      print(_selectedInventoryPathNames);
      print(_selectedLocationPathNames);
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
          future: _futureLocation,
          builder: (context, location) {

            _fetchedLocation = location;

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
                          onLocationSelected: (currentSelectedLocationPath) {
                            setState(() {
                              _selectedLocationPath =
                                  currentSelectedLocationPath;
                            });
                          },
                        ),
                      ]))),
              Text(AppLocalizations.of(context)!.locationScreenInventory),
              ApiFutureBuilder<List<Location>>(
                  future: _futureInventory,
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
                                    (currentSelectedLocationPath) {
                                  setState(() {
                                    _selectedInventoryPath =
                                        currentSelectedLocationPath;
                                  });
                                },
                              ),
                            ])));
                  }),
            ]);
          }),
      bottomNavigationBar: Container(
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
      _futureLocation = location != null
          ? Future(() => location)
          : _findLocationById(widget.locationId);
    });
    return _futureLocation;
  }

  Future refreshInventory() {
    setState(() {
      _futureInventory = _getInventory();
    });
    return _futureInventory;
  }
}
