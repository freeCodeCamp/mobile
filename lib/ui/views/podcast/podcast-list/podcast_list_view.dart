import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:freecodecamp/models/podcasts/podcasts_model.dart';
import 'package:freecodecamp/ui/views/podcast/podcast-list/podcast_list_viewmodel.dart';
import 'package:stacked/stacked.dart';

// ui view only

class PodcastListView extends StatelessWidget {
  const PodcastListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PodcastListViewModel>.reactive(
      viewModelBuilder: () => PodcastListViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Podcasts List'),
          backgroundColor: const Color(0xFF0a0a23),
        ),
        backgroundColor: const Color(0xFF0a0a23),
        // backgroundColor: const Color(0xFFFFFFFF),
        body: FutureBuilder<List<Podcasts>>(
          future: model.fetchPodcasts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return GridView.count(
              crossAxisCount: 2,
              // crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
              children: List.generate(
                snapshot.data!.length,
                (index) =>
                    PodcastTemplate(podcast: snapshot.data![index], i: index),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PodcastTemplate extends StatelessWidget {
  const PodcastTemplate({Key? key, required this.podcast, required this.i})
      : super(key: key);

  final Podcasts podcast;
  final int i;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        log("Clicked ${podcast.title}");
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => EpisodeView(episode: episode)));
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              podcast.image!,
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
