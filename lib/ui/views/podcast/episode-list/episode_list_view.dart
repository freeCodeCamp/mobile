import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/ui/views/podcast/episode-list/episode_list_viewmodel.dart';
import 'package:freecodecamp/ui/views/podcast/episode/episode_view.dart';
import 'package:html/dom.dart' as dom;
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class EpisodeListView extends StatelessWidget {
  const EpisodeListView({Key? key, required this.podcast}) : super(key: key);

  final Podcasts podcast;

  final TextStyle _titleStyle =
      const TextStyle(color: Colors.white, fontSize: 24);

  final TextStyle _subTitleStyle =
      const TextStyle(color: Colors.white, fontSize: 14);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EpisodeListViewModel>.reactive(
      viewModelBuilder: () => EpisodeListViewModel(podcast),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(podcast.title!),
          backgroundColor: const Color(0xFF0a0a23),
        ),
        backgroundColor: const Color(0xFF0a0a23),
        // backgroundColor: const Color(0xFFFFFFFF),
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  children: [
                    Image.file(
                      File(
                          '/data/user/0/org.freecodecamp/app_flutter/images/podcast/${podcast.id}.jpg'),
                      height: 175,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      podcast.title!,
                      style: _titleStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Html(
                      data: podcast.description!,
                      onLinkTap: (
                        String? url,
                        RenderContext context,
                        Map<String, String> attributes,
                        dom.Element? element,
                      ) {
                        launch(url!);
                      },
                      style: {
                        'body': Style(
                          fontSize: const FontSize(16),
                          color: Colors.white,
                          margin: EdgeInsets.zero,
                        )
                      },
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<Episodes>>(
                future: model.fetchPodcastEpisodes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  }
                  if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  // log(podcastEpisodes);
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return PodcastEpisodeTemplate(
                        episode: snapshot.data![index],
                        i: index,
                        podcast: podcast,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PodcastEpisodeTemplate extends StatelessWidget {
  const PodcastEpisodeTemplate(
      {Key? key, required this.episode, required this.i, required this.podcast})
      : super(key: key);

  final Episodes episode;
  final Podcasts podcast;
  final int i;

  String _parseDuration(Duration dur) {
    if (dur.inMinutes > 59) {
      return '${episode.duration!.inMinutes ~/ 60} hr ${episode.duration!.inMinutes % 60} min';
    } else {
      return '${episode.duration!.inMinutes % 60} min';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        log("Clicked ${episode.title}");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    EpisodeView(episode: episode, podcast: podcast)));
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 50),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                width: 1,
                color: Colors.grey,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                episode.title!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  DateFormat.yMMMd().format(episode.publicationDate!) +
                      (episode.duration! != Duration.zero
                          ? (' • ' + _parseDuration(episode.duration!))
                          : ''),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
