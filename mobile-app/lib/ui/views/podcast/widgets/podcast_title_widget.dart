import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/service/audio/audio_service.dart';
import 'package:freecodecamp/service/dio_service.dart';
import 'package:freecodecamp/service/podcast/download_service.dart';
import 'package:freecodecamp/service/podcast/podcasts_service.dart';
import 'package:freecodecamp/ui/theme/fcc_theme.dart';
import 'package:freecodecamp/ui/views/podcast/episode/episode_view.dart';
import 'package:html/parser.dart' as html_parser;
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

    widget._downloadService.progress.listen((event) async {
      if (widget._downloadService.downloadId == widget.episode.id && mounted) {
        if (event != '') {
          setIsDownloading = true;
        }
        if (event == '100') {
          // Download complete, update state and DB
          if (!widget.downloaded) {
            setIsDownloaded = true;
            await widget._databaseService.addEpisode(widget.episode);
          }
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

  String getFirstSentenceFromHtml(String? html) {
    if (html == null || html.isEmpty) return '';
    final document = html_parser.parse(html);
    final text = document.body?.text ?? '';
    final match = RegExp(r'([^.?!]*[.?!])').firstMatch(text);
    return match != null ? match.group(0)!.trim() : text.trim();
  }

  Widget _buildEpisodeTitle() {
    return Text(
      widget.episode.title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: FccColors.gray00,
      ),
    );
  }

  Widget _buildEpisodeDescription() {
    final firstSentence = getFirstSentenceFromHtml(widget.episode.description);
    if (firstSentence.isEmpty) return const SizedBox(height: 14);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        Text(
          firstSentence,
          style: const TextStyle(
            color: FccColors.gray10,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _buildEpisodeDate() {
    final date = widget.episode.publicationDate;
    return Text(
      date != null ? Jiffy.parseFromDateTime(date).fromNow().toUpperCase() : '',
      style: const TextStyle(
        fontSize: 12,
        color: FccColors.gray10,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _buildPlayButton(bool isPlaying) {
    return Container(
      decoration: BoxDecoration(
        color: isPlaying ? FccColors.purple90 : FccColors.gray80,
        borderRadius: BorderRadius.circular(24),
      ),
      child: IconButton(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        icon: _isEpisodeLoading()
            ? const Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    color: FccColors.gray00,
                    strokeWidth: 2.5,
                  ),
                ),
              )
            : Icon(
                widget.playing ? Icons.pause : Icons.play_arrow,
                color: FccColors.gray00,
                semanticLabel:
                    widget.playing ? 'Pause episode' : 'Play episode',
              ),
        onPressed: () {
          playBtnClick();
        },
        iconSize: 28,
      ),
    );
  }

  Widget _buildDownloadButton() {
    final isCurrentDownload = widget.isDownloading &&
        widget._downloadService.downloadId == widget.episode.id;
    return SizedBox(
      width: 48,
      height: 48,
      child: IconButton(
        onPressed: isCurrentDownload
            ? null
            : () {
                widget._downloadService.setDownloadId = widget.episode.id;
                downloadBtnClick();
              },
        iconSize: 28,
        padding: EdgeInsets.zero,
        icon: isCurrentDownload
            ? StreamBuilder<String>(
                stream: widget._downloadService.progress,
                builder: (context, snapshot) {
                  final progress = snapshot.data;
                  if (progress == '100') {
                    return const Icon(
                      Icons.download_done,
                      color: FccColors.gray10,
                      size: 28,
                      semanticLabel: 'Download complete',
                    );
                  } else if (progress != null && progress != '') {
                    return Stack(alignment: Alignment.center, children: [
                      Text(
                        '$progress%',
                        style: const TextStyle(fontSize: 16),
                      ),
                      CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                          value: double.tryParse(progress) != null
                              ? double.parse(progress) / 100
                              : 0),
                    ]);
                  } else {
                    return const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                      value: 0,
                    );
                  }
                })
            : widget.downloaded
                ? const Icon(
                    Icons.download_done,
                    color: FccColors.gray10,
                    size: 28,
                    semanticLabel: 'Download complete',
                  )
                : const Icon(
                    Icons.arrow_circle_down_outlined,
                    color: FccColors.gray10,
                    semanticLabel: 'Download episode',
                  ),
      ),
    );
  }

  Widget _buildButtonRow(bool isPlaying) {
    return Row(
      children: [
        _buildPlayButton(isPlaying),
        const SizedBox(width: 12),
        _buildDownloadButton(),
      ],
    );
  }

  Widget _buildPodcastTile(BuildContext context, {bool isPlaying = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEpisodeDate(),
          const SizedBox(height: 6),
          _buildEpisodeTitle(),
          _buildEpisodeDescription(),
          _buildButtonRow(isPlaying),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isPlaying = widget.playing;
    return Container(
      color: FccColors.gray90,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EpisodeView(
                      podcast: widget.podcast,
                      episode: widget.episode,
                    ),
                  ),
                );
              },
              child: _buildPodcastTile(context, isPlaying: isPlaying),
            ),
          ),
          const Divider(
            color: FccColors.gray80,
            thickness: 1,
            height: 1,
            indent: 16,
            endIndent: 16,
          ),
        ],
      ),
    );
  }

  bool _isEpisodeLoading() {
    return (widget._audioService.playbackState.value.processingState ==
                AudioProcessingState.loading ||
            widget._audioService.playbackState.value.processingState ==
                AudioProcessingState.buffering) &&
        widget._audioService.episodeId == widget.episode.id;
  }
}
