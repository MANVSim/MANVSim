import 'package:flutter/material.dart';
import 'package:manvsim/constants/icons.dart' as icons;
import 'package:manvsim/models/multi_media.dart';

import 'muti_media_view.dart';

class MediaOverviewExpansion extends StatefulWidget {
  final List<Widget> children;
  final MultiMediaCollection media;

  const MediaOverviewExpansion(
      {super.key, required this.children, required this.media});

  @override
  State<MediaOverviewExpansion> createState() => _MediaOverviewExpansionState();
}

class _MediaOverviewExpansionState extends State<MediaOverviewExpansion> {
  bool _detailsVisible = true;

  Widget _title() {
    return SizedBox(
        width: double.infinity,
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.children,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return (widget.media.isEmpty)
        ? _title()
        : ExpansionTile(
            title: _title(),
            controlAffinity: ListTileControlAffinity.trailing,
            shape: const Border(),
            childrenPadding: const EdgeInsets.only(left: 8.0),
            initiallyExpanded: _detailsVisible,
            trailing: (_detailsVisible) ? null : const Icon(icons.Icons.info),
            onExpansionChanged: (expanded) {
              setState(() {
                _detailsVisible = expanded;
              });
            },
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: MultiMediaView(multiMediaCollection: widget.media)),
            ],
          );
  }
}
