import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class ChallengeVideo extends StatefulWidget {
  const ChallengeVideo({super.key, required this.videoId});

  final String videoId;

  @override
  State<ChallengeVideo> createState() => _ChallengeVideoState();
}

class _ChallengeVideoState extends State<ChallengeVideo> {
  late final _controller = YoutubePlayerController.fromVideoId(
    videoId: widget.videoId,
    params: const YoutubePlayerParams(
      showFullscreenButton: true,
      strictRelatedVideos: true,
      origin: 'https://www.youtube-nocookie.com',
    ),
  );

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: YoutubePlayer(
        controller: _controller,
        enableFullScreenOnVerticalDrag: false,
      ),
    );
  }
}
