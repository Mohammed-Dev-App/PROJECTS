import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerWidget extends StatefulWidget {
  final String videoId;
  final Function(YoutubePlayerWidgetState) onPlayerStateCreated;
  final Function(bool) onFullScreenChange;
  const YoutubePlayerWidget({
    super.key,
    required this.videoId,
    required this.onPlayerStateCreated,
    required this.onFullScreenChange,
  });

  @override
  State<YoutubePlayerWidget> createState() => YoutubePlayerWidgetState();
}

class YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  late YoutubePlayerController _controller;
  bool isFullScreen = false;

  @override
  void initState() {
    initializeControler();

    super.initState();
    widget.onPlayerStateCreated(this);
  }

  void pause() {
    _controller.pause();
  }

  void seekTo(Duration position) {
    _controller.seekTo(position);
  }

  Duration getCurrentPosition() {
    return _controller.value.position;
  }

  void initializeControler() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
        captionLanguage: 'ar',
        controlsVisibleAtStart: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onEnterFullScreen: () {
        setState(() {
          isFullScreen = true;
        });
        widget.onFullScreenChange(true);
      },
      onExitFullScreen: () {
        setState(() {
          isFullScreen = false;
        });
        widget.onFullScreenChange(false);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressColors: ProgressBarColors(
          playedColor: Colors.red,
          handleColor: Colors.redAccent,
          backgroundColor: Colors.black,
          bufferedColor: Colors.grey,
        ),
        onReady: () {
          final currentPoisition = _controller.value.position;
          _controller.seekTo(currentPoisition);
        },
      ),
      builder: (context, player) {
        return isFullScreen
            ? player
            : AspectRatio(aspectRatio: 16 / 9, child: player);
      },
    );
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }
}
