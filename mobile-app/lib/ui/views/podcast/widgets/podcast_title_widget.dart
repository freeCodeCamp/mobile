import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/service/audio/audio_service.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:freecodecamp/service/podcast/download_service.dart';
import 'package:freecodecamp/service/podcast/podcasts_service.dart';
import 'package:freecodecamp/ui/views/podcast/episode/episode_view.dart';
import 'package:html/parser.dart';
import 'package:jiffy/jiffy.dart';
import 'package:path_provider/path_provider.dart';

// ignore: must_be_immutable
class PodcastTile extends StatefulWidget {
  PodcastTile({
    super.key,
    required this.podcast,
    required this.episode,
    required this.isFromDownloadView,
  });

  final Podcasts podcast;
  final Episodes episode;

  final bool isFromDownloadView;

  final _audioService = locator<AppAudioService>().audioHandler;
  final _databaseService = locator<PodcastsDatabaseService>();
  final _downloadService = locator<DownloadService>();

  final dio = DioService.dio;

  final int _episodeLength = 0;
  int get episodeLength => _episodeLength;

  bool _downloaded = false;
  bool get downloaded => _downloaded;

  bool _playing = false;
  bool get playing => _playing;

  bool _loading = false;
  bool get loading => _loading;

  bool _isDownloading = false;
  bool get isDownloading => _isDownloading;

  @override
  State<StatefulWidget> createState() => PodcastTileState();
}

class PodcastTileState extends State<PodcastTile> {
  set setIsPlaying(bool state) {
    mounted
        ? setState(() {
            widget._playing = state;
          })
        : null;
  }

  set setIsDownloaded(bool state) {
    setState(() {
      widget._downloaded = state;
    });
  }

  set setIsLoading(bool state) {
    setState(() {
      widget._loading = state;
    });
  }

  set setIsDownloading(bool state) {
    mounted
        ? setState(() {
            widget._isDownloading = state;
          })
        : null;
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 0), () async => {init()});
  }

  Future<void> init() async {
    Directory appDir = await getApplicationDocumentsDirectory();

    File podcastImgFile;
    Response res;

    widget._downloadService.downloadingStream.listen((event) {
      setIsDownloading = event;
    });

    widget._downloadService.progress.listen((event) {
      if (widget._downloadService.downloadId == widget.episode.id && mounted) {
        if (event != '') {
          setIsDownloading = true;
        }
      }
    });

    widget._audioService.playbackState.listen((event) {
      if (widget._audioService.episodeId == widget.episode.id && mounted) {
        setIsPlaying = event.playing;
      } else {
        setIsPlaying = false;
      }
    });

    if (widget._audioService.episodeId == widget.episode.id && mounted) {
      setIsPlaying = true;
    }

    await widget._databaseService.initialise();

    setIsDownloaded =
        await widget._databaseService.episodeExists(widget.episode);

    if (!widget.isFromDownloadView) {
      podcastImgFile =
          File('${appDir.path}/images/podcast/${widget.episode.podcastId}.jpg');
      if (!podcastImgFile.existsSync()) {
        podcastImgFile.createSync(recursive: true);
        res = await widget.dio.get(
          widget.podcast.image!,
          options: Options(
            responseType: ResponseType.bytes,
          ),
        );
        podcastImgFile.writeAsBytesSync(res.data);
      }
    }
  }

  Future<void> playBtnClick() async {
    if (!widget.loading) {
      if (!widget.playing) {
        widget._audioService.setEpisodeId = widget.episode.id;
        setIsLoading = true;

        await widget._audioService.loadEpisode(
          widget.episode,
          widget.downloaded,
          widget.podcast,
        );

        await widget._audioService.play();
      } else {
        widget._audioService.setEpisodeId = '';
        await widget._audioService.pause();
      }
      setIsLoading = false;
    }
  }

  void removeEpisode() async {
    await widget._databaseService.removeEpisode(widget.episode);
    await widget._databaseService.removePodcast(widget.podcast);
  }

  void downloadBtnClick() async {
    Directory appDir = await getApplicationSupportDirectory();

    if (!widget.downloaded && !widget.isDownloading) {
      widget._downloadService.download(widget.episode, widget.podcast);
    } else if (widget.downloaded) {
      File audioFile = File(
          '${appDir.path}/episodes/${widget.podcast.id}/${widget.episode.id}.mp3');
      if (audioFile.existsSync()) {
        audioFile.deleteSync();
      }
      setIsDownloaded = !widget.downloaded;
      removeEpisode();
    }
  }

  String _parseDuration(Duration dur, BuildContext context) {
    String hours = (widget.episode.duration!.inMinutes ~/ 60).toString();
    String minutes = (widget.episode.duration!.inMinutes % 60).toString();

    if (dur.inMinutes > 59) {
      return context.t.podcast_duration_hours(
        hours,
        minutes,
      );
    } else {
      return context.t.podcast_duration_minutes(
        minutes,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.playing
        ? Card(
            margin: const EdgeInsets.all(8),
            elevation: 10,
            shadowColor: Colors.black,
            color: const Color.fromRGBO(0x1b, 0x1b, 0x32, 1),
            child: podcastTile(context),
          )
        : podcastTile(context);
  }

  ListTile podcastTile(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.episode.title,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EpisodeView(
              episode: widget.episode,
              podcast: widget.podcast,
            ),
            settings: RouteSettings(
              name: '/podcasts-episode/${widget.episode.title}',
            ),
          ),
        );
      },
      minVerticalPadding: 16,
      isThreeLine: true,
      subtitle: Column(
        children: [
          descriptionWidget(),
          footerWidget(context),
        ],
      ),
    );
  }

  Row footerWidget(BuildContext context) {
    return Row(
      children: [
        (widget._audioService.playbackState.value.processingState ==
                        AudioProcessingState.loading ||
                    widget._audioService.playbackState.value.processingState ==
                        AudioProcessingState.buffering) &&
                widget._audioService.episodeId == widget.episode.id
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.0375,
                    width: MediaQuery.of(context).size.height * 0.0375,
                    child: const CircularProgressIndicator()),
              )
            : playbuttonWidget(context),
        widget.isDownloading &&
                widget._downloadService.downloadId == widget.episode.id
            ? StreamBuilder<String>(
                stream: widget._downloadService.progress,
                builder: (context, snapshot) {
                  if (snapshot.data == '100') {
                    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                      setIsDownloaded = true;
                    });
                  }

                  if (snapshot.hasData) {
                    return Text(
                      'Downloaded ${snapshot.data}%',
                      style: const TextStyle(
                        fontSize: 16,
                        height: 2,
                      ),
                    );
                  }

                  return const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                    value: 0,
                  );
                })
            : Text(
                Jiffy.parseFromDateTime(widget.episode.publicationDate!).yMMMd +
                    (widget.episode.duration != null &&
                            widget.episode.duration != Duration.zero
                        ? (' • ${_parseDuration(
                            widget.episode.duration!,
                            context,
                          )}')
                        : ''),
                style: const TextStyle(
                  fontSize: 16,
                  height: 2,
                ),
              ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            child: downloadbuttonWidget(),
          ),
        )
      ],
    );
  }

  Widget downloadbuttonWidget() {
    return IconButton(
      onPressed: widget.isDownloading
          ? null
          : () {
              widget._downloadService.setDownloadId = widget.episode.id;
              downloadBtnClick();
            },
      iconSize: MediaQuery.of(context).size.height * 0.0375,
      icon: widget.isDownloading &&
              widget._downloadService.downloadId == widget.episode.id
          ? StreamBuilder<String>(
              stream: widget._downloadService.progress,
              builder: (context, snapshot) {
                if (snapshot.data == '100') {
                  SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                    setIsDownloaded = true;
                  });
                }

                if (snapshot.hasData) {
                  return Stack(alignment: Alignment.center, children: [
                    Text(
                      '${snapshot.data}%',
                      style: const TextStyle(fontSize: 16),
                    ),
                    CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                        value: double.parse(snapshot.data as String) / 100),
                  ]);
                }

                return const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                  value: 0,
                );
              })
          : Icon(
              widget.downloaded
                  ? Icons.download_done
                  : Icons.arrow_circle_down_outlined,
            ),
    );
  }

  IconButton playbuttonWidget(BuildContext context) {
    return IconButton(
      onPressed: () {
        playBtnClick();
      },
      iconSize: MediaQuery.of(context).size.height * 0.05,
      icon: Icon(
        widget.playing ? Icons.pause : Icons.play_arrow,
      ),
    );
  }

  Padding descriptionWidget() {
    final textContent = parse(widget.episode.description!).body?.text ?? '';
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        textContent,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 16,
          color: Colors.white.withValues(alpha: 0.87),
        ),
      ),
    );
  }
}
