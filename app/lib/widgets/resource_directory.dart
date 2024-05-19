import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manvsim/models/location.dart';
import 'package:manvsim/screens/action_screen.dart';

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
                itemCount: location.actions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Text(location.actions[index].name),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ActionScreen(
                                    action: location.actions[index])));
                      });
                },
              ),
              ResourceDirectory(locations: location.locations)
            ],
          ));
        });
  }
}
