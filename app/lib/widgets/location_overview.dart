import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manvsim/constants/manv_icons.dart';
import 'package:manvsim/models/location.dart';

import 'package:manvsim/widgets/media_overview_expansion.dart';

class LocationOverview extends StatelessWidget {
  final Location location;

  const LocationOverview({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return MediaOverviewExpansion(media: location.media, children: [
      Row(children: [
        const Icon(ManvIcons.location),
        const SizedBox(width: 8),
        Expanded(child: Text(
          location.name,
          style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),
          softWrap: true,
          overflow: TextOverflow.visible,
        )),
      ]),
    ]);
  }
}