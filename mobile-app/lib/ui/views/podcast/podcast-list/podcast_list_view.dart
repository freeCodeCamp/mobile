import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/extensions/i18n_extension.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/ui/views/podcast/episode-list/episode_list_view.dart';
import 'package:freecodecamp/ui/views/podcast/podcast-list/podcast_list_viewmodel.dart';
import 'package:freecodecamp/ui/widgets/drawer_widget/drawer_widget_view.dart';

List views = [
  const PodcastListViewBuilder(isDownloadView: false),
  const PodcastListViewBuilder(isDownloadView: true),
];

class PodcastListView extends ConsumerStatefulWidget {
  const PodcastListView({super.key});

  @override
  ConsumerState<PodcastListView> createState() => _PodcastListViewState();
}

class _PodcastListViewState extends ConsumerState<PodcastListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(podcastListProvider.notifier).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(podcastListProvider);
    final notifier = ref.read(podcastListProvider.notifier);

    List titles = [
      Text(context.t.podcasts_title),
      Text(context.t.podcast_download_title),
    ];

    return Scaffold(
      appBar: AppBar(
        title: titles.elementAt(state.index),
      ),
      drawer: const DrawerWidgetView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: state.index,
        onTap: notifier.setIndex,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.grid_view_rounded,
            ),
            label: context.t.podcasts_browse,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.arrow_circle_down_sharp,
            ),
            label: context.t.podcasts_downloads,
          ),
        ],
      ),
      body: views.elementAt(state.index),
    );
  }
}

class PodcastListViewBuilder extends ConsumerWidget {
  const PodcastListViewBuilder({
    super.key,
    required this.isDownloadView,
  });

  final bool isDownloadView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(podcastListProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF2A2A40),
      body: RefreshIndicator(
        backgroundColor: const Color(0xFF0a0a23),
        color: Colors.white,
        onRefresh: () {
          // invalidate to trigger a fresh fetch
          ref.invalidate(podcastListProvider);
          return Future.delayed(const Duration(seconds: 0));
        },
        child: FutureBuilder<List<Podcasts>>(
          future: notifier.fetchPodcasts(isDownloadView),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  context.t.podcast_unable_to_load_podcasts,
                  textAlign: TextAlign.center,
                ),
              );
            }
            if (snapshot.data!.isEmpty && isDownloadView) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.arrow_circle_down_sharp,
                      color: Colors.white,
                      size: 50,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      context.t.podcast_no_downloads,
                      style: const TextStyle(
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
    super.key,
    required this.podcast,
    required this.i,
    required this.isDownloadView,
  });

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
              name: '/podcasts-episode-list/${podcast.title}',
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Stack(
          children: [
            Container(
              color: const Color(0xFF0a0a23),
              child: isDownloadView
                  ? Image.file(
                      File(
                        '${PodcastListNotifier.appDir.path}/images/podcast/${podcast.id}.jpg',
                      ),
                      alignment: Alignment.center,
                    )
                  : CachedNetworkImage(
                      imageUrl: podcast.image!,
                    ),
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
                            color: Colors.black.withValues(alpha: 0.75),
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
                            overflow: TextOverflow.ellipsis,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
