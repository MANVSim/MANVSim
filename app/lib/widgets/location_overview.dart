import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manvsim/models/location.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manvsim/widgets/media_overview_expansion.dart';

class LocationOverview extends StatefulWidget {
  final Location location;

  const LocationOverview({super.key, required this.location});

  @override
  State<LocationOverview> createState() => _LocationOverviewState();
}

class _LocationOverviewState extends State<LocationOverview> {

  @override
  Widget build(BuildContext context) {
    return MediaOverviewExpansion(media: widget.location.media, children: [
      Text(
        AppLocalizations.of(context)!.patientName(widget.location.name),
        style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),
      ),
    ]);
  }
}
