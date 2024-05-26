import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manvsim/models/patient.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PatientOverview extends StatefulWidget {
  final Patient patient;

  const PatientOverview({super.key, required this.patient});

  @override
  State<PatientOverview> createState() => _PatientOverviewState();
}

class _PatientOverviewState extends State<PatientOverview> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.patientName(widget.patient.name),
              style:
                  DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),
            ),
            Text(
                AppLocalizations.of(context)!
                    .patientInjuries(widget.patient.injuries),
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 1.5))
          ],
        ));
  }
}
