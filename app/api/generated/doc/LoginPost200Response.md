# manv_api.model.LoginPost200Response

## Load the model package
```dart
import 'package:manv_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**jwtToken** | **String** | JWT-Token, maps game and player | 
**userCreationRequired** | **bool** | indicates if name for the TAN was already set. | 
**userName** | **String** | name for the TAN, if userCreationRequired is false. Otherwise empty. | 
**userRole** | **String** | role of the user. | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


