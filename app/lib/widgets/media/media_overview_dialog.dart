import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:manvsim/models/multi_media.dart';
import 'package:manvsim/widgets/media/multi_media_view.dart';

import '../../services/size_service.dart';

class MediaOverViewDialog extends StatelessWidget {
  final String title;
  final MultiMediaCollection media;

  const MediaOverViewDialog(
      {super.key, required this.title, required this.media});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      content: SizedBox(
          width: SizeService.getScreenWidth(context) * 0.8,
          child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: MultiMediaView(multiMediaCollection: media))),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(AppLocalizations.of(context)!.dialogueClose),
        ),
      ],
    );
  }
}
