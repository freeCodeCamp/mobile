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
import 'package:readmore/readmore.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class EpisodeListView extends StatelessWidget {
  const EpisodeListView({
    Key? key,
    required this.podcast,
    required this.isDownloadView,
  }) : super(key: key);

  final Podcasts podcast;
  final bool isDownloadView;

  final TextStyle _titleStyle = const TextStyle(fontSize: 24);

  final TextStyle _subTitleStyle = const TextStyle(fontSize: 14);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EpisodeListViewModel>.reactive(
      viewModelBuilder: () => EpisodeListViewModel(podcast),
      onModelReady: (model) => model.initState(isDownloadView),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(podcast.title!),
        ),
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              Container(
                color: const Color(0xFF0a0a23),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        children: [
                          Image.network(
                            podcast.image!,
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
                          // TODO: Works correctly but for links in
                          // description(check commented line in viewmodel)
                          // placeholder text comes up
                          // ReadMoreText(
                          //   podcast.description!,
                          //   trimLines: 3,
                          //   trimMode: TrimMode.Line,
                          //   trimCollapsedText: 'More ∨',
                          //   trimExpandedText: 'Less ∧',
                          //   style: const TextStyle(
                          //     color: Colors.white,
                          //     fontSize: 16,
                          //   ),
                          // ),
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
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade600,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        model.epsLength.toString() + ' episodes',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<Episodes>>(
                future: model.episodes,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return PodcastEpisodeTemplate(
                          episode: snapshot.data![index],
                          i: index,
                          podcast: podcast,
                          isDownloadView: isDownloadView,
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          color: Colors.grey.shade600,
                          height: 1,
                          thickness: 1,
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                  // TODO: Read up more on perf issues with shrinkWrap and check
                  // for diff in perf in below commented code
                  // return Column(
                  //   crossAxisAlignment: CrossAxisAlignment.stretch,
                  //   children: <PodcastEpisodeTemplate>[
                  //     ...snapshot.data!
                  //         .asMap()
                  //         .map(
                  //           (i, episode) {
                  //             return MapEntry(
                  //               i,
                  //               PodcastEpisodeTemplate(
                  //                 episode: episode,
                  //                 i: i,
                  //                 podcast: podcast,
                  //               ),
                  //             );
                  //           },
                  //         )
                  //         .values
                  //         .toList(),
                  //   ],
                  // );
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
  const PodcastEpisodeTemplate({
    Key? key,
    required this.episode,
    required this.i,
    required this.podcast,
    required this.isDownloadView,
  }) : super(key: key);

  final Episodes episode;
  final Podcasts podcast;
  final int i;
  final bool isDownloadView;

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
            builder: (context) => EpisodeView(
              episode: episode,
              podcast: podcast,
            ),
          ),
        );
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 50),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                episode.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  DateFormat.yMMMd().format(episode.publicationDate!) +
                      (episode.duration != null &&
                              episode.duration != Duration.zero
                          ? (' • ' + _parseDuration(episode.duration!))
                          : ''),
                  style: const TextStyle(
                    fontSize: 12,
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
