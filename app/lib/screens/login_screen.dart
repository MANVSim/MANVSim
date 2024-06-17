import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/api_service.dart';
import 'name_screen.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'wait_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => LoginScreenState();
}
enum _LoginInputType { TAN, URL }

class LoginScreenState extends State<LoginScreen> {

  final TextEditingController _tanController = TextEditingController();
  final TextEditingController _serverUrlController = TextEditingController();

  String? _errorMessage;

  bool _tanInputFailure = false;
  bool _urlInputFailure = false;

  bool _isLoading = false;

  InputDecoration _textFieldDecoration(bool hasInputFailure, String text) {
    return InputDecoration(
      labelText: text,
      fillColor: hasInputFailure ? Colors.red.shade50 : null,
      filled: hasInputFailure,
      border: hasInputFailure
          ? const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            )
          : null,
    );
  }

  void _resetErrorMessage(_LoginInputType? inputType) {
    if (_errorMessage != null || _tanInputFailure || _urlInputFailure) {
      bool tanFailure = _tanInputFailure;
      bool urlFailure = _urlInputFailure;
      switch (inputType) {
        case _LoginInputType.TAN:
          tanFailure = false;
          break;
        case _LoginInputType.URL:
          urlFailure = false;
          break;
        case null:
          tanFailure = false;
          urlFailure = false;
          break;
      }
      setState(() {
        _errorMessage = null;
        _tanInputFailure = tanFailure;
        _urlInputFailure = urlFailure;
      });
    }
  }

  void _navigateToNext() {
    if(ApiService().isNameSet) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const WaitScreen()),
            (Route<dynamic> route) =>
        false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const NameScreen()),
            (Route<dynamic> route) =>
        false,
      );
    }
  }

  void _handleLogin() async {
    String tan = _tanController.text;
    String url = _serverUrlController.text;

    if (tan.isEmpty || url.isEmpty) {
      setState(() {
        _tanInputFailure = tan.isEmpty;
        _urlInputFailure = url.isEmpty;
        _errorMessage = AppLocalizations.of(context)!.loginWarningEmptyFields;
      });
    } else {
      setState(() {
        _tanInputFailure = false;
        _urlInputFailure = false;
        _errorMessage = null;
        _isLoading = true;
      });

      String? failureMessage;

      try {
        ApiService authenticationService = GetIt.instance.get<ApiService>();
        await authenticationService.login(tan, url);
      } catch (e) {
        failureMessage = e.toString();
      }

      int maxLength = 80;
      String? shortFailureMessage = ((failureMessage?.length ?? 0) > maxLength)
          ? '${failureMessage?.substring(0, maxLength).trim()}...'
          : failureMessage?.trim();

      shortFailureMessage = shortFailureMessage?.replaceAll(RegExp(r'[\n\t]'), ' ');

      setState(() {
        _errorMessage = AppLocalizations.of(context)!.loginWarningRequestFailed(shortFailureMessage??'unknown error');
        _isLoading = false;
        _tanInputFailure = false;
        _urlInputFailure = false;
      });

      if (failureMessage == null) {
        _navigateToNext();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.loginScreenName),
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              if (_errorMessage != null) // Show error message if it's not null
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.red.shade100,
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              TextField(
                controller: _tanController,
                decoration: _textFieldDecoration(_tanInputFailure,
                    AppLocalizations.of(context)!.loginTAN),
                onChanged: (value) => _resetErrorMessage(_LoginInputType.TAN),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _serverUrlController,
                decoration: _textFieldDecoration(_urlInputFailure,
                    AppLocalizations.of(context)!.loginServerUrl),
                onChanged: (value) => _resetErrorMessage(_LoginInputType.URL),

              ),
              const SizedBox(height: 16),
              if (_isLoading)
                const CircularProgressIndicator(),
              if (!_isLoading)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.qr_code_scanner),
                      label: Text(
                          AppLocalizations.of(context)!.qrCodeScanButton),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.login),
                      onPressed: _handleLogin,
                      label: Text(AppLocalizations.of(context)!.loginSubmit),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}