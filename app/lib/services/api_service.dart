import 'package:flutter/material.dart';
import 'package:manv_api/api.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manvsim/models/tan_user.dart';
import 'package:provider/provider.dart';

import '../screens/login_screen.dart';

class _JwtCsrfAuth implements Authentication {
  _JwtCsrfAuth(this.jwtToken);

  final String jwtToken;

  @override
  Future<void> applyToParams(
      List<QueryParam> queryParams, Map<String, String> headerParams) async {
    headerParams['Authorization'] = 'Bearer $jwtToken';
  }
}

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  ApiService._internal();

  DefaultApi? _apiClient;

  /// The API client to use for all requests.
  /// Only available after a successful login.
  DefaultApi get api => _apiClient!;

  /// Recovers the API client from the user's authentication information.
  /// Initializes the API client to use JWT and CSRF tokens.
  /// Is called when login screen is skipped.
  Future<void> recover(BuildContext context) async {
    TanUser user = Provider.of<TanUser>(context, listen: false);

    if (user.auth.token != null && user.auth.url != null) {
      _apiClient = DefaultApi(ApiClient(
          basePath: user.auth.url!,
          authentication: _JwtCsrfAuth(user.auth.token!)));
    }
  }

  /// Logs in the user with the given TAN and URL.
  /// Initializes the API client to use JWT and CSRF tokens.
  Future<void> login(String tan, String url, BuildContext context) async {
    DefaultApi apiClient = DefaultApi(ApiClient(basePath: url));
    LoginPost200Response? loginResponse =
        await apiClient.loginPost(LoginPostRequest(TAN: tan));

    if (loginResponse == null) {
      throw Exception("Login failed: No response body received");
    }

    final Authentication auth = _JwtCsrfAuth(loginResponse.jwtToken);
    _apiClient = DefaultApi(ApiClient(basePath: url, authentication: auth));

    if (context.mounted) {
      TanUser user = Provider.of<TanUser>(context, listen: false);
      user.auth.token = loginResponse.jwtToken;
      user.auth.url = url;
      user.name = loginResponse.userName;
      user.role = loginResponse.userRole;
      user.tan = tan;
      await user.persist();
    }
  }

  /// Logs out the user
  void logout(BuildContext context) async {
    TanUser user = Provider.of<TanUser>(context, listen: false);
    user.auth.token = null;
    user.auth.url = null;
    user.name = null;
    user.role = null;
    user.tan = null;
    await user.persist();

    _apiClient = null;

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false, // Removes all previous routes
      );
    }
  }

  /// Builds a media URL from a media reference.
  String buildMediaUrl(BuildContext context, String mediaReference) {
    final user = Provider.of<TanUser>(context, listen: false);
    var baseUrl = user.auth.url!;

    if (baseUrl.endsWith('/')) {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }

    if (baseUrl.endsWith('/api')) {
      baseUrl = baseUrl.substring(
          0, baseUrl.length - 4); // Fix substring length for "/api"
    }

    return '$baseUrl/$mediaReference';
  }

  /// Handles some common error codes.
  /// Return value indicates whether the error was handled.
  bool handleErrorCode(ApiException e, BuildContext context) {
    if (e.code != 401 && e.code != 409 && e.code != 422) {
      return false;
    }

    String? messageHeader;
    String? messageBody;

    if (e.code == 401 || e.code == 422) {
      messageHeader =
          AppLocalizations.of(context)!.unauthorizedBearerAlertHeader;
      messageBody = AppLocalizations.of(context)!.unauthorizedBearerAlertBody;
    } else if (e.code == 409) {
      messageHeader = AppLocalizations.of(context)!.waitAlreadyLoggedInHeader;
      messageBody = AppLocalizations.of(context)!.waitAlreadyLoggedInText;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(messageHeader!),
          content: Text(messageBody!),
          actions: <Widget>[
            TextButton(
                child: Text(AppLocalizations.of(context)!.logOutAlertOption),
                onPressed: () => logout(context)),
          ],
        );
      },
    );

    return true;
  }
}
