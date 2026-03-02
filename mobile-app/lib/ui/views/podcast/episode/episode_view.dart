import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:freecodecamp/ui/views/podcast/episode/episode_viewmodel.dart';

class EpisodeView extends ConsumerStatefulWidget {
  const EpisodeView({
    super.key,
    required this.episode,
    required this.podcast,
  });

  final Episodes episode;
  final Podcasts podcast;

  @override
  ConsumerState<EpisodeView> createState() => _EpisodeViewState();
}

class _EpisodeViewState extends ConsumerState<EpisodeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(episodeProvider.notifier);
      if (!notifier.appAudioService.audioHandler.isPlaying(
        'podcast',
        episodeId: notifier.appAudioService.audioHandler.episodeId,
      )) {
        notifier.loadEpisode(widget.episode, widget.podcast);
      }
      notifier.hasDownloadedEpisode(widget.episode);
      notifier.initProgressListener(widget.episode);
      notifier.initDownloadListener(widget.episode);
      notifier.initPlaybackListener();
      notifier.initPlayBackSpeed();
    });
  }

  @override
  void dispose() {
    ref.read(episodeProvider.notifier).disposeProgressListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(episodeProvider);
    final notifier = ref.read(episodeProvider.notifier);

    return Scaffold(
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
                child: CachedNetworkImage(imageUrl: widget.podcast.image!),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  widget.episode.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Text(
                widget.podcast.title!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              Slider(
                onChangeStart: (_) {
                  notifier.appAudioService.audioHandler.pause();
                },
                onChanged: (value) {
                  notifier.setSliderValue(value);
                  notifier.handleTimeVortex(
                    widget.episode.duration!.inSeconds,
                    (widget.episode.duration!.inSeconds * value).toInt(),
                  );
                },
                onChangeEnd: (value) {
                  notifier.setAudioProgress(value, widget.episode);
                  notifier.appAudioService.audioHandler.play();
                },
                value: state.sliderValue,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state.timeElapsed,
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      '-${state.timeLeft}',
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
                      value: state.playBackSpeed,
                      dropdownColor: const Color(0xFF0a0a23),
                      icon: const SizedBox.shrink(),
                      items: notifier.speedOptions
                          .map(
                            (speed) => DropdownMenuItem(
                              onTap: () => notifier.handlePlayBackSpeed(speed),
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
                      notifier.rewind(widget.episode);
                    },
                  ),
                  IconButton(
                    iconSize: 80,
                    onPressed: () {
                      notifier.playOrPause(widget.episode, widget.podcast);
                    },
                    icon: state.isPlaying &&
                            notifier.appAudioService.audioHandler.episodeId ==
                                widget.episode.id
                        ? const Icon(Icons.pause)
                        : const Icon(Icons.play_arrow_rounded),
                  ),
                  IconButton(
                    iconSize: 45,
                    icon: const Icon(
                      Icons.forward_30_rounded,
                    ),
                    onPressed: () {
                      notifier.forward(widget.episode);
                    },
                  ),
                  IconButton(
                    iconSize: 30,
                    onPressed: state.isDownloading
                        ? null
                        : () {
                            if (!state.isDownloaded) {
                              notifier.setIsDownloading(true);
                            }

                            notifier.downloadService.setDownloadId =
                                widget.episode.id;
                            notifier.downloadBtnClick(
                                widget.episode, widget.podcast);
                          },
                    icon: (() {
                      if (state.isDownloaded) {
                        return const Icon(
                          Icons.download_done,
                          color: Colors.white,
                          size: 30,
                          semanticLabel: 'Download complete',
                        );
                      } else if (state.isDownloading &&
                          notifier.downloadService.downloadId ==
                              widget.episode.id) {
                        return StreamBuilder<String>(
                          stream: notifier.downloadService.progress,
                          builder: (context, snapshot) {
                            final progress = snapshot.data;
                            double? val = double.tryParse(progress ?? '0');
                            if (progress == '100') {
                              return const Icon(
                                Icons.download_done,
                                color: Colors.white,
                                size: 30,
                                semanticLabel: 'Download complete',
                              );
                            } else if (progress != null && progress != '') {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  Text(
                                    '$progress%',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                    value: val != null ? val / 100 : 0,
                                  )
                                ],
                              );
                            } else {
                              return const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                                value: 0,
                              );
                            }
                          },
                        );
                      } else {
                        return const Icon(
                          Icons.arrow_circle_down_outlined,
                          color: Colors.white,
                          size: 30,
                          semanticLabel: 'Download episode',
                        );
                      }
                    })(),
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                child: description(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget description(BuildContext context) {
    HTMLParser parser = HTMLParser(context: context);
    return Column(
      children: parser.parse('<p>${widget.episode.description}</p>'),
    );
  }
}
