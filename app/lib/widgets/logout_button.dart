import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manvsim/services/api_service.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () {
        ApiService apiService = GetIt.instance.get<ApiService>();
        apiService.logout(context);
      },
    );
  }
}
