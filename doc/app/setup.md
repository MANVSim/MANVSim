# Setup Flutter Project

## Local setup for development

### Install and setup Flutter SDK

Follow [this guide ](https://docs.flutter.dev/get-started/install) to install the Flutter SDK and set up your IDE.

Flutters programming language is [Dart](https://dart.dev/overview).
We want to build the application for Android, iOS and web.

For development we recommend [Android Studio or IntelliJ](https://docs.flutter.dev/tools/android-studio).  
For development with VSCode see [Flutter in VSCode](https://docs.flutter.dev/tools/vs-code).

### General Remarks

- The iOS app can only be built on macOS.
- Building the android app requires the Android SDK and a JDK to be installed. To be compatible with the used gradle
  version, the JDK version should be 19.

## Flutter web with Docker

To run the App without locally installing Flutter, you can use Docker. It is only for testing the app, not for
development.

### Create the image

The Dockerfile is in the root of the app project and can be built from there with:

```console
docker build -t flutter-web .
 ```

### Run the web app

The image can be run with:

```console 
docker run -d -p 8080:80 --name flutter-web flutter-web
```

Now the app is running on http://localhost:8080