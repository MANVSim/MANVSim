# manv_api.api.DefaultApi

## Load the API package
```dart
import 'package:manv_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**loginPost**](DefaultApi.md#loginpost) | **POST** /login | Login
[**playerSetNamePost**](DefaultApi.md#playersetnamepost) | **POST** /player/set-name | Set Player Name


# **loginPost**
> LoginPost200Response loginPost(TAN)

Login

Performs a login for a requesting TAN. If the TAN is registered to a registered execution, a JWT Token is generated, containing the related execution-id and player-TAN as identity. The method returns: - JWT Token - CSRF Token (required for following POST request) - Boolean if player has no name yet - username - user-role 

### Example
```dart
import 'package:manv_api/api.dart';

final api_instance = DefaultApi();
final TAN = TAN_example; // String | The TAN of the player.

try {
    final result = api_instance.loginPost(TAN);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->loginPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **TAN** | **String**| The TAN of the player. | [optional] 

### Return type

[**LoginPost200Response**](LoginPost200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/x-www-form-urlencoded
 - **Accept**: application/json, text/plain

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **playerSetNamePost**
> String playerSetNamePost(name)

Set Player Name

Changes the name of the requesting player.

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
final name = name_example; // String | The new name of the player.

try {
    final result = api_instance.playerSetNamePost(name);
    print(result);
} catch (e) {
    print('Exception when calling DefaultApi->playerSetNamePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **name** | **String**| The new name of the player. | [optional] 

### Return type

**String**

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/x-www-form-urlencoded
 - **Accept**: text/plain

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

