import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manvsim/models/location.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manvsim/widgets/muti_media_view.dart';

class LocationOverview extends StatefulWidget {
  final Location location;

  const LocationOverview({super.key, required this.location});

  @override
  State<LocationOverview> createState() => _LocationOverviewState();
}

class _LocationOverviewState extends State<LocationOverview> {
  bool _detailsVisible = true;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .patientName(widget.location.name),
                    style: DefaultTextStyle.of(context)
                        .style
                        .apply(fontSizeFactor: 2.0),
                  ),
                ],
              ))),
      controlAffinity: ListTileControlAffinity.trailing,
      shape: const Border(),
      childrenPadding: const EdgeInsets.only(left: 8.0),
      initiallyExpanded: _detailsVisible,
      trailing: (_detailsVisible) ? null : const Icon(Icons.info),
      onExpansionChanged: (expanded) {
        setState(() {
          _detailsVisible = expanded;
        });
      },
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: MultiMediaView(multiMediaCollection: widget.location.media)),

      ],
    );
  }
}
