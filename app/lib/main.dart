import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manvsim/models/tan_user.dart';
import 'package:manvsim/screens/start_screen.dart';
import 'package:manvsim/services/api_service.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const ManvSimApp());
}

class ManvSimApp extends StatelessWidget {
  const ManvSimApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GetIt getIt = GetIt.instance;
    if (!getIt.isRegistered<ApiService>()) {
      getIt.registerLazySingleton<ApiService>(() => ApiService());
    }

    return MultiProvider(
        providers: [ChangeNotifierProvider<TanUser>(create: (_) => TanUser())],
        child: MaterialApp(
          title: 'ManvSim',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const StartScreen(),
        ));
  }
}
