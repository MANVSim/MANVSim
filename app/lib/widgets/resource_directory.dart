import 'package:flutter/cupertino.dart';
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
            shape: const Border(), // removes border on top and bottom
            childrenPadding: const EdgeInsets.only(left: 8.0),
            children: [
              ListView.builder(
                shrinkWrap: true, // nested scrolling
                physics: const ClampingScrollPhysics(),
                itemCount: location.resource.length,
                itemBuilder: (context, index) {
                  Resource resource = location.resource[index];
                  return Card(
                      color: resource.selected
                          ? Colors.lightGreen
                          : Colors.deepOrangeAccent,
                      child: ListTile(
                          leading: Text('${resource.quantity}'),
                          title: Text(resource.name),
                          onTap: () {
                            // TODO: maybe reset after changing patient or rework approach
                            resource.selected = !resource.selected;
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
