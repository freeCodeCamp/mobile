import 'dart:io';

import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/service/episode_audio_service.dart';
import 'package:freecodecamp/service/notification_service.dart';
import 'package:freecodecamp/service/podcasts_service.dart';
import 'package:freecodecamp/ui/views/podcast/episode-view/episode_view.dart';
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
  final _notificationService = locator<NotificationService>();

  final Dio dio = Dio();

  Directory? appDir;

  final int _episodeLength = 0;
  int get episodeLength => _episodeLength;

  bool _downloaded = false;
  bool get downloaded => _downloaded;

  bool _playing = false;
  bool get playing => _playing;

  bool _loading = false;
  bool get loading => _loading;

  bool _downloading = false;
  bool get downloading => _downloading;

  String _progress = '0';
  String get progress => _progress;

  @override
  State<StatefulWidget> createState() => PodcastTileState();
}

class PodcastTileState extends State<PodcastTile> {
  set setIsPlaying(bool state) {
    setState(() => {widget._playing = state});
  }

  set setIsDownloaded(bool state) {
    setState(() {
      widget._downloaded = state;
    });
  }

  set setIsDownloading(bool state) {
    setState(() {
      widget._downloading = state;
    });
  }

  set setAppDir(Directory dir) {
    setState(() {
      widget.appDir = dir;
    });
  }

  set setProgress(String state) {
    setState(() {
      widget._progress = state;
    });
  }

  set setIsLoading(bool state) {
    setState(() {
      widget._loading = state;
    });
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 0), () async => {init()});
  }

  Future<void> init() async {
    File podcastImgFile;
    http.Response res;

    await widget._databaseService.initialise();
    await FkUserAgent.init();
    setIsPlaying = widget._audioService.isPlaying(widget.episode.id);
    setIsDownloaded =
        await widget._databaseService.episodeExists(widget.episode);
    setAppDir = await getApplicationDocumentsDirectory();
    if (!widget.isFromDownloadView) {
      podcastImgFile = File(
          '${widget.appDir?.path}/images/podcast/${widget.episode.podcastId}.jpg');
      if (!podcastImgFile.existsSync()) {
        podcastImgFile.createSync(recursive: true);
        res = await http.get(Uri.parse(widget.podcast.image!));
        podcastImgFile.writeAsBytesSync(res.bodyBytes);
      }
    }
  }

  void downloadAudio(String uri) async {
    setIsDownloading = true;

    String path = widget.appDir!.path +
        '/episodes/' +
        widget.podcast.id +
        '/' +
        widget.episode.id +
        '.mp3';

    await widget.dio.download(uri, path,
        onReceiveProgress: (int recevied, int total) {
      setProgress = ((recevied / total) * 100).toStringAsFixed(0);
    }, options: Options(headers: {'User-Agent': FkUserAgent.userAgent}));
    setIsDownloading = false;
    await widget._notificationService.showNotification(
      'Download Complete',
      widget.episode.title,
    );
    await widget._databaseService.addPodcast(widget.podcast);
    await widget._databaseService.addEpisode(widget.episode);
  }

  Future<void> playBtnClick() async {
    if (!widget.loading) {
      if (!widget.playing) {
        setIsLoading = true;
        await widget._audioService.playAudio(widget.episode, widget.downloaded);
        setIsPlaying = true;
      } else {
        await widget._audioService.pauseAudio();
        setIsPlaying = false;
      }
      setIsLoading = false;
    }
  }

  void removeEpisode() async {
    await widget._databaseService.removeEpisode(widget.episode);
    await widget._databaseService.removePodcast(widget.podcast);
  }

  void downloadBtnClick() {
    if (!widget.downloaded && !widget.downloading) {
      downloadAudio(widget.episode.contentUrl!);
      setIsDownloaded = !widget.downloaded;
    } else if (widget.downloaded) {
      File audioFile = File(widget.appDir!.path +
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
      setProgress = '0';
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
        onTap: () {
          !widget.isFromEpisodeView
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EpisodeView(
                      episode: widget.episode,
                      podcast: widget.podcast,
                    ),
                  ),
                )
              : playBtnClick();
        },
        minVerticalPadding: 16,
        isThreeLine: true,
        subtitle: subtitle(context));
  }

  Column subtitle(BuildContext context) {
    return Column(
      children: [
        widget.isFromEpisodeView ? footerWidget(context) : Container(),
        !widget.isFromEpisodeView ? descriptionWidget() : Container(),
        widget.isFromEpisodeView
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
        !widget.isFromEpisodeView ? playbuttonWidget(context) : Container(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            !widget.downloading
                ? DateFormat.yMMMd().format(widget.episode.publicationDate!) +
                    (widget.episode.duration != null &&
                            widget.episode.duration != Duration.zero
                        ? (' • ' + _parseDuration(widget.episode.duration!))
                        : '')
                : 'Downloading: ${widget.progress}%',
            textAlign: !widget.isFromEpisodeView ? null : TextAlign.center,
            style: const TextStyle(fontSize: 16, height: 2, fontFamily: 'Lato'),
          ),
        ),
        !widget.isFromEpisodeView
            ? Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: downloadbuttonWidget(),
                ),
              )
            : Container(),
      ],
    );
  }

  IconButton downloadbuttonWidget() {
    return IconButton(
        onPressed: widget.downloading ? () {} : downloadBtnClick,
        padding: const EdgeInsets.fromLTRB(64, 16, 0, 4),
        icon: widget.downloading
            ? CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
                value: double.parse(widget.progress) / 100,
              )
            : Icon(
                widget.downloaded
                    ? Icons.download_done
                    : Icons.arrow_circle_down_outlined,
                size: !widget.isFromEpisodeView
                    ? MediaQuery.of(context).size.height * 0.0375
                    : MediaQuery.of(context).size.height * 0.075,
              ));
  }

  IconButton playbuttonWidget(BuildContext context) {
    return IconButton(
        onPressed: () {
          playBtnClick();
        },
        icon: Icon(
          widget.playing ? Icons.pause_circle : Icons.play_circle_sharp,
          size: !widget.isFromEpisodeView
              ? MediaQuery.of(context).size.height * 0.05
              : MediaQuery.of(context).size.height * 0.075,
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
