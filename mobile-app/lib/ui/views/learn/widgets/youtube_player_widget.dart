import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubePlayerWidget extends StatelessWidget {
  final String videoId;
  const YoutubePlayerWidget({super.key, required this.videoId});

  @override
  Widget build(BuildContext context) {
    final controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        strictRelatedVideos: true,
        origin: 'https://www.youtube-nocookie.com',
      ),
    );

    controller.setFullScreenListener(
      (_) async {
        final videoData = await controller.videoData;
        final startSeconds = await controller.currentTime;
        final currentTime = await FullscreenYoutubePlayer.launch(
          context,
          videoId: videoData.videoId,
          startSeconds: startSeconds,
        );
        if (currentTime != null) {
          controller.seekTo(seconds: currentTime);
        }
      },
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: YoutubePlayer(
        controller: controller,
        enableFullScreenOnVerticalDrag: false,
      ),
    );
  }
}
