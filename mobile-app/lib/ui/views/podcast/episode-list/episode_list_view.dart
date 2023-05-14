import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/ui/views/podcast/episode-list/episode_list_viewmodel.dart';
import 'package:freecodecamp/ui/views/podcast/podcast-list/podcast_list_viewmodel.dart';
import 'package:freecodecamp/ui/widgets/podcast_widgets/podcast_tilte_widget.dart';
import 'package:html/dom.dart' as dom;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher_string.dart';

class EpisodeListView extends StatelessWidget {
  const EpisodeListView({
    Key? key,
    required this.podcast,
    required this.isDownloadView,
  }) : super(key: key);

  final Podcasts podcast;
  final bool isDownloadView;

  // ignore: unused_field
  final TextStyle _subTitleStyle = const TextStyle(fontSize: 14);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EpisodeListViewModel>.reactive(
      viewModelBuilder: () => EpisodeListViewModel(podcast),
      onViewModelReady: (model) => model.initState(isDownloadView),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(podcast.title!),
        ),
        body: RefreshIndicator(
          onRefresh: () => Future.sync(() => model.pagingController.refresh()),
          backgroundColor: const Color(0xFF0a0a23),
          color: Colors.white,
          child: Align(
            alignment: Alignment.topCenter,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      podcastHeader(),
                      Container(
                        color: const Color(0xFF0a0a23),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: description(model),
                        ),
                      ),
                    ],
                  ),
                ),
                !isDownloadView
                    ? PagedSliverList.separated(
                        pagingController: model.pagingController,
                        builderDelegate: PagedChildBuilderDelegate<Episodes>(
                          itemBuilder: (
                            BuildContext context,
                            Episodes episode,
                            int index,
                          ) =>
                              PodcastTile(
                            episode: episode,
                            podcast: podcast,
                            isFromDownloadView: isDownloadView,
                          ),
                        ),
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(
                          height: 1,
                          thickness: 1,
                        ),
                      )
                    : SliverToBoxAdapter(
                        child: FutureBuilder<List<Episodes>>(
                          future: model.episodes,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return PodcastTile(
                                    episode: snapshot.data![index],
                                    podcast: podcast,
                                    isFromDownloadView: isDownloadView,
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const Divider(
                                    height: 1,
                                    thickness: 1,
                                  );
                                },
                              );
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column description(EpisodeListViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style:
              TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.2),
        ),
        // Html(
        //   data: podcast.description!,
        //   onLinkTap: (
        //     String? url,
        //     RenderContext context,
        //     Map<String, String> attributes,
        //     dom.Element? element,
        //   ) {
        //     launchUrlString(url!);
        //   },
        //   style: {
        //     '#': Style(
        //         fontSize: const FontSize(16),
        //         color: Colors.white.withOpacity(0.87),
        //         margin: EdgeInsets.zero,
        //         maxLines: model.showDescription ? null : 3,
        //         fontFamily: 'Lato')
        //   },
        // ),
        TextButton(
          onPressed: () {
            model.setShowMoreDescription = !model.showDescription;
          },
          child: Text(
            model.showDescription ? 'Show Less' : 'Show More',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        )
      ],
    );
  }

  Stack podcastHeader() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        isDownloadView
            ? Image.file(
                File(
                  '${PodcastListViewModel.appDir.path}/images/podcast/${podcast.id}.jpg',
                ),
              )
            : CachedNetworkImage(
                imageUrl: podcast.image!,
                fit: BoxFit.cover,
              ),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.75),
                      spreadRadius: 1.5,
                      blurRadius: 5,
                    )
                  ],
                ),
                child: Text(
                  '${podcast.title!}\n',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
