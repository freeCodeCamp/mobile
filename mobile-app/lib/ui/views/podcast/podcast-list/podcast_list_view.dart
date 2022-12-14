import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/ui/views/podcast/episode-list/episode_list_view.dart';
import 'package:freecodecamp/ui/views/podcast/podcast-list/podcast_list_viewmodel.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';
import 'package:stacked/stacked.dart';

List views = [
  const PodcastListViewBuilder(isDownloadView: false),
  const PodcastListViewBuilder(isDownloadView: true),
];

List titles = [
  const Text('PODCASTS'),
  const Text('Downloaded Podcasts'),
];

class PodcastListView extends StatelessWidget {
  const PodcastListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PodcastListViewModel>.reactive(
      viewModelBuilder: () => PodcastListViewModel(),
      onModelReady: (model) async => await model.init(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: titles.elementAt(model.index),
        ),
        drawer: const DrawerWidgetView(),
        backgroundColor: const Color(0xFF0a0a23),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: model.index,
          onTap: model.setIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.grid_view_rounded,
              ),
              label: 'Browse',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.arrow_circle_down_sharp,
              ),
              label: 'Downloads',
            ),
          ],
        ),
        body: views.elementAt(model.index),
      ),
    );
  }
}

class PodcastListViewBuilder extends StatelessWidget {
  const PodcastListViewBuilder({
    Key? key,
    required this.isDownloadView,
  }) : super(key: key);

  final bool isDownloadView;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PodcastListViewModel>.reactive(
      viewModelBuilder: () => PodcastListViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: const Color(0xFF2A2A40),
        body: RefreshIndicator(
          backgroundColor: const Color(0xFF0a0a23),
          color: Colors.white,
          onRefresh: () {
            model.refresh();
            return Future.delayed(const Duration(seconds: 0));
          },
          child: FutureBuilder<List<Podcasts>>(
            future: model.fetchPodcasts(isDownloadView),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Unable to load podcasts \n please try again.',
                    textAlign: TextAlign.center,
                  ),
                );
              }
              if (snapshot.data!.isEmpty && isDownloadView) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.arrow_circle_down_sharp,
                        color: Colors.white,
                        size: 50,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'No downloaded episodes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return GridView.count(
                  crossAxisCount: 2,
                  // crossAxisSpacing: 10,

                  childAspectRatio: 1,
                  children: List.generate(
                    snapshot.data!.length,
                    (index) => PodcastTemplate(
                      podcast: snapshot.data![index],
                      i: index,
                      isDownloadView: isDownloadView,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class PodcastTemplate extends StatelessWidget {
  const PodcastTemplate({
    Key? key,
    required this.podcast,
    required this.i,
    required this.isDownloadView,
  }) : super(key: key);

  final Podcasts podcast;
  final int i;
  final bool isDownloadView;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EpisodeListView(
                podcast: podcast,
                isDownloadView: isDownloadView,
              ),
              settings: RouteSettings(
                name: 'Podcasts Episode List View - ${podcast.title}',
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Stack(
            children: [
              isDownloadView
                  ? Image.file(
                      File(
                        '${PodcastListViewModel.appDir.path}/images/podcast/${podcast.id}.jpg',
                      ),
                      // height: 130,
                      alignment: Alignment.center,
                    )
                  : CachedNetworkImage(
                      imageUrl: podcast.image!,
                    ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.75),
                              spreadRadius: 1.5,
                              blurRadius: 0.1,
                            )
                          ],
                        ),
                        child: Text('${podcast.title!}\n',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.2,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
