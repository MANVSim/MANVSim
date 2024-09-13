import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:manvsim/models/multi_media.dart';
import 'package:manvsim/services/api_service.dart';
import 'package:manvsim/widgets/api_future_builder.dart';
import 'package:manvsim/widgets/error_box.dart';
import 'package:manvsim/widgets/video_player.dart';

import 'package:http/http.dart' as http;

import 'audio_player.dart';

class MultiMediaView extends StatefulWidget {
  final MultiMediaCollection multiMediaCollection;

  const MultiMediaView({super.key, required this.multiMediaCollection});

  @override
  State<MultiMediaView> createState() => _MultiMediaViewState();
}

class _MultiMediaViewState extends State<MultiMediaView> {
  String buildMediaUrl(String reference) {
    ApiService apiService = GetIt.instance.get<ApiService>();
    return apiService.buildMediaUrl(context, reference);
  }

  int getMediaTypeNumber(int index) {
    MediaType mediaType = widget.multiMediaCollection[index].type;
    int count = 0;

    for (int i = 0; i <= index; i++) {
      if (widget.multiMediaCollection[i].type == mediaType) {
        count++;
      }
    }

    return count;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.multiMediaCollection.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final item = widget.multiMediaCollection[index];
        return Padding(
          padding: EdgeInsets.fromLTRB(0, (index == 0) ? 0 : 32, 0, 0),
          child: _buildMediaItem(item, index),
        );
      },
    );
  }

  Widget _buildMediaItem(MultiMediaItem item, int index) {
    switch (item.type) {
      case MediaType.image:
        return _buildImageItem(item, index);
      case MediaType.video:
        return _buildVideoItem(item, index);
      case MediaType.text:
        return _buildTextItem(item);
      case MediaType.audio:
        return _buildAudioItem(item, index);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSubtitledItem(
      {required MultiMediaItem item,
      required int index,
      required String mediaType,
      required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (item.reference != null)
          SizedBox(
            width: double.infinity,
            child: child,
          ),
        if (item.title != null && item.title!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.multiMediaViewMediaTitle(
                    mediaType, getMediaTypeNumber(index), item.title!),
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          )
        ]
      ],
    );
  }

  Widget _buildAudioItem(MultiMediaItem item, int index) {
    AudioPlayer player = AudioPlayer();
    player.setSourceUrl(buildMediaUrl(item.reference!));

    return _buildSubtitledItem(
        item: item,
        index: index,
        mediaType: AppLocalizations.of(context)!.multiMediaTypeAudio,
        child: AudioPlayerWidget(player: player));
  }

  Widget _buildImageItem(MultiMediaItem item, int index) {
    return _buildSubtitledItem(
        mediaType: AppLocalizations.of(context)!.multiMediaTypeImage,
        item: item,
        index: index,
        child: Image.network(
          buildMediaUrl(item.reference!),
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => ErrorBox(
            errorText: AppLocalizations.of(context)!.multiMediaViewError(
                AppLocalizations.of(context)!.multiMediaTypeImage,
                item.reference ?? "",
                error.toString()),
          ),
        ));
  }

  Widget _buildVideoItem(MultiMediaItem item, int index) {
    return _buildSubtitledItem(
        mediaType: AppLocalizations.of(context)!.multiMediaTypeVideo,
        item: item,
        index: index,
        child: VideoPlayer(videoUrl: buildMediaUrl(item.reference!)));
  }

  Future<String?> _readTextFile(String path) async {
    final response = await http.get(Uri.parse(buildMediaUrl(path)));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception(AppLocalizations.of(context)!.multiMediaViewError(
          AppLocalizations.of(context)!.multiMediaTypeText,
          path,
          response.statusCode.toString()));
    }
  }

  Widget _buildTextItem(MultiMediaItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (item.title != null)
          Text(
            item.title!,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        if (item.reference != null)
          ApiFutureBuilder(future: _readTextFile(item.reference!), builder: (context, text) {
            return Text(text,
                style: Theme.of(context).textTheme.bodyMedium);

          },),
        if (item.text != null)
          Text(
            item.text!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
      ],
    );
  }
}
