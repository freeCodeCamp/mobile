import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/ui/views/news/html_handler/html_handler.dart';
import 'package:freecodecamp/ui/views/podcast/episode-view/episode_viewmodel.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:freecodecamp/ui/widgets/podcast_widgets/podcast_progressbar_widget.dart';
import 'package:freecodecamp/ui/widgets/podcast_widgets/podcast_tilte_widget.dart';
import 'package:stacked/stacked.dart';

class EpisodeView extends StatelessWidget {
  const EpisodeView({Key? key, required this.episode, required this.podcast})
      : super(key: key);

  final Episodes episode;
  final Podcasts podcast;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EpisodeViewModel>.reactive(
        viewModelBuilder: () => EpisodeViewModel(),
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(),
              body: ListView(children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ]),
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      height: MediaQuery.of(context).size.height * 0.40,
                      width: MediaQuery.of(context).size.height * 0.40,
                      child: CachedNetworkImage(imageUrl: podcast.image!),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        episode.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    Text(
                      podcast.title!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    buildDivider(),
                    PodcastTile(
                        podcast: podcast,
                        episode: episode,
                        isFromEpisodeView: true,
                        isFromDownloadView: false),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PodcastProgressBar(
                        duration: episode.duration!,
                        episodeId: episode.id,
                      ),
                    ),
                    buildDivider(),
                    Container(
                      padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                      child: description(model, context),
                    ),
                  ],
                ),
              ]),
            ));
  }

  Widget description(EpisodeViewModel model, BuildContext context) {
    return Column(
      children: [HtmlHandler.htmlWidgetBuilder(episode.description, context)],
    );
  }
}
