//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of manv_api;


class DefaultApi {
  DefaultApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Login
  ///
  /// Performs a login for a requesting TAN. If the TAN is registered to a registered execution, a JWT Token is generated, containing the related execution-id and player-TAN as identity. The method returns: - JWT Token - CSRF Token (required for following POST request) - Boolean if player has no name yet - username - user-role 
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] TAN:
  ///   The TAN of the player.
  Future<Response> loginPostWithHttpInfo({ String? TAN, }) async {
    // ignore: prefer_const_declarations
    final path = r'/login';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/x-www-form-urlencoded'];

    if (TAN != null) {
      formParams[r'TAN'] = parameterToString(TAN);
    }

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Login
  ///
  /// Performs a login for a requesting TAN. If the TAN is registered to a registered execution, a JWT Token is generated, containing the related execution-id and player-TAN as identity. The method returns: - JWT Token - CSRF Token (required for following POST request) - Boolean if player has no name yet - username - user-role 
  ///
  /// Parameters:
  ///
  /// * [String] TAN:
  ///   The TAN of the player.
  Future<LoginPost200Response?> loginPost({ String? TAN, }) async {
    final response = await loginPostWithHttpInfo( TAN: TAN, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'LoginPost200Response',) as LoginPost200Response;
    
    }
    return null;
  }

  /// Set Player Name
  ///
  /// Changes the name of the requesting player.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] name:
  ///   The new name of the player.
  Future<Response> playerSetNamePostWithHttpInfo({ String? name, }) async {
    // ignore: prefer_const_declarations
    final path = r'/player/set-name';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/x-www-form-urlencoded'];

    if (name != null) {
      formParams[r'name'] = parameterToString(name);
    }

    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Set Player Name
  ///
  /// Changes the name of the requesting player.
  ///
  /// Parameters:
  ///
  /// * [String] name:
  ///   The new name of the player.
  Future<String?> playerSetNamePost({ String? name, }) async {
    final response = await playerSetNamePostWithHttpInfo( name: name, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'String',) as String;
    
    }
    return null;
  }
}
