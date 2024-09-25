import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manvsim/models/location.dart';
import 'package:manvsim/models/person.dart';
import 'package:manvsim/services/api_service.dart';
import 'package:manvsim/widgets/location/location_screen.dart';

/// Provides methods to manage [Location].
///
/// Doesn't offer error handling.
class LocationService {
  static Future<List<Location>> fetchLocations() async {
    ApiService apiService = GetIt.instance.get<ApiService>();
    return apiService.api
        .runLocationAllGet()
        .then((response) => response!.locations.map(Location.fromApi).toList());
  }

  static Future<String?> leaveLocation() {
    ApiService apiService = GetIt.instance.get<ApiService>();
    return apiService.api
        .runLocationLeavePost()
        .then((response) => response?.message);
  }

  static Future<Persons> fetchPersonsAt(int locationId) async {
    ApiService apiService = GetIt.instance.get<ApiService>();
    return apiService.api
        .runLocationPersonsGet(locationId)
        .then((response) => Persons.fromApi(response!));
  }

  static Future goToLocationScreen(int locationId, BuildContext context) {
    return Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LocationScreen(locationId: locationId)))
        .whenComplete(() => {});
  }
}
