# manv_api.model.LoginPost200Response

## Load the model package
```dart
import 'package:manv_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**jwtToken** | **String** | JWT-Token, maps game and player | [optional] 
**csrfToken** | **String** | CSRF Token to be used in future requests. | [optional] 
**userCreationRequired** | **bool** | indicates if name for the TAN was already set. | [optional] 
**userName** | **String** | name for the TAN, if userCreationRequired is false. Otherwise empty. | [optional] 
**userRole** | **String** | role of the user. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


