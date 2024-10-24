import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manvsim/models/location.dart';
import 'package:manvsim/models/resource.dart';
import 'package:manvsim/widgets/media/media_info.dart';

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
  List<Location>? _selectedLocationPath;

  _handleLocationSelected(List<Location>? selectedLocationPath) {
    setState(() {
      _selectedLocationPath = selectedLocationPath;
    });

    widget.onLocationSelected!(selectedLocationPath);
  }

  _handleCollapse(List<Location> collapsePath) {
    if (_selectedLocationPath != null &&
        collapsePath.length < _selectedLocationPath!.length) {
      for (int i = 0; i < collapsePath.length; i++) {
        if (collapsePath[i] != _selectedLocationPath![i]) {
          return;
        }
      }

      if (widget.onLocationSelected != null) {
        widget.onLocationSelected!(null);
      }

      setState(() {
        _selectedLocationPath = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _InternalResourceDirectory(
      locations: widget.locations,
      globalSelectedLocation: _selectedLocationPath?.last,
      onCollapse: _handleCollapse,
      resourceToggle: widget.resourceToggle,
      initiallyExpanded: widget.initiallyExpanded,
      onLocationSelected: widget.onLocationSelected != null
          ? (selectedLocationPath) =>
              _handleLocationSelected(selectedLocationPath)
          : null,
      rootLocationsSelectable: widget.rootLocationsSelectable,
      parentLocationSelected: widget.parentLocationSelected,
    );
  }
}

class _InternalResourceDirectory extends StatefulWidget {
  final List<Location> locations;
  final Location? globalSelectedLocation;
  final bool initiallyExpanded;
  final bool rootLocationsSelectable;
  final bool parentLocationSelected;

  // function to propagate toggling to parent
  final Function(Resource resource) resourceToggle;
  final Function(List<Location>? selectedLocationPath)? onLocationSelected;
  final Function(List<Location> selectedLocationPath) onCollapse;

  const _InternalResourceDirectory(
      {super.key,
      required this.locations,
      required this.resourceToggle,
      required this.globalSelectedLocation,
      required this.onCollapse,
      this.initiallyExpanded = false,
      this.onLocationSelected,
      this.rootLocationsSelectable = true,
      this.parentLocationSelected = false});

  @override
  State<_InternalResourceDirectory> createState() =>
      _InternalResourceDirectoryState();
}

class _InternalResourceDirectoryState
    extends State<_InternalResourceDirectory> {
  int? selectedLocationIndex;

  @override
  void didUpdateWidget(_InternalResourceDirectory oldWidget) {
    super.didUpdateWidget(oldWidget);

    bool parentLocationBecomeSelected =
        widget.parentLocationSelected && selectedLocationIndex != null;
    bool locationsChanged = widget.onLocationSelected != null &&
        widget.locations != oldWidget.locations;

    if (parentLocationBecomeSelected || locationsChanged) {
      setState(() {
        selectedLocationIndex = null;
      });
    }

    if (selectedLocationIndex != null) {
      if (widget.globalSelectedLocation !=
          widget.locations[selectedLocationIndex!]) {
        setState(() {
          selectedLocationIndex = null;
        });
      }
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

  _handleChildCollapsed(List<Location> collapsePath, Location location) {
    widget.onCollapse([location, ...collapsePath]);
  }

  void _handleChildLocationSelected(
      List<Location>? childSelectedLocationPath, Location location) {
    List<Location>? newSelectedLocationPath = childSelectedLocationPath != null
        ? [location, ...childSelectedLocationPath]
        : null;

    setState(() {
      selectedLocationIndex = null;
    });

    widget.onLocationSelected!(newSelectedLocationPath);
  }

  @override
  Widget build(BuildContext context) {
    bool selectable =
        widget.onLocationSelected != null && widget.rootLocationsSelectable;

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
                onExpansionChanged: (expanded) {
                  if (!expanded) {
                    widget.onCollapse([location]);
                  }
                },
                initiallyExpanded: widget.initiallyExpanded,
                title: Text(location.name),
                trailing: (selectable ||
                        (location.media.isNotEmpty &&
                            widget.rootLocationsSelectable))
                    ? Row(mainAxisSize: MainAxisSize.min, children: [
                        if (selectable)
                          ElevatedButton(
                              child: Text(_isLocationSelected(locationIndex)
                                  ? (AppLocalizations.of(context)!
                                      .resourceDirectoryUnselectLocation)
                                  : (AppLocalizations.of(context)!
                                      .resourceDirectorySelectLocation)),
                              onPressed: () =>
                                  _locationSelected(locationIndex)),
                        if (location.media.isNotEmpty &&
                            widget.rootLocationsSelectable)
                          MediaInfo(title: location.name, media: location.media)
                      ])
                    : null,
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
                              leading: Text(resource.quantity < 10000
                                  ? '${resource.quantity}'
                                  : '\u221e'),
                              title: Text(resource.name),
                              trailing: (resource.media.isNotEmpty)
                                  ? MediaInfo(
                                      title: resource.name,
                                      media: resource.media)
                                  : null,
                              onTap: () {
                                widget.resourceToggle(resource);
                              }));
                    },
                  ),
                  _InternalResourceDirectory(
                    onCollapse: (childSelectedLocationPath) =>
                        _handleChildCollapsed(
                            childSelectedLocationPath, location),
                    globalSelectedLocation: widget.globalSelectedLocation,
                    locations: location.locations,
                    resourceToggle: widget.resourceToggle,
                    onLocationSelected: widget.onLocationSelected != null
                        ? (selectedLocationPath) =>
                            _handleChildLocationSelected(
                                selectedLocationPath, location)
                        : null,
                    parentLocationSelected: (widget.parentLocationSelected)
                        ? true
                        : _isLocationSelected(locationIndex),
                  )
                ],
              ));
        });
  }
}
