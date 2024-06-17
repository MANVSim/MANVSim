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
[**runActionPerformPost**](DefaultApi.md#runactionperformpost) | **POST** /run/action/perform | Performs an action.
[**runActionPerformResultGet**](DefaultApi.md#runactionperformresultget) | **GET** /run/action/perform/result | Gets the result of a performed action.
[**runLocationAllGet**](DefaultApi.md#runlocationallget) | **GET** /run/location/all | Returns a list of locations.
[**runLocationArriveGet**](DefaultApi.md#runlocationarriveget) | **GET** /run/location/arrive | Simulates the arrival of a player at a certain location.
[**runLocationTakeFromGet**](DefaultApi.md#runlocationtakefromget) | **GET** /run/location/take-from | A player 'takes' a sublocation, accessible to the players current location. It will be placed into the players inventory.
[**runPatientAllIdsGet**](DefaultApi.md#runpatientallidsget) | **GET** /run/patient/all-ids | Returns a list of all patients ids.
[**runPatientArrivePost**](DefaultApi.md#runpatientarrivepost) | **POST** /run/patient/arrive | Returns a specified patient.
[**runPatientsLeavePost**](DefaultApi.md#runpatientsleavepost) | **POST** /run/patients/leave | Leaves a patient.
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
> NotificationsGet200Response notificationsGet(lastPollTime)

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
final lastPollTime = 2023-01-01T12:00Z; // DateTime | 

try {
    final result = api_instance.notificationsGet(lastPollTime);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->notificationsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lastPollTime** | **DateTime**|  | [optional] 

### Return type

[**NotificationsGet200Response**](NotificationsGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playerSetNamePost**
> playerSetNamePost(playerSetNamePostRequest, xCSRFToken)

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
final xCSRFToken = token; // String | 

try {
    api_instance.playerSetNamePost(playerSetNamePostRequest, xCSRFToken);
} catch (e) {
    print('Exception when calling DefaultApi->playerSetNamePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **playerSetNamePostRequest** | [**PlayerSetNamePostRequest**](PlayerSetNamePostRequest.md)|  | 
 **xCSRFToken** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **runActionAllGet**
> List<Action> runActionAllGet()

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

[**List<Action>**](Action.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **runActionPerformPost**
> RunActionPerformPost200Response runActionPerformPost(runActionPerformPostRequest, xCSRFToken)

Performs an action.

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
final xCSRFToken = token; // String | 

try {
    final result = api_instance.runActionPerformPost(runActionPerformPostRequest, xCSRFToken);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->runActionPerformPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **runActionPerformPostRequest** | [**RunActionPerformPostRequest**](RunActionPerformPostRequest.md)|  | 
 **xCSRFToken** | **String**|  | 

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

Gets the result of a performed action.

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
final patientId = patientId_example; // String | 

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
 **patientId** | **String**|  | 

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

Returns a list of locations.

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

# **runLocationArriveGet**
> RunLocationArriveGet200Response runLocationArriveGet()

Simulates the arrival of a player at a certain location.

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
    final result = api_instance.runLocationArriveGet();
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->runLocationArriveGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**RunLocationArriveGet200Response**](RunLocationArriveGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **runLocationTakeFromGet**
> RunLocationArriveGet200Response runLocationTakeFromGet()

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

try {
    final result = api_instance.runLocationTakeFromGet();
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->runLocationTakeFromGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**RunLocationArriveGet200Response**](RunLocationArriveGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **runPatientAllIdsGet**
> RunPatientAllIdsGet200Response runPatientAllIdsGet()

Returns a list of all patients ids.

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
> RunPatientArrivePost200Response runPatientArrivePost(patientId)

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
final patientId = 56; // int | 

try {
    final result = api_instance.runPatientArrivePost(patientId);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->runPatientArrivePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **patientId** | **int**|  | 

### Return type

[**RunPatientArrivePost200Response**](RunPatientArrivePost200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **runPatientsLeavePost**
> runPatientsLeavePost(xCSRFToken, patientId)

Leaves a patient.

Closes a patient profile. Other users can no longer see the username in the list of treating users.

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
final xCSRFToken = token; // String | 
final patientId = patient123; // String | 

try {
    api_instance.runPatientsLeavePost(xCSRFToken, patientId);
} catch (e) {
    print('Exception when calling DefaultApi->runPatientsLeavePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **xCSRFToken** | **String**|  | 
 **patientId** | **String**|  | 

### Return type

void (empty response body)

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

