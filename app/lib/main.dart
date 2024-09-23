import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:manvsim/models/tan_user.dart';
import 'package:manvsim/services/api_service.dart';
import 'package:manvsim/services/notification_service.dart';
import 'package:manvsim/services/size_service.dart';
import 'package:manvsim/start_screen.dart';
import 'package:provider/provider.dart';

void main() {
  final runnableApp = _buildRunnableApp(
    isWeb: kIsWeb,
    webAppWidth: SizeService.maxWebAppWidth,
    app: const ManvSimApp(),
  );

  runApp(runnableApp);
}

Widget _buildRunnableApp({
  required bool isWeb,
  required double webAppWidth,
  required Widget app,
}) {
  if (!isWeb) {
    return app;
  }

  return Container(
      color: colorScheme.secondary,
      child: Center(
        child: ClipRect(
          child: SizedBox(
            width: webAppWidth,
            child: app,
          ),
        ),
      ));
}

ColorScheme colorScheme = ColorScheme.fromSeed(
  seedColor: Colors.indigo,
);

class ManvSimApp extends StatelessWidget {
  const ManvSimApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GetIt getIt = GetIt.instance;

    if (!getIt.isRegistered<ApiService>()) {
      getIt.registerLazySingleton<ApiService>(() => ApiService());
    }

    if (!getIt.isRegistered<NotificationService>()) {
      getIt.registerLazySingleton<NotificationService>(
          () => NotificationService());
    }

    return MultiProvider(
        providers: [ChangeNotifierProvider<TanUser>(create: (_) => TanUser())],
        child: MaterialApp(
          title: 'MANVSim',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            colorScheme: colorScheme,
            useMaterial3: true,
            appBarTheme: AppBarTheme(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
            ),
            tabBarTheme: TabBarTheme(
              labelColor: colorScheme.surface,
              unselectedLabelColor: colorScheme.surface,
            ),
          ),
          home: const StartScreen(),
        ));
  }
}
