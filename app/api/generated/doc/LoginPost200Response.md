# manv_api.model.LoginPost200Response

## Load the model package
```dart
import 'package:manv_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**jwtToken** | **String** | JWT Token for the session. | [optional] 
**csrfToken** | **String** | CSRF Token required for following POST requests. | [optional] 
**userCreationRequired** | **bool** | Boolean indicating if the player needs to create a username. | [optional] 
**userName** | **String** | The username of the player. | [optional] 
**userRole** | **String** | The role of the user. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


