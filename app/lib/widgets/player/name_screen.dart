import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:manv_api/api.dart';
import 'package:manvsim/models/tan_user.dart';
import 'package:manvsim/widgets/util/error_box.dart';
import 'package:provider/provider.dart';

import '../../services/api_service.dart';
import 'logout_button.dart';
import 'wait_screen.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<StatefulWidget> createState() => NameScreenState();
}

class NameScreenState extends State<NameScreen> {
  final TextEditingController _nameController = TextEditingController();

  String? _errorMessage;
  bool _isLoading = false;

  void _resetErrorMessage() {
    if (_errorMessage != null) {
      setState(() {
        _errorMessage = null;
      });
    }
  }

  /// Assumes [name] is not empty.
  void _handleSetName(String name) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const <Widget>[LogoutButton()],
        title: Text(AppLocalizations.of(context)!.nameScreenName),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_errorMessage != null) // Show error message if it's not null
                ErrorBox(errorText: _errorMessage!),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                onChanged: (value) => _resetErrorMessage(),
              ),
              const SizedBox(height: 16),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                // Button only clickable when text is not empty
                ValueListenableBuilder(
                  valueListenable: _nameController,
                  builder: (context, value, child) => ElevatedButton.icon(
                    onPressed: value.text.isEmpty
                        ? null
                        : () => _handleSetName(value.text),
                    icon: const Icon(Icons.start),
                    label: Text(AppLocalizations.of(context)!.nameSubmit),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
