import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manvsim/constants/manv_icons.dart';
import 'package:manvsim/models/location.dart';
import 'package:manvsim/models/person.dart';
import 'package:manvsim/services/inventory_service.dart';
import 'package:manvsim/services/location_service.dart';
import 'package:manvsim/widgets/location/location_overview.dart';
import 'package:manvsim/widgets/location/resource_directory.dart';
import 'package:manvsim/widgets/location/transfer_dialogue.dart';
import 'package:manvsim/widgets/player/player_list.dart';
import 'package:manvsim/widgets/util/custom_future_builder.dart';

class LocationScreen extends StatefulWidget {
  final int locationId;

  const LocationScreen({super.key, required this.locationId});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> with SingleTickerProviderStateMixin{
  late Future<Location?> _futureLocation;
  late Future<List<Location>?> _futureInventory;
  late Future<Persons> _futurePersons;

  late Location _fetchedLocation;

  late TabController _tabController;

  List<Location>? _selectedInventoryPath;
  List<Location>? _selectedLocationPath;

  bool _showInventory = false;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    _futureLocation = _findLocationById(widget.locationId);
    _futureInventory = _getInventory();
    _futurePersons = _getPersonsAtLocation(widget.locationId);
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<Location> _findLocationById(int locationId) {
    return LocationService.fetchLocations().then((locations) =>
        locations.firstWhere((location) => location.id == locationId));
  }

  Future<Persons> _getPersonsAtLocation(int locationId) {
    return LocationService.fetchPersonsAt(locationId);
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

  void _refreshData() {
    setState(() {
      _futureLocation = _findLocationById(widget.locationId);
      _futureInventory = _getInventory();
      _futurePersons = _getPersonsAtLocation(widget.locationId);
    });
  }

  void _completeTransfer() {
    setState(() {
      _selectedInventoryPath = null;
      _selectedLocationPath = null;
    });
    _refreshData();
  }

  Tab _buildTab(String title, IconData icon) {
    return Tab(
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon),
        const SizedBox(
          width: 8,
        ),
        Text(title),
      ]),
    );
  }

  Widget _buildTabView(Location location, List<Widget> children, bool expanded) {
    return RefreshIndicator(
        onRefresh: () => Future(() => _refreshData()),
        child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(children: [
              Card(
                  child: LocationOverview(
                      initiallyExpanded: expanded, location: location,)),
              ...children
            ])));
  }

  Widget _buildOverview(Location location) {
    return _buildTabView(
        location,
        [
          Text(
            AppLocalizations.of(context)!.patientScreenClassification,
            textAlign: TextAlign.center,
          ),
          CustomFutureBuilder(future: _futurePersons, builder: (context, persons) {
            return PlayerList(persons: persons);
          }),
        ],
        true);
  }

  Widget _buildTransfer(Location location) {
    return _buildTabView(
        location,
        [
          Text(AppLocalizations.of(context)!
              .locationScreenAvailableSubLocations),
          _buildLocationDirectory(location),
          if (_showInventory) _buildInventory(),
        ],
        false);
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
            ],
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              _buildTab(
                  AppLocalizations.of(context)!.patientScreenTabOverview,
                  ManvIcons.patient),
              _buildTab(
                  AppLocalizations.of(context)!.patientScreenTabActions,
                  Icons.shopping_bag),
            ],
          ),),
        body: CustomFutureBuilder<Location>(
            future: _futureLocation,
            builder: (context, location) {
              _fetchedLocation = location;

              return TabBarView(
                controller: _tabController,
                children: [
                  _buildOverview(location),
                  _buildTransfer(location),
                ],
              );
            }),
        bottomNavigationBar: _tabController.index == 1 ?_buildButtonBar() : null);
  }
}
