import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manvsim/models/tan_user.dart';
import 'package:manvsim/screens/qr_screen.dart';
import 'package:manvsim/widgets/error_box.dart';
import 'package:manvsim/widgets/tan_input.dart';
import 'package:provider/provider.dart';

import '../services/api_service.dart';
import 'name_screen.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'wait_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

enum _LoginInputType { tan, url }

class LoginScreenState extends State<LoginScreen> {

  final TanInputController _tanInputController = TanInputController();
  final TextEditingController _serverUrlController =
      TextEditingController(text: "http://localhost:5000/api");

  String? _errorMessage;

  bool _tanInputFailure = false;
  bool _urlInputFailure = false;

  bool _isLoading = false;

  bool _showAdvancedSettings = false;

  InputDecoration _textFieldDecoration(bool hasInputFailure, String text) {
    return InputDecoration(
      labelText: text,
      fillColor: hasInputFailure ? Colors.red.shade50 : null,
      filled: hasInputFailure,
      border: hasInputFailure
          ? const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            )
          : const UnderlineInputBorder(),
    );
  }

  void _resetErrorMessage(_LoginInputType? inputType) {
    if (_errorMessage != null || _tanInputFailure || _urlInputFailure) {
      bool tanFailure = _tanInputFailure;
      bool urlFailure = _urlInputFailure;
      switch (inputType) {
        case _LoginInputType.tan:
          tanFailure = false;
          break;
        case _LoginInputType.url:
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
    TanUser user = Provider.of<TanUser>(context, listen: false);

    if (user.name == null || user.name!.isEmpty) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const NameScreen()),
        (Route<dynamic> route) => false,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.loginAlreadyLoggedInHeader),
          content: Text(AppLocalizations.of(context)!
              .loginAlreadyLoggedInText(user.name!)),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!
                  .loginAlreadyLoggedInButtonCancel),
              onPressed: () {
                ApiService apiService = GetIt.instance.get<ApiService>();
                apiService.logout(context);
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!
                  .loginAlreadyLoggedInButtonContinue),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const WaitScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  /// Assumes that [tan] is complete.
  void _handleLogin(String tan) async {
    String url = _serverUrlController.text;

    if (tan.isEmpty || url.isEmpty) {
      setState(() {
        _tanInputFailure = tan.isEmpty;
        _urlInputFailure = url.isEmpty;
        _errorMessage = AppLocalizations.of(context)!.loginWarningEmptyFields;
      });
      return;
    }

    setState(() {
      _tanInputFailure = false;
      _urlInputFailure = false;
      _errorMessage = null;
      _isLoading = true;
    });

    ApiService apiService = GetIt.instance.get<ApiService>();
    try {
      await apiService.login(tan, url, context);
    } catch (e) {
      _handleLoginError(e);
      _tanInputController.clear();
      return;
    }
    _navigateToNext();
  }

  void _handleLoginError(dynamic error) {
    String failureMessage = error.toString();
    int maxLength = 80;
    String shortFailureMessage = (failureMessage.length > maxLength)
        ? '${failureMessage.substring(0, maxLength).trim()}...'
        : failureMessage.trim();

    shortFailureMessage =
        shortFailureMessage.replaceAll(RegExp(r'[\n\t]'), ' ');

    setState(() {
      _errorMessage = AppLocalizations.of(context)!
          .loginWarningRequestFailed(shortFailureMessage);
      _isLoading = false;
    });
  }

  _onQRCodeScan() async {
    final scannedQR = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QRScreen(),
      ),
    );
    if (scannedQR case String scannedText) {
      final [url, ..., tan] = scannedText.split(';');

      _serverUrlController.text = url;
      for (int i = 0; i < min(TanInputController.tanLength, tan.length); i++) {
        _tanInputController.updateValue(i, tan.toUpperCase()[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [


              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.loginTANHeader,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(AppLocalizations.of(context)!.loginTANText),
              const SizedBox(height: 16),

              if (_errorMessage != null) // Show error message if it's not null
                ErrorBox(errorText: _errorMessage!),
              const SizedBox(height: 16),
              TanInputField(
                controller: _tanInputController,
                decoration: _textFieldDecoration(_tanInputFailure, ""),
                onChanged: (value) {
                  if (value.isNotEmpty) _resetErrorMessage(_LoginInputType.tan);
                },
              ),
              const SizedBox(height: 32),
              TextButton(
                onPressed: () {
                  setState(() {
                    _showAdvancedSettings = !_showAdvancedSettings;
                  });
                },
                child: Text(_showAdvancedSettings
                    ? AppLocalizations.of(context)!.loginHideAdvancedSettings
                    : AppLocalizations.of(context)!.loginShowAdvancedSettings),
              ),
              if (_showAdvancedSettings)
                TextField(
                  controller: _serverUrlController,
                  decoration: _textFieldDecoration(_urlInputFailure,
                      AppLocalizations.of(context)!.loginServerUrl),
                  onChanged: (value) => _resetErrorMessage(_LoginInputType.url),
                ),
              const SizedBox(height: 32),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.qr_code_scanner),
                        label: Text(
                            AppLocalizations.of(context)!.qrCodeScanButton),
                        onPressed: _onQRCodeScan,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      // Button only clickable when tan is complete
                      child: ValueListenableBuilder(
                        valueListenable: _tanInputController,
                        builder: (context, tan, child) => ElevatedButton.icon(
                          icon: const Icon(Icons.login),
                          onPressed: _tanInputController.isComplete
                              ? () => _handleLogin(tan)
                              : null,
                          label:
                              Text(AppLocalizations.of(context)!.loginSubmit),
                        ),
                      ),
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
