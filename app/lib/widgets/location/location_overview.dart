import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manvsim/constants/manv_icons.dart';
import 'package:manvsim/models/location.dart';
import 'package:manvsim/widgets/media/media_overview_expansion.dart';

class LocationOverview extends StatelessWidget {
  final Location location;
  final bool initiallyExpanded;

  const LocationOverview(
      {super.key, required this.location, this.initiallyExpanded = false});

  @override
  Widget build(BuildContext context) {
    return MediaOverviewExpansion(
        initiallyExpanded: initiallyExpanded,
        media: location.media,
        children: [
          Row(children: [
            const Icon(ManvIcons.location),
            const SizedBox(width: 8),
            Expanded(
                child: Text(
              location.name,
              style:
                  DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),
              softWrap: true,
              overflow: TextOverflow.visible,
            )),
          ]),
        ]);
  }
}
