import 'package:manv_api/api.dart';


class AuthenticationService {

  static final AuthenticationService _instance = AuthenticationService._internal();
  factory AuthenticationService() => _instance;
  AuthenticationService._internal();

  DefaultApi? _apiClient;
  bool _isLoggedIn = false;
  bool _isNameSet = false;
  String? _jwtToken;


  bool get isNameSet => _isNameSet;

  Future<String?> login(String tan, String url) async {

    _apiClient = DefaultApi(ApiClient(basePath: url));

    try {
      LoginPost200Response? loginResponse = await _apiClient!.loginPost(TAN: tan);
      _isNameSet = loginResponse!.userCreationRequired!;
      _jwtToken = loginResponse.jwtToken!;
      _isLoggedIn = true;
      return null;
    } on Exception catch (e) {
      print(e);
      return e.toString();
    }
  }
}

