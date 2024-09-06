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
  /// * [int] nextId (required):
  Future<Response> notificationsGetWithHttpInfo(int nextId,) async {
    // ignore: prefer_const_declarations
    final path = r'/notifications';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'next_id', nextId));

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
  /// * [int] nextId (required):
  Future<NotificationsGet200Response?> notificationsGet(int nextId,) async {
    final response = await notificationsGetWithHttpInfo(nextId,);
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
  Future<Response> playerSetNamePostWithHttpInfo(PlayerSetNamePostRequest playerSetNamePostRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/player/set-name';

    // ignore: prefer_final_locals
    Object? postBody = playerSetNamePostRequest;

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

  /// Set username for the TAN
  ///
  /// Sets the name for the TAN provided in JWT.
  ///
  /// Parameters:
  ///
  /// * [PlayerSetNamePostRequest] playerSetNamePostRequest (required):
  Future<void> playerSetNamePost(PlayerSetNamePostRequest playerSetNamePostRequest,) async {
    final response = await playerSetNamePostWithHttpInfo(playerSetNamePostRequest,);
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
  Future<RunActionAllGet200Response?> runActionAllGet() async {
    final response = await runActionAllGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'RunActionAllGet200Response',) as RunActionAllGet200Response;
    
    }
    return null;
  }

  /// Moves a patient from the current location to another location. Returns the result of /patient/arrive or the errors of /location/leave
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [RunActionPerformMovePatientPostRequest] runActionPerformMovePatientPostRequest (required):
  Future<Response> runActionPerformMovePatientPostWithHttpInfo(RunActionPerformMovePatientPostRequest runActionPerformMovePatientPostRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/run/action/perform/move/patient';

    // ignore: prefer_final_locals
    Object? postBody = runActionPerformMovePatientPostRequest;

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

  /// Moves a patient from the current location to another location. Returns the result of /patient/arrive or the errors of /location/leave
  ///
  /// Parameters:
  ///
  /// * [RunActionPerformMovePatientPostRequest] runActionPerformMovePatientPostRequest (required):
  Future<RunPatientArrivePost200Response?> runActionPerformMovePatientPost(RunActionPerformMovePatientPostRequest runActionPerformMovePatientPostRequest,) async {
    final response = await runActionPerformMovePatientPostWithHttpInfo(runActionPerformMovePatientPostRequest,);
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

  /// Tries to perform an action. If successful the action is enqueued on the patient until the result is requested.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [RunActionPerformPostRequest] runActionPerformPostRequest (required):
  Future<Response> runActionPerformPostWithHttpInfo(RunActionPerformPostRequest runActionPerformPostRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/run/action/perform';

    // ignore: prefer_final_locals
    Object? postBody = runActionPerformPostRequest;

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

  /// Tries to perform an action. If successful the action is enqueued on the patient until the result is requested.
  ///
  /// Parameters:
  ///
  /// * [RunActionPerformPostRequest] runActionPerformPostRequest (required):
  Future<RunActionPerformPost200Response?> runActionPerformPost(RunActionPerformPostRequest runActionPerformPostRequest,) async {
    final response = await runActionPerformPostWithHttpInfo(runActionPerformPostRequest,);
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

  /// Gets the result of a performed action and officially finishes/dequeues the action of the patient.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] performedActionId (required):
  ///
  /// * [int] patientId (required):
  Future<Response> runActionPerformResultGetWithHttpInfo(String performedActionId, int patientId,) async {
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

  /// Gets the result of a performed action and officially finishes/dequeues the action of the patient.
  ///
  /// Parameters:
  ///
  /// * [String] performedActionId (required):
  ///
  /// * [int] patientId (required):
  Future<RunActionPerformResultGet200Response?> runActionPerformResultGet(String performedActionId, int patientId,) async {
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

  /// Returns a list of  top-level accessible locations.
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

  /// Returns a list of  top-level accessible locations.
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

  /// Leaves a location.
  ///
  /// The current location of the player is resetted. Used initially to leave the arriving RTW.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> runLocationLeavePostWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/run/location/leave';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

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

  /// Leaves a location.
  ///
  /// The current location of the player is resetted. Used initially to leave the arriving RTW.
  Future<RunLocationLeavePost200Response?> runLocationLeavePost() async {
    final response = await runLocationLeavePostWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'RunLocationLeavePost200Response',) as RunLocationLeavePost200Response;
    
    }
    return null;
  }

  /// A player puts any location which is not a registered top-level location and places it into another selected location. It is designed to create a valuable state among all locations and player inventories. However an invalid use may create an invalid game state. The 'put_location_ids' is an id list (as string) of location ids that identify a single location selected for transfer. The 'to_location_ids' is an id list (as string) of location ids that identify a single location in that the 'put_location' should be placed in.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [RunLocationPutToPostRequest] runLocationPutToPostRequest (required):
  Future<Response> runLocationPutToPostWithHttpInfo(RunLocationPutToPostRequest runLocationPutToPostRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/run/location/put-to';

    // ignore: prefer_final_locals
    Object? postBody = runLocationPutToPostRequest;

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

  /// A player puts any location which is not a registered top-level location and places it into another selected location. It is designed to create a valuable state among all locations and player inventories. However an invalid use may create an invalid game state. The 'put_location_ids' is an id list (as string) of location ids that identify a single location selected for transfer. The 'to_location_ids' is an id list (as string) of location ids that identify a single location in that the 'put_location' should be placed in.
  ///
  /// Parameters:
  ///
  /// * [RunLocationPutToPostRequest] runLocationPutToPostRequest (required):
  Future<void> runLocationPutToPost(RunLocationPutToPostRequest runLocationPutToPostRequest,) async {
    final response = await runLocationPutToPostWithHttpInfo(runLocationPutToPostRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// A player takes any location which is not a registered top-level location and places it into another selected location. It is designed to create a valuable state among all locations and player inventories. However an invalid use may create an invalid game state. The 'take_location_ids' is an id list (as string) of the location the player wants to take into his inventory. The list should start with a toplevel location. The 'to_location_ids' is an id list (as string) of the new locations parent in the players inventory. If the list is empty, the item is placed as in the root level of the inventory.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [RunLocationTakeToPostRequest] runLocationTakeToPostRequest (required):
  Future<Response> runLocationTakeToPostWithHttpInfo(RunLocationTakeToPostRequest runLocationTakeToPostRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/run/location/take-to';

    // ignore: prefer_final_locals
    Object? postBody = runLocationTakeToPostRequest;

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

  /// A player takes any location which is not a registered top-level location and places it into another selected location. It is designed to create a valuable state among all locations and player inventories. However an invalid use may create an invalid game state. The 'take_location_ids' is an id list (as string) of the location the player wants to take into his inventory. The list should start with a toplevel location. The 'to_location_ids' is an id list (as string) of the new locations parent in the players inventory. If the list is empty, the item is placed as in the root level of the inventory.
  ///
  /// Parameters:
  ///
  /// * [RunLocationTakeToPostRequest] runLocationTakeToPostRequest (required):
  Future<void> runLocationTakeToPost(RunLocationTakeToPostRequest runLocationTakeToPostRequest,) async {
    final response = await runLocationTakeToPostWithHttpInfo(runLocationTakeToPostRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Returns a list of all patient ids.
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

  /// Returns a list of all patient ids.
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
  /// * [RunPatientArrivePostRequest] runPatientArrivePostRequest (required):
  Future<Response> runPatientArrivePostWithHttpInfo(RunPatientArrivePostRequest runPatientArrivePostRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/run/patient/arrive';

    // ignore: prefer_final_locals
    Object? postBody = runPatientArrivePostRequest;

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

  /// Returns a specified patient.
  ///
  /// Parameters:
  ///
  /// * [RunPatientArrivePostRequest] runPatientArrivePostRequest (required):
  Future<RunPatientArrivePost200Response?> runPatientArrivePost(RunPatientArrivePostRequest runPatientArrivePostRequest,) async {
    final response = await runPatientArrivePostWithHttpInfo(runPatientArrivePostRequest,);
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
  /// Closes a patient profile and leaves the patients location.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> runPatientLeavePostWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/run/patient/leave';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

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
  /// Closes a patient profile and leaves the patients location.
  Future<RunPatientLeavePost200Response?> runPatientLeavePost() async {
    final response = await runPatientLeavePostWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'RunPatientLeavePost200Response',) as RunPatientLeavePost200Response;
    
    }
    return null;
  }

  /// Get Player Inventory
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> runPlayerInventoryGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/run/player/inventory';

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

  /// Get Player Inventory
  Future<RunPlayerInventoryGet200Response?> runPlayerInventoryGet() async {
    final response = await runPlayerInventoryGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'RunPlayerInventoryGet200Response',) as RunPlayerInventoryGet200Response;
    
    }
    return null;
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
