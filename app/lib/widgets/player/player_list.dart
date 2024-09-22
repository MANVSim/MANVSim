import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manvsim/models/person.dart';
import 'package:provider/provider.dart';

import '../../constants/manv_icons.dart';
import '../../models/tan_user.dart';

class PlayerList extends StatelessWidget {
  final Persons persons;
  final String emptyText;

  const PlayerList({required this.persons, required this.emptyText, super.key});

  Widget _buildPlayer(PlayerPerson player, BuildContext context) {
    TanUser user = Provider.of<TanUser>(context, listen: false);
    bool isPlayerMe = player.tan == user.tan;
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    ManvIcons.user,
                    size: 30,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isPlayerMe ? "${player.name} (Ich)" : player.name,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Row(
                        children: [
                          const Icon(
                            ManvIcons.role,
                            size: 10,
                          ),
                          const SizedBox(width: 2),
                          Text(player.role,
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ])));
  }

  Widget _buildEmpty(BuildContext context) {
    return Card(
        child: SizedBox(
            width: double.infinity,
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(emptyText))));
  }

  @override
  Widget build(BuildContext context) {
    PlayerPersons players =
        persons.players.where((player) => player.name.isNotEmpty).toList();

    if (players.isEmpty) {
      return _buildEmpty(context);
    } else {
      return Column(
        children: [
          for (var player in players) _buildPlayer(player, context),
        ],
      );
    }

  }
}
