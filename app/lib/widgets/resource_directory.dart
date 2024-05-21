import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manvsim/models/location.dart';

class ResourceDirectory extends StatefulWidget {
  final List<Location> locations;

  const ResourceDirectory({super.key, required this.locations});

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
                  return Card(
                      color: Colors.deepOrangeAccent,
                      child: ListTile(
                          leading: Text('${location.resource[index].quantity}'),
                          title: Text(location.resource[index].name),
                          onTap: () {}));
                },
              ),
              ResourceDirectory(locations: location.locations)
            ],
          ));
        });
  }
}
