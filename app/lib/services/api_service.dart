import 'package:manv_api/api.dart';


class _JwtCsrfAuth implements Authentication {

  _JwtCsrfAuth(this.jwtToken);

  final String jwtToken;

  @override
  Future<void> applyToParams(List<QueryParam> queryParams, Map<String, String> headerParams) async {
    headerParams['Authorization'] = 'Bearer $jwtToken';
  }
}

class ApiService {

  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  DefaultApi? _apiClient;
  bool _isNameSet = false;


  /// The API client to use for all requests
  /// Only available after a successful login
  DefaultApi get api => _apiClient!;


  /// Whether the user has to set its name after login
  bool get isNameSet => _isNameSet;


  /// Logs in the user with the given TAN and URL
  /// Initializes the API client to use JWT and CSRF tokens
  login(String tan, String url) async {

    DefaultApi apiClient = DefaultApi(ApiClient(basePath: url));
    LoginPost200Response? loginResponse = await apiClient.loginPost(LoginPostRequest(TAN: tan));

    if (loginResponse == null) {
      throw Exception("Login failed: No response body received");
    }

    if (loginResponse.jwtToken == null) {
      throw Exception("Login failed: No JWT token received");
    }

    if (loginResponse.userCreationRequired == null) {
      throw Exception("Login failed: User information missing: userCreationRequired");
    }

    final Authentication auth = _JwtCsrfAuth(loginResponse.jwtToken!);
    _apiClient = DefaultApi(ApiClient(basePath: url, authentication: auth));

    _isNameSet = !loginResponse.userCreationRequired!;

  }
}

