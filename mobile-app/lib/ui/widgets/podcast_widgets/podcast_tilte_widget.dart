import 'dart:io';

import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/service/episode_audio_service.dart';
import 'package:freecodecamp/service/podcasts_service.dart';
import 'package:intl/intl.dart';
import 'package:freecodecamp/ui/views/podcast/episode/episode_view.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher_string.dart';

// ignore: must_be_immutable
class PodcastTile extends StatefulWidget {
  PodcastTile(
      {Key? key,
      required this.podcast,
      required this.episode,
      required this.isFromDownloadView,
      required this.appDir})
      : super(key: key);

  final Podcasts podcast;
  final Episodes episode;

  final bool isFromDownloadView;

  final _audioService = locator<EpisodeAudioService>();
  final _databaseService = locator<PodcastsDatabaseService>();

  late final Directory appDir;

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
  @override
  void initState() {
    super.initState();
    File podcastImgFile;
    Future.delayed(
        const Duration(seconds: 0),
        () async => {
              await widget._databaseService.initialise(),
              await FkUserAgent.init(),
              setIsPlaying = widget._audioService.isPlaying(widget.episode.id),
              setIsDownloaded =
                  await widget._databaseService.episodeExists(widget.episode),
                      if (!widget.isFromDownloadView) {
      File podcastImgFile =
          File('${widget.appDir.path}/images/podcast/${widget.episode.podcastId}.jpg'),
      if (!podcastImgFile.existsSync()) {
        podcastImgFile.createSync(recursive: true);
        var res = await http.get(Uri.parse(podcast.image!));
        podcastImgFile.writeAsBytesSync(res.bodyBytes);
      }
    }
            });
  }

  set setIsPlaying(bool state) {
    setState(() => {widget._playing = state});
  }

  set setIsDownloaded(bool state) {
    setState(() {
      widget._downloaded = state;
    });
  }

  set setAppDir(Directory dir) {
    setState(() {
      widget.appDir = dir;
    });
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
    return ListTile(
        title: Row(
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
        ),
        minVerticalPadding: 16,
        isThreeLine: true,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EpisodeView(
                  episode: widget.episode,
                  podcast: widget.podcast,
                  isDownloadView: false),
            ),
          );
        },
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
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
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                DateFormat.yMMMd().format(widget.episode.publicationDate!) +
                    (widget.episode.duration != null &&
                            widget.episode.duration != Duration.zero
                        ? (' • ' + _parseDuration(widget.episode.duration!))
                        : ''),
                style: const TextStyle(
                    fontSize: 16, height: 2, fontFamily: 'Lato'),
              ),
            ),
          ],
        ));
  }
}
