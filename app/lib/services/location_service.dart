import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manvsim/models/location.dart';
import 'package:manvsim/screens/location_screen.dart';
import 'package:manvsim/services/api_service.dart';

/// Provides methods to manage [Location].
///
/// Doesn't offer error handling.
class LocationService {
  static Future<List<Location>> fetchLocations() async {
    ApiService apiService = GetIt.instance.get<ApiService>();
    // TODO method for getting apiService?
    return apiService.api.runLocationAllGet().then((response) =>
        response!.locations.map((dto) => Location.fromApi(dto)).toList());
  }

  static Future<String?> leaveLocation() {
    ApiService apiService = GetIt.instance.get<ApiService>();
    return apiService.api
        .runLocationLeavePost()
        .then((response) => response?.message);
  }

  static void goToPatientScreen(int locationId, BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LocationScreen(locationId: locationId)))
        .whenComplete(() => {}); // TODO leave location
  }
}
