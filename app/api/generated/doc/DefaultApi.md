# manv_api.api.DefaultApi

## Load the API package
```dart
import 'package:manv_api/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**loginPost**](DefaultApi.md#loginpost) | **POST** /login | TAN Login
[**notificationsGet**](DefaultApi.md#notificationsget) | **GET** /notifications | notification polling
[**playerSetNamePost**](DefaultApi.md#playersetnamepost) | **POST** /player/set-name | Set username for the TAN
[**runActionAllGet**](DefaultApi.md#runactionallget) | **GET** /run/action/all | Returns a list of actions available to the user.
[**runActionPerformMovePatientPost**](DefaultApi.md#runactionperformmovepatientpost) | **POST** /run/action/perform/move/patient | Moves a patient from the current location to another location. Returns the result of /patient/arrive or the errors of /location/leave
[**runActionPerformPost**](DefaultApi.md#runactionperformpost) | **POST** /run/action/perform | Tries to perform an action. If successful the action is enqueued on the patient until the result is requested.
[**runActionPerformResultGet**](DefaultApi.md#runactionperformresultget) | **GET** /run/action/perform/result | Gets the result of a performed action and officially finishes/dequeues the action of the patient.
[**runLocationAllGet**](DefaultApi.md#runlocationallget) | **GET** /run/location/all | Returns a list of  top-level accessible locations.
[**runLocationLeavePost**](DefaultApi.md#runlocationleavepost) | **POST** /run/location/leave | Leaves a location.
[**runLocationPutToPost**](DefaultApi.md#runlocationputtopost) | **POST** /run/location/put-to | A player puts any location which is not a registered top-level location and places it into another selected location. It is designed to create a valuable state among all locations and player inventories. However an invalid use may create an invalid game state. The 'put_location_ids' is an id list (as string) of location ids that identify a single location selected for transfer. The 'to_location_ids' is an id list (as string) of location ids that identify a single location in that the 'put_location' should be placed in.
[**runLocationTakeToPost**](DefaultApi.md#runlocationtaketopost) | **POST** /run/location/take-to | A player takes any location which is not a registered top-level location and places it into another selected location. It is designed to create a valuable state among all locations and player inventories. However an invalid use may create an invalid game state. The 'take_location_ids' is an id list (as string) of the location the player wants to take into his inventory. The list should start with a toplevel location. The 'to_location_ids' is an id list (as string) of the new locations parent in the players inventory. If the list is empty, the item is placed as in the root level of the inventory.
[**runMapdataGet**](DefaultApi.md#runmapdataget) | **GET** /run/mapdata | gets map data
[**runPatientAllIdsGet**](DefaultApi.md#runpatientallidsget) | **GET** /run/patient/all-ids | Returns a list of all patient ids.
[**runPatientArrivePost**](DefaultApi.md#runpatientarrivepost) | **POST** /run/patient/arrive | Returns a specified patient.
[**runPatientClassifyPost**](DefaultApi.md#runpatientclassifypost) | **POST** /run/patient/classify | Sets a classification attribute for a specific patient.
[**runPlayerInventoryGet**](DefaultApi.md#runplayerinventoryget) | **GET** /run/player/inventory | Get Player Inventory
[**scenarioStartTimeGet**](DefaultApi.md#scenariostarttimeget) | **GET** /scenario/start-time | Get start time and arrival time of scenario.


# **loginPost**
> LoginPost200Response loginPost(loginPostRequest)

TAN Login

authenticates a user with a TAN and returns a JWT token

### Example
```dart
import 'package:manv_api/api.dart';

final api_instance = DefaultApi();
final loginPostRequest = LoginPostRequest(); // LoginPostRequest | 

try {
    final result = api_instance.loginPost(loginPostRequest);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->loginPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **loginPostRequest** | [**LoginPostRequest**](LoginPostRequest.md)|  | 

### Return type

[**LoginPost200Response**](LoginPost200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **notificationsGet**
> NotificationsGet200Response notificationsGet(nextId)

notification polling

Returns a list of notifications for the user after lastPollTime.

### Example
```dart
import 'package:manv_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final nextId = 2; // int | 

try {
    final result = api_instance.notificationsGet(nextId);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->notificationsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **nextId** | **int**|  | 

### Return type

[**NotificationsGet200Response**](NotificationsGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playerSetNamePost**
> playerSetNamePost(playerSetNamePostRequest)

Set username for the TAN

Sets the name for the TAN provided in JWT.

### Example
```dart
import 'package:manv_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final playerSetNamePostRequest = PlayerSetNamePostRequest(); // PlayerSetNamePostRequest | 

try {
    api_instance.playerSetNamePost(playerSetNamePostRequest);
} catch (e) {
    print('Exception when calling DefaultApi->playerSetNamePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **playerSetNamePostRequest** | [**PlayerSetNamePostRequest**](PlayerSetNamePostRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **runActionAllGet**
> RunActionAllGet200Response runActionAllGet()

Returns a list of actions available to the user.

### Example
```dart
import 'package:manv_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();

try {
    final result = api_instance.runActionAllGet();
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->runActionAllGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**RunActionAllGet200Response**](RunActionAllGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **runActionPerformMovePatientPost**
> RunPatientArrivePost200Response runActionPerformMovePatientPost(runActionPerformMovePatientPostRequest)

Moves a patient from the current location to another location. Returns the result of /patient/arrive or the errors of /location/leave

### Example
```dart
import 'package:manv_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final runActionPerformMovePatientPostRequest = RunActionPerformMovePatientPostRequest(); // RunActionPerformMovePatientPostRequest | 

try {
    final result = api_instance.runActionPerformMovePatientPost(runActionPerformMovePatientPostRequest);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->runActionPerformMovePatientPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **runActionPerformMovePatientPostRequest** | [**RunActionPerformMovePatientPostRequest**](RunActionPerformMovePatientPostRequest.md)|  | 

### Return type

[**RunPatientArrivePost200Response**](RunPatientArrivePost200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **runActionPerformPost**
> RunActionPerformPost200Response runActionPerformPost(runActionPerformPostRequest)

Tries to perform an action. If successful the action is enqueued on the patient until the result is requested.

### Example
```dart
import 'package:manv_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final runActionPerformPostRequest = RunActionPerformPostRequest(); // RunActionPerformPostRequest | 

try {
    final result = api_instance.runActionPerformPost(runActionPerformPostRequest);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->runActionPerformPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **runActionPerformPostRequest** | [**RunActionPerformPostRequest**](RunActionPerformPostRequest.md)|  | 

### Return type

[**RunActionPerformPost200Response**](RunActionPerformPost200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **runActionPerformResultGet**
> RunActionPerformResultGet200Response runActionPerformResultGet(performedActionId, patientId)

Gets the result of a performed action and officially finishes/dequeues the action of the patient.

### Example
```dart
import 'package:manv_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final performedActionId = performedActionId_example; // String | 
final patientId = 56; // int | 

try {
    final result = api_instance.runActionPerformResultGet(performedActionId, patientId);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->runActionPerformResultGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **performedActionId** | **String**|  | 
 **patientId** | **int**|  | 

### Return type

[**RunActionPerformResultGet200Response**](RunActionPerformResultGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **runLocationAllGet**
> RunLocationAllGet200Response runLocationAllGet()

Returns a list of  top-level accessible locations.

### Example
```dart
import 'package:manv_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();

try {
    final result = api_instance.runLocationAllGet();
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->runLocationAllGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**RunLocationAllGet200Response**](RunLocationAllGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **runLocationLeavePost**
> RunLocationLeavePost200Response runLocationLeavePost()

Leaves a location.

The current location of the player is resetted. Used initially to leave the arriving RTW.

### Example
```dart
import 'package:manv_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();

try {
    final result = api_instance.runLocationLeavePost();
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->runLocationLeavePost: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**RunLocationLeavePost200Response**](RunLocationLeavePost200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **runLocationPutToPost**
> runLocationPutToPost(runLocationPutToPostRequest)

A player puts any location which is not a registered top-level location and places it into another selected location. It is designed to create a valuable state among all locations and player inventories. However an invalid use may create an invalid game state. The 'put_location_ids' is an id list (as string) of location ids that identify a single location selected for transfer. The 'to_location_ids' is an id list (as string) of location ids that identify a single location in that the 'put_location' should be placed in.

### Example
```dart
import 'package:manv_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final runLocationPutToPostRequest = RunLocationPutToPostRequest(); // RunLocationPutToPostRequest | 

try {
    api_instance.runLocationPutToPost(runLocationPutToPostRequest);
} catch (e) {
    print('Exception when calling DefaultApi->runLocationPutToPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **runLocationPutToPostRequest** | [**RunLocationPutToPostRequest**](RunLocationPutToPostRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **runLocationTakeToPost**
> runLocationTakeToPost(runLocationTakeToPostRequest)

A player takes any location which is not a registered top-level location and places it into another selected location. It is designed to create a valuable state among all locations and player inventories. However an invalid use may create an invalid game state. The 'take_location_ids' is an id list (as string) of the location the player wants to take into his inventory. The list should start with a toplevel location. The 'to_location_ids' is an id list (as string) of the new locations parent in the players inventory. If the list is empty, the item is placed as in the root level of the inventory.

### Example
```dart
import 'package:manv_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final runLocationTakeToPostRequest = RunLocationTakeToPostRequest(); // RunLocationTakeToPostRequest | 

try {
    api_instance.runLocationTakeToPost(runLocationTakeToPostRequest);
} catch (e) {
    print('Exception when calling DefaultApi->runLocationTakeToPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **runLocationTakeToPostRequest** | [**RunLocationTakeToPostRequest**](RunLocationTakeToPostRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **runMapdataGet**
> MapDataDTO runMapdataGet()

gets map data

### Example
```dart
import 'package:manv_api/api.dart';

final api_instance = DefaultApi();

try {
    final result = api_instance.runMapdataGet();
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->runMapdataGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**MapDataDTO**](MapDataDTO.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **runPatientAllIdsGet**
> RunPatientAllIdsGet200Response runPatientAllIdsGet()

Returns a list of all patient ids.

### Example
```dart
import 'package:manv_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();

try {
    final result = api_instance.runPatientAllIdsGet();
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->runPatientAllIdsGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**RunPatientAllIdsGet200Response**](RunPatientAllIdsGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **runPatientArrivePost**
> RunPatientArrivePost200Response runPatientArrivePost(runPatientArrivePostRequest)

Returns a specified patient.

### Example
```dart
import 'package:manv_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final runPatientArrivePostRequest = RunPatientArrivePostRequest(); // RunPatientArrivePostRequest | 

try {
    final result = api_instance.runPatientArrivePost(runPatientArrivePostRequest);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->runPatientArrivePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **runPatientArrivePostRequest** | [**RunPatientArrivePostRequest**](RunPatientArrivePostRequest.md)|  | 

### Return type

[**RunPatientArrivePost200Response**](RunPatientArrivePost200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **runPatientClassifyPost**
> runPatientClassifyPost(runPatientClassifyPostRequest)

Sets a classification attribute for a specific patient.

### Example
```dart
import 'package:manv_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();
final runPatientClassifyPostRequest = RunPatientClassifyPostRequest(); // RunPatientClassifyPostRequest | 

try {
    api_instance.runPatientClassifyPost(runPatientClassifyPostRequest);
} catch (e) {
    print('Exception when calling DefaultApi->runPatientClassifyPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **runPatientClassifyPostRequest** | [**RunPatientClassifyPostRequest**](RunPatientClassifyPostRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **runPlayerInventoryGet**
> RunPlayerInventoryGet200Response runPlayerInventoryGet()

Get Player Inventory

### Example
```dart
import 'package:manv_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();

try {
    final result = api_instance.runPlayerInventoryGet();
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->runPlayerInventoryGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**RunPlayerInventoryGet200Response**](RunPlayerInventoryGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **scenarioStartTimeGet**
> ScenarioStartTimeGet200Response scenarioStartTimeGet()

Get start time and arrival time of scenario.

Get start time of scenario and time to arrive/travel at the scene.

### Example
```dart
import 'package:manv_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = DefaultApi();

try {
    final result = api_instance.scenarioStartTimeGet();
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->scenarioStartTimeGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ScenarioStartTimeGet200Response**](ScenarioStartTimeGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

