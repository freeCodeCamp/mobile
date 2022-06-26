import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/ui/views/podcast/episode/episode_viewmodel.dart';
import 'package:freecodecamp/ui/views/podcast/podcast-list/podcast_list_viewmodel.dart';
import 'package:html/dom.dart' as dom;
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher_string.dart';

class EpisodeView extends StatelessWidget {
  const EpisodeView({
    Key? key,
    required this.episode,
    required this.podcast,
    required this.isDownloadView,
  }) : super(key: key);

  final Episodes episode;
  final Podcasts podcast;
  final bool isDownloadView;

  final TextStyle _titleStyle = const TextStyle(fontSize: 20);

  final TextStyle _subTitleStyle = const TextStyle(fontSize: 14);

  String _parseDuration(Duration dur) {
    if (dur.inMinutes > 59) {
      return '${episode.duration!.inMinutes ~/ 60} hr ${episode.duration!.inMinutes % 60} min';
    } else {
      return '${episode.duration!.inMinutes % 60} min';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EpisodeViewModel>.reactive(
      viewModelBuilder: () => EpisodeViewModel(episode, podcast),
      onModelReady: (model) => model.init(episode, isDownloadView),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(),
        body: Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                isDownloadView
                    ? Image.file(
                        File(
                          '${PodcastListViewModel.appDir.path}/images/podcast/${podcast.id}.jpg',
                        ),
                        height: 250,
                      )
                    : Image.network(
                        podcast.image!,
                        height: 250,
                      ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  episode.title,
                  style: _titleStyle,
                ),
                const SizedBox(
                  height: 7.5,
                ),
                Text(
                  DateFormat.yMMMd().format(episode.publicationDate!) +
                      (episode.duration != null &&
                              episode.duration! != Duration.zero
                          ? (' • ' + _parseDuration(episode.duration!))
                          : ''),
                  style: _subTitleStyle,
                ),
                const SizedBox(
                  height: 7.5,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: TextButton.icon(
                    onPressed: () async {
                      await model.playBtnClick();
                    },
                    icon: model.loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(
                            model.playing ? Icons.pause : Icons.play_arrow,
                          ),
                    label: Text(
                      model.loading
                          ? 'Loading...'
                          : model.playing
                              ? 'Pause'
                              : 'Play',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: TextButton.icon(
                    onPressed: model.downloadBtnClick,
                    icon: model.downloading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: double.parse(model.progress) != 0
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                    value: double.parse(model.progress) / 100,
                                  )
                                : const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                          )
                        : Icon(
                            model.downloaded ? Icons.delete : Icons.download,
                          ),
                    label: Text(
                      model.downloading
                          ? 'DOWNLOADING ${model.progress} %'
                          : model.downloaded
                              ? 'Remove Download'
                              : 'Download',
                    ),
                  ),
                ),
                Html(
                  data: episode.description,
                  shrinkWrap: true,
                  onLinkTap: (String? url, RenderContext context,
                      Map<String, String> attributes, dom.Element? element) {
                    launchUrlString(url!);
                  },
                  style: {
                    'body': Style(
                      fontSize: const FontSize(16),
                      color: Colors.white,
                      padding: EdgeInsets.zero,
                    )
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
