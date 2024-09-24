import 'package:flutter/material.dart';
import 'package:manvsim/constants/manv_icons.dart';
import 'package:manvsim/models/location.dart';
import 'package:manvsim/models/patient.dart';

class MoveOverview extends StatelessWidget {
  final Patient patient;
  final Location to;

  const MoveOverview(
      {super.key,
        required this.to,
        required this.patient});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Icon(ManvIcons.patient),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(patient.name,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineMedium)),
            ]),
            Row(children: [
              const Icon(ManvIcons.location),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(patient.location.name,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineSmall)),
            ]),
            Row(children: [
              const Icon(Icons.arrow_forward),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(to.name,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineSmall)),
            ]),
          ],
        ),
      ),
    );
  }
}
