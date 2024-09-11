import 'package:get_it/get_it.dart';
import 'package:manvsim/models/map_data.dart';
import 'package:manvsim/services/api_service.dart';

/// Provides methods to manage map data and positions.
///
/// Doesn't offer error handling.
class MapService {
  static Future<MapData?> fetchMapData() async {
    ApiService apiService = GetIt.instance.get<ApiService>();
    return apiService.api
        .runMapdataGet()
        .then((value) => value != null ? MapData.fromApi(value) : null);
  }
}
