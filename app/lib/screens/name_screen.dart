import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manv_api/api.dart';
import 'package:manvsim/models/tan_user.dart';
import 'package:provider/provider.dart';

import '../services/api_service.dart';
import '../widgets/logout_button.dart';
import 'wait_screen.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<StatefulWidget> createState() => NameScreenState();
}

class NameScreenState extends State<NameScreen> {
  final TextEditingController _nameController = TextEditingController();

  String? _errorMessage;
  bool _nameInputFailure = false;
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

  void _resetErrorMessage() {
    if (_errorMessage != null || _nameInputFailure) {
      setState(() {
        _errorMessage = null;
        _nameInputFailure = false;
      });
    }
  }

  void _handleSetName() async {
    String name = _nameController.text;

    if (name.isEmpty) {
      setState(() {
        _nameInputFailure = true;
        _errorMessage = AppLocalizations.of(context)!.nameWarningEmptyFields;
      });
    } else {
      setState(() {
        _isLoading = true;
      });

      String? failureMessage;

      ApiService apiService = GetIt.instance.get<ApiService>();

      try {
        await apiService.api
            .playerSetNamePost(PlayerSetNamePostRequest(name: name));
      } on ApiException catch (e) {
        apiService.handleErrorCode(e, context);
        failureMessage = e.toString();
      } catch (e) {
        failureMessage = e.toString();
      }

      setState(() {
        _nameInputFailure = false;
        _errorMessage = failureMessage;
        _isLoading = false;
      });

      if (failureMessage == null) {
        TanUser user = Provider.of<TanUser>(context, listen: false);
        user.name = name;
        await user.persist();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const WaitScreen()),
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const <Widget>[LogoutButton()],
        title: Text(AppLocalizations.of(context)!.nameScreenName),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
                controller: _nameController,
                decoration: _textFieldDecoration(
                    _nameInputFailure, AppLocalizations.of(context)!.nameName),
                onChanged: (value) => _resetErrorMessage(),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _handleSetName,
                icon: const Icon(Icons.start),
                label: Text(AppLocalizations.of(context)!.nameSubmit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
