import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:freecodecamp/ui/views/podcast/episode/episode_viewmodel.dart';
import 'package:stacked/stacked.dart';

class EpisodeView extends StatelessWidget {
  const EpisodeView({
    super.key,
    required this.episode,
    required this.podcast,
  });

  final Episodes episode;
  final Podcasts podcast;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EpisodeViewModel>.reactive(
      viewModelBuilder: () => EpisodeViewModel(),
      onViewModelReady: (model) {
        model.loadEpisode(episode, podcast);
        model.hasDownloadedEpisode(episode);
        model.initProgressListener(episode);
        model.initDownloadListener();
        model.initPlaybackListener();
        model.initPlayBackSpeed();
      },
      onDispose: (model) {
        model.disposeProgressListener();
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(),
        body: ListView(
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 10,
                        spreadRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  height: MediaQuery.of(context).size.height * 0.40,
                  width: MediaQuery.of(context).size.height * 0.40,
                  child: CachedNetworkImage(imageUrl: podcast.image!),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    episode.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Text(
                  podcast.title!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                Slider(
                  onChangeStart: (_) {
                    model.audioService.pause();
                  },
                  onChanged: (value) {
                    model.setSliderValue = value;
                    model.handleTimeVortex(
                      episode.duration!.inSeconds,
                      (episode.duration!.inSeconds * value).toInt(),
                    );
                  },
                  onChangeEnd: (value) {
                    model.setAudioProgress(value, episode);
                    model.audioService.play();
                  },
                  value: model.sliderValue,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        model.timeElapsed,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        '-${model.timeLeft}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: model.playBackSpeed,
                        dropdownColor: const Color(0xFF0a0a23),
                        icon: const SizedBox.shrink(),
                        items: model.speedOptions
                            .map(
                              (speed) => DropdownMenuItem(
                                onTap: () => model.handlePlayBackSpeed(speed),
                                value: speed,
                                child: Text(
                                  '${speed}x',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (_) {},
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      iconSize: 45,
                      icon: const Icon(Icons.replay_10_rounded),
                      onPressed: () {
                        model.rewind(episode);
                      },
                    ),
                    IconButton(
                      iconSize: 80,
                      onPressed: () {
                        model.playOrPause(episode);
                      },
                      icon: model.isPlaying
                          ? const Icon(Icons.pause)
                          : const Icon(Icons.play_arrow_rounded),
                    ),
                    IconButton(
                      iconSize: 45,
                      icon: const Icon(
                        Icons.forward_30_rounded,
                      ),
                      onPressed: () {
                        model.forward(episode);
                      },
                    ),
                    IconButton(
                      iconSize: 30,
                      onPressed: model.isDownloading
                          ? null
                          : () {
                              if (!model.isDownloaded) {
                                model.setIsDownloading = true;
                              }

                              model.downloadService.setDownloadId = episode.id;
                              model.downloadBtnClick(episode, podcast);
                            },
                      icon: model.isDownloading &&
                              model.downloadService.downloadId == episode.id
                          ? StreamBuilder<String>(
                              stream: model.downloadService.progress,
                              builder: (context, snapshot) {
                                double? val = double.tryParse(
                                  snapshot.data ?? '0',
                                );

                                if (snapshot.hasData) {
                                  return Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Text(
                                        '${snapshot.data}%',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                        value: snapshot.hasData && val != null
                                            ? val / 100
                                            : 0,
                                      )
                                    ],
                                  );
                                }

                                return const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                  value: 0,
                                );
                              })
                          : Icon(
                              model.isDownloaded
                                  ? Icons.download_done
                                  : Icons.arrow_circle_down_outlined,
                            ),
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                  child: description(model, context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget description(EpisodeViewModel model, BuildContext context) {
    HTMLParser parser = HTMLParser(context: context);
    return Column(
      children: parser.parse('<p>${episode.description}</p>'),
    );
  }
}
