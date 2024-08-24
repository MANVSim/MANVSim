import 'package:flutter/material.dart';
import 'package:manvsim/models/location.dart';
import 'package:manvsim/models/resource.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResourceDirectory extends StatefulWidget {
  final List<Location> locations;
  final bool initiallyExpanded;
  final bool rootLocationsSelectable;

  // function to propagate toggling to parent
  final Function(Resource resource) resourceToggle;
  final Function(Location location, bool selected)? onLocationSelected;

  const ResourceDirectory(
      {super.key,
      required this.locations,
      required this.resourceToggle,
      this.initiallyExpanded = false,
      this.onLocationSelected,
      this.rootLocationsSelectable = true});

  @override
  State<ResourceDirectory> createState() => _ResourceDirectoryState();
}

class _ResourceDirectoryState extends State<ResourceDirectory> {
  late List<bool> isLocationSelected;

  @override
  void initState() {
    isLocationSelected = List.filled(widget.locations.length, false);
    super.initState();
  }

  void _locationSelected(int index) {
    setState(() {
      isLocationSelected[index] = !isLocationSelected[index];
    });
    widget.onLocationSelected!(
        widget.locations[index], isLocationSelected[index]);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true, // nested scrolling
        physics: const ClampingScrollPhysics(),
        itemCount: widget.locations.length,
        itemBuilder: (context, locationIndex) {
          final location = widget.locations[locationIndex];
          return Card(
              color: isLocationSelected[locationIndex]
                  ? Colors.lightGreen
                  : Theme.of(context).cardColor,
              child: ExpansionTile(
                initiallyExpanded: widget.initiallyExpanded,
                title: Row(
                  children: [
                    Text(location.name),
                    const Spacer(),
                    if (widget.onLocationSelected != null && widget.rootLocationsSelectable)
                      ElevatedButton(
                          child: Text(isLocationSelected[locationIndex]
                              ? (AppLocalizations.of(context)!.resourceDirectoryUnselectLocation)
                              : (AppLocalizations.of(context)!.resourceDirectorySelectLocation)),
                          onPressed: () => _locationSelected(locationIndex))
                  ],
                ),
                controlAffinity: ListTileControlAffinity.leading,
                // removes border on top and bottom
                shape: const Border(),
                childrenPadding: const EdgeInsets.only(left: 8.0),
                children: [
                  ListView.builder(
                    shrinkWrap: true, // nested scrolling
                    physics: const ClampingScrollPhysics(),
                    itemCount: location.resources.length,
                    itemBuilder: (context, resourceIndex) {
                      Resource resource = location.resources[resourceIndex];
                      return Card(
                          color: resource.selected
                              ? Colors.lightGreen
                              : Colors.grey,
                          child: ListTile(
                              leading: Text(resource.quantity < 10
                                  ? '${resource.quantity}'
                                  : '\u221e'),
                              title: Text(resource.name),
                              onTap: () {
                                widget.resourceToggle(resource);
                              }));
                    },
                  ),
                  ResourceDirectory(
                    locations: location.locations,
                    resourceToggle: widget.resourceToggle,
                    onLocationSelected: isLocationSelected[locationIndex]
                        ? null
                        : widget.onLocationSelected,
                  )
                ],
              ));
        });
  }
}
