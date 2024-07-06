import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manvsim/screens/wait_screen.dart';
import 'package:manvsim/services/api_service.dart';
import 'package:provider/provider.dart';

import '../models/tan_user.dart';
import 'login_screen.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  _selectNext(BuildContext context) async {
    final TanUser tanUser = Provider.of<TanUser>(context, listen: false);
    await tanUser.load();
    if (tanUser.isComplete()) {
      ApiService apiService = GetIt.instance.get<ApiService>();
      if (context.mounted) await apiService.recover(context);
      return const WaitScreen();
    } else {
      return const LoginScreen();
    }
  }

  _navigateNext(BuildContext context) async {
    if (!context.mounted) return;
    final next = await _selectNext(context);

    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => next),
      (Route<dynamic> route) => false, // Removes previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    _navigateNext(context);
    return Scaffold(
        body: Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context)!.startScreenAppName)
                    ]))));
  }
}
