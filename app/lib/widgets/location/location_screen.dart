import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manvsim/constants/manv_icons.dart';
import 'package:manvsim/models/location.dart';
import 'package:manvsim/services/inventory_service.dart';
import 'package:manvsim/services/location_service.dart';
import 'package:manvsim/widgets/location/location_overview.dart';
import 'package:manvsim/widgets/location/resource_directory.dart';
import 'package:manvsim/widgets/location/transfer_dialogue.dart';
import 'package:manvsim/widgets/util/custom_future_builder.dart';

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

  Future<Location> _findLocationById(int locationId) {
    return LocationService.fetchLocations().then((locations) =>
        locations.firstWhere((location) => location.id == locationId));
  }

  Future<List<Location>> _getInventory() {
    return InventoryService.getInventory();
  }

  bool _canTake() {
    return _selectedLocationPath != null;
  }

  bool _canPut() {
    return _selectedInventoryPath != null;
  }

  void _handleTransfer(
      BuildContext context, TransferDialogueType transferType) {
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

  Future _refreshData() {
    setState(() {
      _futureLocation = _findLocationById(widget.locationId);
      _futureInventory = _getInventory();
    });
    return _futureInventory;
  }

  void _completeTransfer() {
    setState(() {
      _selectedInventoryPath = null;
      _selectedLocationPath = null;
    });
    _refreshData();
  }

  Widget _buildButtonBar() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _canTake()
                    ? () => _handleTransfer(context, TransferDialogueType.take)
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
                      ? () => _handleTransfer(context, TransferDialogueType.put)
                      : null,
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
                backgroundColor: _showInventory ? Colors.lightGreen : null,
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
                        Text(
                          AppLocalizations.of(context)!
                              .locationScreenShowInventory,
                        )
                      ],
                    )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInventory() {
    return Column(children: [
      Text(AppLocalizations.of(context)!.locationScreenInventory),
      CustomFutureBuilder<List<Location>>(
          future: _futureInventory,
          builder: (context, inventory) {
            return inventory.isEmpty
                ? Card(
                    child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(AppLocalizations.of(context)!
                                .locationScreenInventoryEmpty))))
                : Column(children: [
                    ResourceDirectory(
                      locations: inventory,
                      resourceToggle: (resource) => {},
                      onLocationSelected: (currentSelectedLocationPath) {
                        setState(() {
                          _selectedInventoryPath = currentSelectedLocationPath;
                        });
                      },
                    ),
                  ]);
          })
    ]);
  }

  Widget _buildLocationDirectory(Location location) {
    return (location.resources.isEmpty && location.locations.isEmpty)
        ? Card(
            child: SizedBox(
                width: double.infinity,
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(AppLocalizations.of(context)!
                        .locationScreenNoResources))))
        : Column(children: [
            ResourceDirectory(
              rootLocationsSelectable: false,
              initiallyExpanded: true,
              locations: [location],
              resourceToggle: (resource) => {},
              onLocationSelected: (currentSelectedLocationPath) {
                setState(() {
                  _selectedLocationPath = currentSelectedLocationPath;
                });
              },
            ),
          ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(AppLocalizations.of(context)!.locationScreenName),
            actions: [
              if (kIsWeb)
                IconButton(
                    onPressed: _refreshData,
                    icon: const Icon(ManvIcons.refresh))
            ]),
        body: CustomFutureBuilder<Location>(
            future: _futureLocation,
            builder: (context, location) {
              _fetchedLocation = location;

              return RefreshIndicator(
                  onRefresh: _refreshData,
                  child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(children: [
                        Card(child: LocationOverview(location: location)),
                        Text(AppLocalizations.of(context)!
                            .locationScreenAvailableSubLocations),
                        _buildLocationDirectory(location),
                        if (_showInventory) _buildInventory(),
                      ])));
            }),
        bottomNavigationBar: _buildButtonBar());
  }
}
