import 'dart:io';

import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/service/download_service.dart';
import 'package:freecodecamp/service/episode_audio_service.dart';
import 'package:freecodecamp/service/podcasts_service.dart';
import 'package:freecodecamp/ui/views/podcast/episode-view/episode_view.dart';
import 'package:freecodecamp/ui/widgets/podcast_widgets/podcast_progressbar_widget.dart';
import 'package:intl/intl.dart';
import 'package:html/dom.dart' as dom;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';

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

  final _audioService = locator<EpisodeAudioService>();
  final _databaseService = locator<PodcastsDatabaseService>();
  final _downloadService = locator<DownloadService>();

  final Dio dio = Dio();

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
    setState(() {
      widget._isDownloading = state;
    });
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
    Directory appDir = await getApplicationSupportDirectory();

    File podcastImgFile;
    http.Response res;

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

    widget._audioService.isPlayingEpisodeStream.listen((event) {
      if (widget._audioService.episodeId == widget.episode.id && mounted) {
        setIsPlaying = event;
      } else {
        setIsPlaying = false;
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
        res = await http.get(Uri.parse(widget.podcast.image!));
        podcastImgFile.writeAsBytesSync(res.bodyBytes);
      }
    }
  }

  Future<void> playBtnClick() async {
    if (!widget.loading) {
      if (!widget.playing) {
        widget._audioService.setEpisodeId = widget.episode.id;
        setIsLoading = true;
        await widget._audioService.playAudio(widget.episode, widget.downloaded);
      } else {
        widget._audioService.setEpisodeId = '';
        await widget._audioService.pauseAudio();
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
      File audioFile = File(appDir.path +
          '/episodes/' +
          widget.podcast.id +
          '/' +
          widget.episode.id +
          '.mp3');
      if (audioFile.existsSync()) {
        audioFile.deleteSync();
      }
      setIsDownloaded = !widget.downloaded;
      removeEpisode();
    }
  }

  String _parseDuration(Duration dur) {
    if (dur.inMinutes > 59) {
      return '${widget.episode.duration!.inMinutes ~/ 60} hr ${widget.episode.duration!.inMinutes % 60} min';
    } else {
      return '${widget.episode.duration!.inMinutes % 60} min';
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
        contentPadding: widget.isFromEpisodeView
            ? const EdgeInsets.fromLTRB(8, 0, 8, 16)
            : null,
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
                  ),
                );
              }
            : null,
        minVerticalPadding: 16,
        isThreeLine: true,
        subtitle: subtitle(context));
  }

  Column subtitle(BuildContext context) {
    return Column(
      children: [
        !widget.isFromEpisodeView ? descriptionWidget() : Container(),
        widget.isFromEpisodeView
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [playbuttonWidget(context), downloadbuttonWidget()],
              )
            : Container(),
        !widget.isFromEpisodeView ? footerWidget(context) : Container(),
      ],
    );
  }

  Row footerWidget(BuildContext context) {
    return Row(
      children: [
        playbuttonWidget(context),
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
                        ? (' • ' + _parseDuration(widget.episode.duration!))
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Html(
        data: widget.podcast.description!,
        onLinkTap: (
          String? url,
          RenderContext context,
          Map<String, String> attributes,
          dom.Element? element,
        ) {
          launchUrlString(url!);
        },
        style: {
          '#': Style(
              fontSize: const FontSize(16),
              color: Colors.white.withOpacity(0.87),
              margin: EdgeInsets.zero,
              maxLines: 3,
              fontFamily: 'Lato')
        },
      ),
    );
  }
}
