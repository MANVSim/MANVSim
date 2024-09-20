import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:manv_api/api.dart';
import 'package:manvsim/services/api_service.dart';
import 'package:manvsim/widgets/util/error_box.dart';

/// Custom [FutureBuilder] which automatically displays loading spinner, error messages and  handles some API error codes.
///
/// Generic of type [T]. Future may be [T?], but if [T] is non nullable a null return value is seen as an error.
class CustomFutureBuilder<T> extends StatelessWidget {
  /// The future of type [T?] to which this [builder] is connected.
  final Future<T?> future;

  /// Build strategy based on the [future]s (successful) result of type [T].
  final Widget Function(BuildContext, T) builder;

  /// To be called instead of default error handling.
  final Function(Object? error)? onError;

  /// To be called on Error but continue with default error handling.
  final Function(Object? error)? onErrorNotify;

  final String? errorMessage;

  final int errorMessageExceptionLength;

  const CustomFutureBuilder(
      {super.key,
      required this.future,
      required this.builder,
      this.onError,
      this.onErrorNotify,
      this.errorMessage,
      this.errorMessageExceptionLength = kDebugMode
          ? -1
          : 200 // dont destroy the UI with long error messages (e.g. stacktrace) in release mode
      });

  String buildErrorMessage(Object? errorObject, BuildContext context) {
    String error = errorObject.toString();
    if (errorObject case ApiException apiException) {
      error = !kDebugMode
          ? "${apiException.code}: ${apiException.message ?? "<Unknown error>"}"
          : error;
    }

    if (errorMessageExceptionLength > 0) {
      String shortExceptionMessage =
          (error.length > errorMessageExceptionLength)
              ? "${error.substring(0, errorMessageExceptionLength)}..."
              : error;

      return errorMessage != null
          ? "$errorMessage:\n\n $shortExceptionMessage"
          : shortExceptionMessage;
    } else if (errorMessageExceptionLength == 0) {
      return errorMessage != null
          ? errorMessage!
          : AppLocalizations.of(context)!.defaultError;
    } else {
      return errorMessage != null ? "$errorMessage:\n\n $error" : error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T?>(
        future: future,
        builder: (context, snapshot) {
          if (!snapshot.hasData &&
              snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data is! T) {
            if (onErrorNotify != null) {
              onErrorNotify!(snapshot.error);
            }

            if (onError != null) {
              onError!(snapshot.error);
            } else if (snapshot.error case ApiException apiException) {
              ApiService apiService = GetIt.instance.get<ApiService>();
              Timer.run(
                  () => apiService.handleErrorCode(apiException, context));
            }
            return ErrorBox(
                errorText: buildErrorMessage(snapshot.error, context));
          }
          return builder(context, snapshot.data as T);
        });
  }
}
