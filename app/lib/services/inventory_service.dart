import 'package:get_it/get_it.dart';
import 'package:manv_api/api.dart';
import 'package:manvsim/models/location.dart';

import 'api_service.dart';

class InventoryService {
  static Future<List<Location>> getInventory() async {
    ApiService apiService = GetIt.instance.get<ApiService>();
    return await apiService.api.runPlayerInventoryGet().then((response) =>
        (response?.accessibleLocations != null)
            ? response!.accessibleLocations
                .map((dto) => Location.fromApi(dto))
                .toList()
            : []);
  }

  static String _getPathString(List<Location> path) {
    return '[${path.map((e) => e.id).join(",")}]';
  }

  static Future<void> putItem(Location baseLocation,
      List<Location>? inventoryPath, List<Location>? locationPath) async {
    List<Location> newLocationPath = locationPath ?? [baseLocation];
    List<Location> newInventoryPath = inventoryPath!;

    ApiService apiService = GetIt.instance.get<ApiService>();
    await apiService.api.runLocationPutToPost(RunLocationPutToPostRequest(
        putLocationIds: _getPathString(newInventoryPath),
        toLocationIds: _getPathString(newLocationPath)));
  }

  static Future<void> takeItem(Location baseLocation,
      List<Location>? inventoryPath, List<Location>? locationPath) async {
    List<Location> newLocationPath = locationPath!;
    List<Location> newInventoryPath = inventoryPath ?? [];

    ApiService apiService = GetIt.instance.get<ApiService>();
    await apiService.api.runLocationTakeToPost(RunLocationTakeToPostRequest(
        takeLocationIds: _getPathString(newLocationPath),
        toLocationIds: _getPathString(newInventoryPath)));
  }
}
