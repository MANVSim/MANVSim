import 'package:flutter/material.dart';
import 'package:manv_api/api.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../screens/login_screen.dart';


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

  handleErrorCode(ApiException e, BuildContext context) {
    if (e.code == 401) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.unauthorizedBearerAlertHeader),
            content: Text(AppLocalizations.of(context)!.unauthorizedBearerAlertBody),
            actions: <Widget>[
              TextButton(
                child: Text(AppLocalizations.of(context)!.unauthorizedBearerAlertButton),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (Route<dynamic> route) => false, // Removes all previous routes
                  );
                },
              ),
            ],
          );
        },
      );

      return true;

    }

    return false;
  }

}



