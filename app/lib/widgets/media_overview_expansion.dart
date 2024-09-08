import 'package:flutter/material.dart';
import 'package:manvsim/constants/manv_icons.dart';
import 'package:manvsim/models/multi_media.dart';

import 'multi_media_view.dart';

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.children,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return (widget.media.isEmpty)
        ? Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8), child: _title())
        : ExpansionTile(
            title: _title(),
            controlAffinity: ListTileControlAffinity.trailing,
            shape: const Border(),
            childrenPadding: const EdgeInsets.only(left: 8.0),
            initiallyExpanded: _detailsVisible,
            trailing: (_detailsVisible) ? null : const Icon(ManvIcons.info),
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
