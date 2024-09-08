import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:manvsim/widgets/error_box.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:video_player/video_player.dart' as flutter_video_player;

class VideoPlayer extends StatefulWidget {
  final String videoUrl;

  const VideoPlayer({super.key, required this.videoUrl});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late flutter_video_player.VideoPlayerController _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _initVideoPlayer() async {
    Uri url = Uri.parse(widget.videoUrl);
    _controller = flutter_video_player.VideoPlayerController.networkUrl(url);
    await _controller.initialize();
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      // Future Builder causes issues with the video player here
      return const Center(child: CircularProgressIndicator());
    } else {
      return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: Chewie(
            controller: ChewieController(
          errorBuilder: (context, errorMessage) {
            return ErrorBox(
                errorText: AppLocalizations.of(context)!.multiMediaViewError(
                    AppLocalizations.of(context)!.multiMediaTypeVideo,
                    widget.videoUrl,
                    errorMessage));
          },
          videoPlayerController: _controller,
          autoPlay: false,
          looping: false,
          autoInitialize: true,
          showControls: true,
          showOptions: false,
          allowFullScreen: false,
        )),
      );
    }
  }
}
