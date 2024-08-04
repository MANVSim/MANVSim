import 'package:flutter/material.dart';
import 'package:manvsim/models/location.dart';

import 'package:manvsim/services/location_service.dart';
import 'package:manvsim/widgets/LocationOverview.dart';
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

  @override
  void initState() {

    // TODO arrive at location
    super.initState();
    futureLocation = _findLocationById(widget.locationId);
  }

  _findLocationById(int locationId) {
    return LocationService.fetchLocations()
        .then((locations) => locations
            .firstWhere((location) => location.id == locationId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(AppLocalizations.of(context)!
              .patientScreenName(widget.locationId)),
          actions: const <Widget>[LogoutButton()],
        ),
        body: RefreshIndicator(
            onRefresh: () => refresh(null),
            child: ApiFutureBuilder<Location>(
                future: futureLocation,
                builder: (context, location) {
                  return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(children: [
                        Card(child: LocationOverview(location: location)),
                        ResourceDirectory(
                            locations: [location], resourceToggle: (resource) => {}),
                      ]));
                })));
  }

  Future refresh(Location? location) {


    setState(() {
      // TODO leave and arrive at location
      futureLocation = location != null
          ? Future(() => location)
          : _findLocationById(widget.locationId);
    });
    return futureLocation;
  }
}
