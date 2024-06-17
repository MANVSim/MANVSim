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

  /// TAN Login
  ///
  /// authenticates a user with a TAN and returns a JWT token
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [LoginPostRequest] loginPostRequest (required):
  Future<Response> loginPostWithHttpInfo(LoginPostRequest loginPostRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/login';

    // ignore: prefer_final_locals
    Object? postBody = loginPostRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


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

  /// TAN Login
  ///
  /// authenticates a user with a TAN and returns a JWT token
  ///
  /// Parameters:
  ///
  /// * [LoginPostRequest] loginPostRequest (required):
  Future<LoginPost200Response?> loginPost(LoginPostRequest loginPostRequest,) async {
    final response = await loginPostWithHttpInfo(loginPostRequest,);
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

  /// notification polling
  ///
  /// Returns a list of notifications for the user after lastPollTime.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [DateTime] lastPollTime:
  Future<Response> notificationsGetWithHttpInfo({ DateTime? lastPollTime, }) async {
    // ignore: prefer_const_declarations
    final path = r'/notifications';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (lastPollTime != null) {
      queryParams.addAll(_queryParams('', 'lastPollTime', lastPollTime));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// notification polling
  ///
  /// Returns a list of notifications for the user after lastPollTime.
  ///
  /// Parameters:
  ///
  /// * [DateTime] lastPollTime:
  Future<NotificationsGet200Response?> notificationsGet({ DateTime? lastPollTime, }) async {
    final response = await notificationsGetWithHttpInfo( lastPollTime: lastPollTime, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'NotificationsGet200Response',) as NotificationsGet200Response;
    
    }
    return null;
  }

  /// Set username for the TAN
  ///
  /// Sets the name for the TAN provided in JWT.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [PlayerSetNamePostRequest] playerSetNamePostRequest (required):
  ///
  /// * [String] xCSRFToken (required):
  Future<Response> playerSetNamePostWithHttpInfo(PlayerSetNamePostRequest playerSetNamePostRequest, String xCSRFToken,) async {
    // ignore: prefer_const_declarations
    final path = r'/player/set-name';

    // ignore: prefer_final_locals
    Object? postBody = playerSetNamePostRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    headerParams[r'X-CSRFToken'] = parameterToString(xCSRFToken);

    const contentTypes = <String>['application/json'];


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

  /// Set username for the TAN
  ///
  /// Sets the name for the TAN provided in JWT.
  ///
  /// Parameters:
  ///
  /// * [PlayerSetNamePostRequest] playerSetNamePostRequest (required):
  ///
  /// * [String] xCSRFToken (required):
  Future<void> playerSetNamePost(PlayerSetNamePostRequest playerSetNamePostRequest, String xCSRFToken,) async {
    final response = await playerSetNamePostWithHttpInfo(playerSetNamePostRequest, xCSRFToken,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Returns a list of actions available to the user.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> runActionAllGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/run/action/all';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Returns a list of actions available to the user.
  Future<List<Action>?> runActionAllGet() async {
    final response = await runActionAllGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<Action>') as List)
        .cast<Action>()
        .toList(growable: false);

    }
    return null;
  }

  /// Performs an action.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [RunActionPerformPostRequest] runActionPerformPostRequest (required):
  ///
  /// * [String] xCSRFToken (required):
  Future<Response> runActionPerformPostWithHttpInfo(RunActionPerformPostRequest runActionPerformPostRequest, String xCSRFToken,) async {
    // ignore: prefer_const_declarations
    final path = r'/run/action/perform';

    // ignore: prefer_final_locals
    Object? postBody = runActionPerformPostRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    headerParams[r'X-CSRFToken'] = parameterToString(xCSRFToken);

    const contentTypes = <String>['application/json'];


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

  /// Performs an action.
  ///
  /// Parameters:
  ///
  /// * [RunActionPerformPostRequest] runActionPerformPostRequest (required):
  ///
  /// * [String] xCSRFToken (required):
  Future<RunActionPerformPost200Response?> runActionPerformPost(RunActionPerformPostRequest runActionPerformPostRequest, String xCSRFToken,) async {
    final response = await runActionPerformPostWithHttpInfo(runActionPerformPostRequest, xCSRFToken,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'RunActionPerformPost200Response',) as RunActionPerformPost200Response;
    
    }
    return null;
  }

  /// Gets the result of a performed action.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] performedActionId (required):
  ///
  /// * [String] patientId (required):
  Future<Response> runActionPerformResultGetWithHttpInfo(String performedActionId, String patientId,) async {
    // ignore: prefer_const_declarations
    final path = r'/run/action/perform/result';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'performed_action_id', performedActionId));
      queryParams.addAll(_queryParams('', 'patient_id', patientId));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Gets the result of a performed action.
  ///
  /// Parameters:
  ///
  /// * [String] performedActionId (required):
  ///
  /// * [String] patientId (required):
  Future<RunActionPerformResultGet200Response?> runActionPerformResultGet(String performedActionId, String patientId,) async {
    final response = await runActionPerformResultGetWithHttpInfo(performedActionId, patientId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'RunActionPerformResultGet200Response',) as RunActionPerformResultGet200Response;
    
    }
    return null;
  }

  /// Returns a list of locations.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> runLocationAllGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/run/location/all';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Returns a list of locations.
  Future<RunLocationAllGet200Response?> runLocationAllGet() async {
    final response = await runLocationAllGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'RunLocationAllGet200Response',) as RunLocationAllGet200Response;
    
    }
    return null;
  }

  /// Simulates the arrival of a player at a certain location.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> runLocationArriveGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/run/location/arrive';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Simulates the arrival of a player at a certain location.
  Future<RunLocationArriveGet200Response?> runLocationArriveGet() async {
    final response = await runLocationArriveGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'RunLocationArriveGet200Response',) as RunLocationArriveGet200Response;
    
    }
    return null;
  }

  /// A player 'takes' a sublocation, accessible to the players current location. It will be placed into the players inventory.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> runLocationTakeFromGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/run/location/take-from';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// A player 'takes' a sublocation, accessible to the players current location. It will be placed into the players inventory.
  Future<RunLocationArriveGet200Response?> runLocationTakeFromGet() async {
    final response = await runLocationTakeFromGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'RunLocationArriveGet200Response',) as RunLocationArriveGet200Response;
    
    }
    return null;
  }

  /// Returns a list of all patients ids.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> runPatientAllIdsGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/run/patient/all-ids';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Returns a list of all patients ids.
  Future<RunPatientAllIdsGet200Response?> runPatientAllIdsGet() async {
    final response = await runPatientAllIdsGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'RunPatientAllIdsGet200Response',) as RunPatientAllIdsGet200Response;
    
    }
    return null;
  }

  /// Returns a specified patient.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [int] patientId (required):
  Future<Response> runPatientArrivePostWithHttpInfo(int patientId,) async {
    // ignore: prefer_const_declarations
    final path = r'/run/patient/arrive';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'patient_id', patientId));

    const contentTypes = <String>[];


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

  /// Returns a specified patient.
  ///
  /// Parameters:
  ///
  /// * [int] patientId (required):
  Future<RunPatientArrivePost200Response?> runPatientArrivePost(int patientId,) async {
    final response = await runPatientArrivePostWithHttpInfo(patientId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'RunPatientArrivePost200Response',) as RunPatientArrivePost200Response;
    
    }
    return null;
  }

  /// Leaves a patient.
  ///
  /// Closes a patient profile. Other users can no longer see the username in the list of treating users.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] xCSRFToken (required):
  ///
  /// * [String] patientId (required):
  Future<Response> runPatientsLeavePostWithHttpInfo(String xCSRFToken, String patientId,) async {
    // ignore: prefer_const_declarations
    final path = r'/run/patients/leave';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'patientId', patientId));

    headerParams[r'X-CSRFToken'] = parameterToString(xCSRFToken);

    const contentTypes = <String>[];


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

  /// Leaves a patient.
  ///
  /// Closes a patient profile. Other users can no longer see the username in the list of treating users.
  ///
  /// Parameters:
  ///
  /// * [String] xCSRFToken (required):
  ///
  /// * [String] patientId (required):
  Future<void> runPatientsLeavePost(String xCSRFToken, String patientId,) async {
    final response = await runPatientsLeavePostWithHttpInfo(xCSRFToken, patientId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Get start time and arrival time of scenario.
  ///
  /// Get start time of scenario and time to arrive/travel at the scene.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> scenarioStartTimeGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/scenario/start-time';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get start time and arrival time of scenario.
  ///
  /// Get start time of scenario and time to arrive/travel at the scene.
  Future<ScenarioStartTimeGet200Response?> scenarioStartTimeGet() async {
    final response = await scenarioStartTimeGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ScenarioStartTimeGet200Response',) as ScenarioStartTimeGet200Response;
    
    }
    return null;
  }
}
