import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manv_api/api.dart';
import 'package:manvsim/services/api_service.dart';

/// Custom [FutureBuilder] which automatically displays loading spinner, error messages and  handles some API error codes.
///
/// Generic of type [T]. Future may be [T?], but if [T] is non nullable a null return value is seen as an error.
class ApiFutureBuilder<T> extends StatelessWidget {
  /// The future of type [T?] to which this [builder] is connected.
  final Future<T?> future;

  /// Build strategy based on the [future]s (successful) result of type [T].
  final Widget Function(BuildContext, T) builder;

  /// To be called instead of default error handling.
  final Function()? onError;

  const ApiFutureBuilder(
      {super.key, required this.future, required this.builder, this.onError});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T?>(
        future: future,
        builder: (context, snapshot) {
          if (!snapshot.hasData &&
              snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data is! T) {
            if (onError != null) {
              onError!();
            } else if (snapshot.error case ApiException apiException) {
              ApiService apiService = GetIt.instance.get<ApiService>();
              Timer.run(
                  () => apiService.handleErrorCode(apiException, context));
            }
            // TODO own component
            return Container(
              padding: const EdgeInsets.all(8),
              color: Colors.red.shade100,
              child: Row(
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      snapshot.error.toString(),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          }
          return builder(context, snapshot.data!);
        });
  }
}
