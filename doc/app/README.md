# MANVSim Flutter App

The flutter app is a mobile application for Android, iOS and web.
It is used by the participants of the MANV Simulation to take part in the simulation.


## Contents
<!-- TOC -->
* [MANVSim Flutter App](#manvsim-flutter-app)
  * [Contents](#contents)
  * [Development](#development)
    * [Install and setup Flutter SDK](#install-and-setup-flutter-sdk)
    * [Configuration](#configuration)
    * [Server Environment](#server-environment)
    * [General Remarks](#general-remarks)
  * [Structure](#structure)
  * [Screen flow](#screen-flow)
  * [l10n](#l10n)
    * [Example](#example)
    * [Code Usage](#code-usage)
  * [API](#api)
    * [library](#library)
    * [API calls](#api-calls)
  * [Map](#map)
<!-- TOC -->

## Development

The App is developed in the [Flutter](https://docs.flutter.dev/get-started/install) framework for easy multiplatform
development. To build the app, Flutter Version 3.24.1 and Dart Version 3.5.1 are required.

For production deployment follow the [deployment documentation](../deployment/README.md).

### Install and setup Flutter SDK

Follow [this guide ](https://docs.flutter.dev/get-started/install) to install the Flutter SDK and set up your IDE.

Flutters programming language is [Dart](https://dart.dev/overview).
We want to build the application for Android, iOS and web.

For development we recommend [Android Studio or IntelliJ](https://docs.flutter.dev/tools/android-studio).  
For development with VSCode see [Flutter in VSCode](https://docs.flutter.dev/tools/vs-code).

### Configuration

For the local development, the app can be configured with the [config.yaml](../../app/assets/config/config.json) file.

Please note that for deployments with docker compose this file is overwritten by the
[config/app/config.json](../../config/app/config.json) file as described in the 
[deployment documentation](../deployment/README.md#app-1).

The following configuration options are available:

| Variable              | Description                                                                                                                                    | default               |
|-----------------------|------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------|
| apiUrl                | The default API URL. Can be overridden by the user or through an QR code on the login screen. Should be set to localhost for local development | https://localhost/api |
| showMap               | Show the map in the app.                                                                                                                       | true                  |
| showPatientList       | Show the patient list in the app.                                                                                                              | true                  |
| showLocationList      | Show the location list in the app.                                                                                                             | true                  |
| waitScreenIsSkippable | Allow the user to skip the wait screen. Useful to allow this for local development                                                             | false                 |

### Server Environment

For local development and debugging, at least a current server instance is required. Instructions how to easily set up a server
instance can be found in the [deployment documentation](../deployment/README.md#quickstart).

### General Remarks

- The iOS app can only be built on macOS.
- Building the android app requires the Android SDK and a JDK to be installed. To be compatible with the used gradle
  version, the JDK version should be 19.

## Structure

The app is structured in the following way:

```
app
├── api         # API library
├── assets      # Images and config
├── lib         # Source code
├── ios         # iOS specific files
├── android     # Android specific files
├── web         # Web specific files

```
The lib folder contains the main source code of the app. The app is structured in the following way:

```
lib
├── main.dart           # Main entry point of the app
├── appframe.dart       # Main frame of the app
├── start_screen.dart   # Start screen of the app
├── constants           # constants directory that contains often used icons and l10n
├── models              # models directory that contains the data models of the app
├── services            # services directory that contains the services of the app
├── utils               # utils directory that contains utility functions
├── widgets             # widgets directory that contains the widgets and screens of the app

```

The widgets directory is structured in the following way:

```
widgets
├── action            # widgets and screens required to perform actions on patients    
├── base              # base widgets and screens that are used in multiple places
├── location          # widgets and screens required for location interaction
├── map               # map screens and widgets
├── media             # media widgets and screens for multimedia data type
├── patient           # widgets and screens required for patient interaction
├── player            # widgets and screns for login flow
├── util              # utility widgets and screens

```

## Screen flow

The app has the following screen flow:

![Screen Flow](app_flow.png)

## l10n

The app is currently localized in German only. The localization files are located in the `app/lib/constants/l10n` directory.
The localization is done with the [flutter internationalization](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization) package.
The localization configuration can be found in [l10n.yaml](../../app/l10n.yaml).
All strings that are displayed in the app are localized in the `app/lib/constants/l10n` directory in .arb files.

### Example

The [de arb file](../../app/lib/constants/l10n/de.arb) contains the following content:

```json
{
  "homeScreenName": "Home"
}
```

### Code Usage

Import the localization file:
```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
```

Then use the localization in the code like this:
```dart
AppLocalizations.of(context)!.homeScreenName
```

## API

### library

This app uses an API library automatically generated from the [OpenApi Specification](https://swagger.io/specification/)
in [doc/server/api_game/api.yaml](../server/api_game/api.yaml).  

To regenerate this library (e.g. after changes) run `generate.sh` in [app/api/](../../app/api/).

### API calls

The following diagram shows the flow of API calls from the app to the server:

![API Flow](server_endpoints.png)

## Map

For more notes on the map see [here](map.md).
