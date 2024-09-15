import 'package:flutter/material.dart';
import 'package:manvsim/constants/manv_icons.dart';
import 'package:manvsim/widgets/logout_button.dart';
import 'package:provider/provider.dart';

import '../models/tan_user.dart';

class PlayerOverview extends StatelessWidget {
  const PlayerOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final TanUser tanUser = Provider.of<TanUser>(context, listen: false);
    final String name = tanUser.name!;
    final String role = tanUser.role!;

    return Padding(
        padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
        child: Card(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    ManvIcons.user,
                    size: 50,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Row(
                        children: [
                          const Icon(
                            ManvIcons.role,
                            size: 15,
                          ),
                          const SizedBox(width: 4),
                          Text(role),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  const LogoutButton(),
                ],
              ),
            ],
          ),
        )));
  }
}
