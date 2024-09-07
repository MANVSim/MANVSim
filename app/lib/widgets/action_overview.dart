import 'package:flutter/material.dart';

import 'package:manvsim/constants/icons.dart' as icons;

import 'package:manvsim/models/patient.dart';
import 'package:manvsim/models/patient_action.dart';

import 'media_info.dart';

class ActionOverview extends StatelessWidget {
  final PatientAction action;
  final Patient patient;
  final bool showMediaInfo;

  const ActionOverview(
      {super.key,
      required this.action,
      required this.patient,
      this.showMediaInfo = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Icon(icons.Icons.action),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(action.name,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineMedium)),
              if (showMediaInfo && action.media.isNotEmpty)
                MediaInfo(title: action.name, media: action.media),
            ]),
            Row(children: [
              const Icon(icons.Icons.patient),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(patient.name,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineSmall)),
              if (showMediaInfo && patient.media.isNotEmpty)
                MediaInfo(title: patient.name, media: patient.media),
            ]),
            Row(children: [
              const Icon(icons.Icons.location),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(patient.location.name,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineSmall)),
              if (showMediaInfo && patient.location.media.isNotEmpty)
                MediaInfo(
                    title: patient.location.name,
                    media: patient.location.media),
            ]),
          ],
        ),
      ),
    );
  }
}
