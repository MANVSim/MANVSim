import 'package:flutter/material.dart';
import 'package:manvsim/models/location.dart';
import 'package:manvsim/models/resource.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResourceDirectory extends StatefulWidget {
  final List<Location> locations;
  final bool initiallyExpanded;
  final bool rootLocationsSelectable;
  final bool parentLocationSelected;

  // function to propagate toggling to parent
  final Function(Resource resource) resourceToggle;
  final Function(List<Location>? selectedLocationPath)? onLocationSelected;

  const ResourceDirectory(
      {super.key,
      required this.locations,
      required this.resourceToggle,
      this.initiallyExpanded = false,
      this.onLocationSelected,
      this.rootLocationsSelectable = true,
      this.parentLocationSelected = false});

  @override
  State<ResourceDirectory> createState() => _ResourceDirectoryState();
}

class _ResourceDirectoryState extends State<ResourceDirectory> {

  int? selectedLocationIndex;

  @override
  void didUpdateWidget(ResourceDirectory oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.parentLocationSelected && selectedLocationIndex != null) {
      setState(() {
        selectedLocationIndex = null;
      });
    }
  }
  
  bool _isLocationSelected(int index) {
    return selectedLocationIndex == index;
  }

  void _locationSelected(int index) {
    
    int? newSelectedLocationIndex;
    List<Location>? currentSelectedPath;
    
    if (_isLocationSelected(index)) {
      newSelectedLocationIndex = null;
      currentSelectedPath = null;
    } else {
      newSelectedLocationIndex = index;
      currentSelectedPath = [widget.locations[index]];
    }
    
    setState(() {
      selectedLocationIndex = newSelectedLocationIndex;
    });
    widget.onLocationSelected!(currentSelectedPath);
  }

  void _handleChildLocationSelected(List<Location>? oldSelectedLocationPath, Location location) {
    List<Location>? newSelectedLocationPath= oldSelectedLocationPath != null
      ? [location, ...oldSelectedLocationPath]
      : null;

    setState(() {
      selectedLocationIndex = null;
    });

    widget.onLocationSelected!(newSelectedLocationPath);
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
              color: _isLocationSelected(locationIndex)
                  ? Colors.lightGreen.shade400
                  : widget.parentLocationSelected
                      ? Colors.lightGreen.shade200
                      : Theme.of(context).cardColor,
              child: ExpansionTile(
                initiallyExpanded: widget.initiallyExpanded,
                title: Row(
                  children: [
                    Text(location.name),
                    const Spacer(),
                    if (widget.onLocationSelected != null && widget.rootLocationsSelectable)
                      ElevatedButton(
                          child: Text(_isLocationSelected(locationIndex)
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
                    onLocationSelected: widget.onLocationSelected != null
                        ? (selectedLocationPath) =>
                            _handleChildLocationSelected(selectedLocationPath, location)
                        : null,
                    parentLocationSelected: _isLocationSelected(locationIndex),
                  )
                ],
              ));
        });
  }
}
