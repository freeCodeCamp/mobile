import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:dio/dio.dart';
import 'package:fk_user_agent/fk_user_agent.dart';
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
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class PodcastTile extends StatefulWidget {
  PodcastTile(
      {Key? key,
      required this.podcast,
      required this.episode,
      required this.isFromDownloadView,
      this.isFromEpisodeView = false})
      : super(key: key);

  final Podcasts podcast;
  final Episodes episode;

  final bool isFromDownloadView;
  final bool isFromEpisodeView;

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

  @override
  void dispose() {
    super.dispose();
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

    AudioService.position.listen((event) async {
      if (widget._playing &&
          widget._audioService.episodeId == widget.episode.id) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('${widget.episode.id}_progress', event.inSeconds);
      }
    });

    if (widget._audioService.episodeId == widget.episode.id && mounted) {
      setIsPlaying = true;
    }

    await widget._databaseService.initialise();
    await FkUserAgent.init();

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int progress = prefs.getInt('${widget.episode.id}_progress') ?? 0;
    if (!widget.loading) {
      if (!widget.playing) {
        widget._audioService.setEpisodeId = widget.episode.id;
        setIsLoading = true;

        if (progress > 0) {
          await widget._audioService
              .loadEpisode(widget.episode, widget.downloaded, widget.podcast);

          widget._audioService.seek(Duration(seconds: progress));
        } else {
          await widget._audioService
              .loadEpisode(widget.episode, widget.downloaded, widget.podcast);
        }

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
    return !widget.isFromEpisodeView
        ? widget.playing
            ? Card(
                margin: const EdgeInsets.all(8),
                elevation: 10,
                shadowColor: Colors.black,
                color: const Color.fromRGBO(0x1b, 0x1b, 0x32, 1),
                child: podcastTile(context))
            : podcastTile(context)
        : podcastTile(context);
  }

  ListTile podcastTile(BuildContext context) {
    return ListTile(
        title: !widget.isFromEpisodeView
            ? Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.episode.title,
                        style: const TextStyle(
                            fontFamily: 'Lato', fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              )
            : Container(),
        onTap: !widget.isFromEpisodeView
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EpisodeView(
                      episode: widget.episode,
                      podcast: widget.podcast,
                    ),
                    settings: RouteSettings(
                        name: '/podcasts-episode/${widget.episode.title}'),
                  ),
                );
              }
            : null,
        minVerticalPadding: !widget.isFromEpisodeView ? 16 : 0,
        isThreeLine: true,
        subtitle: subtitle(context));
  }

  Widget subtitle(BuildContext context) {
    return Column(
      children: [
        if (!widget.isFromEpisodeView) descriptionWidget(),
        if (widget.isFromEpisodeView)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              widget._audioService.playbackState.value.processingState ==
                          AudioProcessingState.loading ||
                      widget._audioService.playbackState.value
                              .processingState ==
                          AudioProcessingState.buffering
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.075,
                          width: MediaQuery.of(context).size.height * 0.075,
                          child: const CircularProgressIndicator()),
                    )
                  : playbuttonWidget(context),
              downloadbuttonWidget()
            ],
          )
        else
          footerWidget(context)
      ],
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
                          fontSize: 16, height: 2, fontFamily: 'Lato'),
                    );
                  }

                  return const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                    value: 0,
                  );
                })
            : Text(
                DateFormat.yMMMd().format(widget.episode.publicationDate!) +
                    (widget.episode.duration != null &&
                            widget.episode.duration != Duration.zero
                        ? (' • ${_parseDuration(
                            widget.episode.duration!,
                            context,
                          )}')
                        : ''),
                style: const TextStyle(
                    fontSize: 16, height: 2, fontFamily: 'Lato'),
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
        iconSize: !widget.isFromEpisodeView
            ? MediaQuery.of(context).size.height * 0.0375
            : MediaQuery.of(context).size.height * 0.075,
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
              ));
  }

  IconButton playbuttonWidget(BuildContext context) {
    return IconButton(
        onPressed: () {
          playBtnClick();
        },
        iconSize: !widget.isFromEpisodeView
            ? MediaQuery.of(context).size.height * 0.05
            : MediaQuery.of(context).size.height * 0.075,
        icon: Icon(
          widget.playing ? Icons.pause_circle : Icons.play_circle_sharp,
        ));
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
          color: Colors.white.withOpacity(0.87),
          fontFamily: 'Lato',
        ),
      ),
    );
  }
}
