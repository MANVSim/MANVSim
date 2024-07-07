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
[**runActionPerformPost**](DefaultApi.md#runactionperformpost) | **POST** /run/action/perform | Tries to perform an action. If successful the action is enqueued on the patient until the result is requested.
[**runActionPerformResultGet**](DefaultApi.md#runactionperformresultget) | **GET** /run/action/perform/result | Gets the result of a performed action and officially finishes/dequeues the action of the patient.
[**runLocationAllGet**](DefaultApi.md#runlocationallget) | **GET** /run/location/all | Returns a list of  top-level accessible locations.
[**runLocationLeavePost**](DefaultApi.md#runlocationleavepost) | **POST** /run/location/leave | Leaves a location.
[**runLocationTakeFromPost**](DefaultApi.md#runlocationtakefrompost) | **POST** /run/location/take-from | A player 'takes' a sublocation, accessible to the players current location. It will be placed into the players inventory.
[**runPatientAllTansGet**](DefaultApi.md#runpatientalltansget) | **GET** /run/patient/all-tans | Returns a list of all patients.
[**runPatientArrivePost**](DefaultApi.md#runpatientarrivepost) | **POST** /run/patient/arrive | Returns a specified patient.
[**runPatientLeavePost**](DefaultApi.md#runpatientleavepost) | **POST** /run/patient/leave | Leaves a patient.
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
> List<ActionDTO> runActionAllGet()

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

[**List<ActionDTO>**](ActionDTO.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
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
> String runActionPerformResultGet(performedActionId, patientId)

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

**String**

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

# **runLocationTakeFromPost**
> RunLocationTakeFromPost200Response runLocationTakeFromPost(runLocationTakeFromPostRequest)

A player 'takes' a sublocation, accessible to the players current location. It will be placed into the players inventory.

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
final runLocationTakeFromPostRequest = RunLocationTakeFromPostRequest(); // RunLocationTakeFromPostRequest | 

try {
    final result = api_instance.runLocationTakeFromPost(runLocationTakeFromPostRequest);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->runLocationTakeFromPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **runLocationTakeFromPostRequest** | [**RunLocationTakeFromPostRequest**](RunLocationTakeFromPostRequest.md)|  | 

### Return type

[**RunLocationTakeFromPost200Response**](RunLocationTakeFromPost200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **runPatientAllTansGet**
> RunPatientAllTansGet200Response runPatientAllTansGet()

Returns a list of all patients.

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
    final result = api_instance.runPatientAllTansGet();
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->runPatientAllTansGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**RunPatientAllTansGet200Response**](RunPatientAllTansGet200Response.md)

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

# **runPatientLeavePost**
> RunPatientLeavePost200Response runPatientLeavePost()

Leaves a patient.

Closes a patient profile and leaves the patients location.

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
    final result = api_instance.runPatientLeavePost();
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->runPatientLeavePost: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**RunPatientLeavePost200Response**](RunPatientLeavePost200Response.md)

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

