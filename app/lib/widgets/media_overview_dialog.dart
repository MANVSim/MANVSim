

import 'package:flutter/material.dart';
import 'package:manvsim/models/multi_media.dart';
import 'package:manvsim/widgets/muti_media_view.dart';

class MediaOverViewDialog extends StatefulWidget {

  final String title;
  final MultiMediaCollection media;

  const MediaOverViewDialog({super.key, required this.title, required this.media});

  @override
  State<MediaOverViewDialog> createState() => _MediaOverViewDialogState();
}

class _MediaOverViewDialogState extends State<MediaOverViewDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title, style: Theme.of(context).textTheme.headlineMedium,),
      content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: MultiMediaView(multiMediaCollection: widget.media))),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Schließen'),
        ),
      ],
    );
  }
}