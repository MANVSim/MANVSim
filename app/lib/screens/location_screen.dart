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

  _handleTransfer(BuildContext context, TransferDialogueType transferType) {
    showDialog(
      context: context,
      builder: (context) => TransferDialogue(
        operation: transferType,
        baseLocation: _fetchedLocation,
        locationPath: _selectedLocationPath,
        inventoryPath: _selectedInventoryPath,
      ),
    ).then((value) => _completeTransfer());
  }

  _refreshData() {
    setState(() {
      _futureLocation = _findLocationById(widget.locationId);
      _futureInventory = _getInventory();
    });
  }

  _completeTransfer() {
    setState(() {
      _selectedInventoryPath = null;
      _selectedLocationPath = null;
    });
    _refreshData();

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

            return RefreshIndicator(
                onRefresh: () => _refreshData(),
                child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child:

                    Column(children: [
              Card(child: LocationOverview(location: location)),
              Text(AppLocalizations.of(context)!
                  .locationScreenAvailableSubLocations),
              Column(children: [
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
                      ]),
              if (_showInventory)
              Column(children: [
                Text(AppLocalizations.of(context)!.locationScreenInventory),
                ApiFutureBuilder<List<Location>>(
                    future: _futureInventory,
                    builder: (context, inventory) {
                      return Column(children: [
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
                              ]);
                    })
              ]),
            ])));
          }),
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _canTake()
                      ? () =>
                          _handleTransfer(context, TransferDialogueType.take)
                      : null,
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
                    onPressed: _canPut()
                        ? () =>
                            _handleTransfer(context, TransferDialogueType.put)
                        : null,
                    child:
                        Text(AppLocalizations.of(context)!.locationScreenPut),
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
                  Row(
                    children: [
                      const SizedBox(
                        width: 8,
                      ),
                      Text(AppLocalizations.of(context)!.locationScreenShowInventory,)
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
                ],
              ),
    );
  }


}