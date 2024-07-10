import 'package:get_it/get_it.dart';
import 'package:manvsim/models/location.dart';
import 'package:manvsim/services/api_service.dart';

class LocationService {
  static Future<List<Location>> fetchLocations() async {
    ApiService apiService = GetIt.instance.get<ApiService>();
    // TODO
    return apiService.api.runLocationAllGet().then(
        (value) => value!.locations.map((e) => Location.fromApi(e)).toList());
  }

  static Future<String?> leaveLocation() {
    ApiService apiService = GetIt.instance.get<ApiService>();
    return apiService.api
        .runLocationLeavePost()
        .then((value) => value?.message);
  }
}
