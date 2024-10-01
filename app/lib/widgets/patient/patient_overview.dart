import 'package:flutter/material.dart';
import 'package:manvsim/models/patient.dart';
import 'package:manvsim/services/patient_service.dart';
import 'package:manvsim/widgets/media/media_overview_expansion.dart';

import '../../constants/manv_icons.dart';

class PatientOverview extends StatefulWidget {
  final Patient patient;

  final bool initiallyExpanded;

  const PatientOverview(
      {super.key, required this.patient, this.initiallyExpanded = true});

  @override
  State<PatientOverview> createState() => _PatientOverviewState();
}

class _PatientOverviewState extends State<PatientOverview> {
  @override
  Widget build(BuildContext context) {
    return MediaOverviewExpansion(
        initiallyExpanded: widget.initiallyExpanded,
        media: widget.patient.media,
        children: [
          Row(children: [
            const Icon(ManvIcons.patient),
            const SizedBox(width: 8),
            Expanded(
                child: Text(
              widget.patient.name,
              style:
                  DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),
              softWrap: true,
              overflow: TextOverflow.visible,
            )),
          ]),
          Row(children: [
            const Icon(ManvIcons.location),
            IconButton(
                icon: const Icon(ManvIcons.info),
                onPressed: () =>
                    PatientService.showLocation(widget.patient, context)),
            Expanded(
                child: Text(
              widget.patient.location.name,
              style:
                  DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),
              softWrap: true,
              overflow: TextOverflow.visible,
            )),
          ]),
        ]);
  }
}
