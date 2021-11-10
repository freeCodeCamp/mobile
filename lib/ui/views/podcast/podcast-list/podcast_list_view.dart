import 'dart:developer';
import 'dart:io';

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
  const Text('Podcasts'),
  const Text('Downloaded Podcasts'),
];

class PodcastListView extends StatelessWidget {
  const PodcastListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PodcastListViewModel>.reactive(
      viewModelBuilder: () => PodcastListViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: titles.elementAt(model.index),
          backgroundColor: const Color(0xFF0a0a23),
          centerTitle: true,
        ),
        drawer: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: const DrawerWidgetView(),
        ),
        backgroundColor: const Color(0xFF0a0a23),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFF0a0a23),
          unselectedItemColor: Colors.white,
          selectedItemColor: const Color.fromRGBO(0x99, 0xc9, 0xff, 1),
          currentIndex: model.index,
          onTap: model.setIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.grid_view_rounded,
                color: Colors.white,
              ),
              label: 'Browse',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.arrow_circle_down_sharp,
                color: Colors.white,
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
        body: FutureBuilder<List<Podcasts>>(
          future: model.fetchPodcasts(isDownloadView),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (snapshot.hasError) {
              return Text("${snapshot.error}");
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
                mainAxisSpacing: 10,
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
        log("Clicked ${podcast.title}");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EpisodeListView(
              podcast: podcast,
              isDownloadView: isDownloadView,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(
              File(
                '/data/user/0/org.freecodecamp/app_flutter/images/podcast/${podcast.id}.jpg',
              ),
              height: 130,
              alignment: Alignment.center,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  podcast.title!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
