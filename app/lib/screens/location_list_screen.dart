import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manvsim/constants/manv_icons.dart';
import 'package:manvsim/models/location.dart';
import 'package:manvsim/services/api_service.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../services/location_service.dart';
import 'base_list_screen.dart';

class LocationListScreen extends StatelessWidget {
  const LocationListScreen({super.key});

  Future<BaseListScreenItems> fetchLocations() {
    ApiService apiService = GetIt.instance.get<ApiService>();
    return apiService.api
        .runLocationAllGet()
        .then((response) => response!.locations.map(Location.fromApi).toList())
        .then((locations) => locations
            .map((location) => BaseListScreenItem(location.name, location.id))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return BaseListScreen(
      title: AppLocalizations.of(context)!.locationListScreenName,
      fetchFutureItemList: fetchLocations,
      icon: ManvIcons.location,
      nameFromId: AppLocalizations.of(context)!.locationNameFromId,
      onItemTap: (context, item) =>
          LocationService.goToLocationScreen(item.id, context),
    );
  }
}
