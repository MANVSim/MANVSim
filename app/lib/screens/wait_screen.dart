import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manvsim/appframe.dart';
import 'package:manvsim/services/api_service.dart';
import 'package:manvsim/widgets/logout_button.dart';
import 'package:manvsim/widgets/timer_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WaitScreen extends StatefulWidget {
  const WaitScreen({super.key});

  @override
  State<StatefulWidget> createState() => _WaitScreenState();
}

class _WaitScreenState extends State<WaitScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const <Widget>[LogoutButton()],
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(AppLocalizations.of(context)!.waitText),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TimerWidget(duration: 10, onTimerComplete: goToHome),
            const SizedBox(height: 64),
            ElevatedButton.icon(
              icon: const Icon(Icons.skip_next),
              onPressed: goToHome,
              label: Text(AppLocalizations.of(context)!.waitSkip),
            ),
          ],
        ),
      ),
    );
  }

  void goToHome() {
    ApiService apiService = GetIt.instance.get<ApiService>();
    apiService.api
        .runLocationLeavePost()
        .whenComplete(() => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const AppFrame()),
              (Route<dynamic> route) => false, // Removes previous routes
            ));
  }
}
