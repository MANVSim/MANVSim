import 'package:flutter/material.dart';
import 'package:manvsim/models/multi_media.dart';

import 'media_overview_dialog.dart';

import 'package:manvsim/constants/icons.dart' as icons;

class MediaInfo extends StatelessWidget {
  final String title;
  final MultiMediaCollection media;

  const MediaInfo({super.key, required this.title, required this.media});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) =>
                  MediaOverViewDialog(title: title, media: media));
        },
        icon: const Icon(icons.Icons.info));
  }
}
