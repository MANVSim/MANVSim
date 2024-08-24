import 'package:get_it/get_it.dart';
import 'package:manvsim/models/location.dart';

import 'api_service.dart';

class PlayerService {
  static Future<List<Location>> getInventory() async {
    ApiService apiService = GetIt.instance.get<ApiService>();
    return await apiService.api
        .runPlayerInventoryGet()
        .then((response) => (response?.accessibleLocations != null)
        ? response!.accessibleLocations.map((dto) => Location.fromApi(dto)).toList()
        : []);
  }
}