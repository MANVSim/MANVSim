import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manvsim/models/location.dart';
import 'package:manvsim/widgets/media/media_info.dart';

import '../../services/location_service.dart';

class MoveCard extends StatefulWidget {
  final List<Location> locations;
  final Function(Location location) onPerform;

  const MoveCard({super.key, required this.locations, required this.onPerform});

  @override
  State<MoveCard> createState() => _MoveCardState();
}

class _MoveCardState extends State<MoveCard> {
  late Future<List<Location>?> futureLocationIdList;

  int? selectedLocationIndex;

  @override
  void initState() {
    futureLocationIdList = LocationService.fetchLocations();
    super.initState();
  }

  bool isSelected(int index) {
    return selectedLocationIndex != null && selectedLocationIndex == index;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ExpansionTile(
      initiallyExpanded: true,
      title: Text(AppLocalizations.of(context)!.patientMoveSelection),
      controlAffinity: ListTileControlAffinity.leading,
      // removes border on top and bottom
      shape: const Border(),
      childrenPadding: const EdgeInsets.only(left: 8.0),
      children: [
        ListView.builder(
          shrinkWrap: true, // nested scrolling
          physics: const ClampingScrollPhysics(),
          itemCount: widget.locations.length,
          itemBuilder: (context, index) {
            Location location = widget.locations[index];
            return Card(
                color: isSelected(index) ? Colors.lightGreen : Colors.grey,
                child: ListTile(
                  title: Text(location.name),
                  onTap: () {
                    setState(() {
                      selectedLocationIndex =
                          selectedLocationIndex == index ? null : index;
                    });
                  },
                  trailing:
                      MediaInfo(title: location.name, media: location.media),
                ));
          },
        ),
        if (selectedLocationIndex != null) ...[
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
              ),
              onPressed: () {
                widget.onPerform(widget.locations[selectedLocationIndex!]);
              },
              child: Text(AppLocalizations.of(context)!.actionPerform),
            ),
          ]),
          const SizedBox(height: 8),
        ]
      ],
    ));
  }
}
