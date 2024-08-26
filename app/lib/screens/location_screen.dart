import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manvsim/models/location.dart';

import 'package:manvsim/services/location_service.dart';
import 'package:manvsim/services/player_service.dart';
import 'package:manvsim/widgets/location_overview.dart';
import 'package:manvsim/widgets/api_future_builder.dart';
import 'package:manvsim/widgets/logout_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manvsim/widgets/transfer_dialogue.dart';

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

  bool _showInventory = false;

  @override
  void initState() {
    super.initState();
    _futureLocation = _findLocationById(widget.locationId);
    _futureInventory = _getInventory();
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
      showDialog(
        context: context,
        builder: (context) => TransferDialogue(
          operation: TransferDialogueType.take,
          baseLocation: _fetchedLocation,
          locationPath: _selectedLocationPath,
          inventoryPath: _selectedInventoryPath,
        ),
      );
    }
  }

  _handlePut() {
    if (_canPut()) {
      showDialog(
        context: context,
        builder: (context) => TransferDialogue(
          operation: TransferDialogueType.put,
          baseLocation: _fetchedLocation,
          locationPath: _selectedLocationPath,
          inventoryPath: _selectedInventoryPath,
        ),
      );
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
              if (_showInventory)
              Column(children: [
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
                    })
              ]),
            ]);
          }),
      bottomNavigationBar: Container(
        child:
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _canTake() ? _handleTake : null,
                        child: Text(AppLocalizations.of(context)!.locationScreenTake),
                      ),
                    ),
                  ),
                ),
                if (_showInventory)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _canPut() ? _handlePut : null,
                        child: Text(AppLocalizations.of(context)!.locationScreenPut),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {


                        setState(() {
                          _selectedInventoryPath = null;
                          _showInventory = !_showInventory;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _showInventory
                            ? Colors.lightGreen
                            : null,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.inventory_2_outlined),
                      if (!_showInventory)
                        const Row(
                          children: [
                            SizedBox(
                              width: 8,
                            ),
                            Text("Inventar \nanzeigen"),
                          ],
                        )
                    ],
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
