import 'package:flutter/material.dart';
import 'package:manvsim/models/location.dart';
import 'package:manvsim/models/resource.dart';

class ResourceDirectory extends StatefulWidget {
  final List<Location> locations;

  // function to propagate toggling to parent
  final Function(Resource resource) resourceToggle;

  const ResourceDirectory(
      {super.key, required this.locations, required this.resourceToggle});

  @override
  State<ResourceDirectory> createState() => _ResourceDirectoryState();
}

class _ResourceDirectoryState extends State<ResourceDirectory> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true, // nested scrolling
        physics: const ClampingScrollPhysics(),
        itemCount: widget.locations.length,
        itemBuilder: (context, index) {
          final location = widget.locations[index];
          return Card(
              child: ExpansionTile(
            title: Text(location.name),
            controlAffinity: ListTileControlAffinity.leading,
            // removes border on top and bottom
            shape: const Border(),
            childrenPadding: const EdgeInsets.only(left: 8.0),
            children: [
              ListView.builder(
                shrinkWrap: true, // nested scrolling
                physics: const ClampingScrollPhysics(),
                itemCount: location.resources.length,
                itemBuilder: (context, index) {
                  Resource resource = location.resources[index];
                  return Card(
                      color:
                          resource.selected ? Colors.lightGreen : Colors.grey,
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
              )
            ],
          ));
        });
  }
}
