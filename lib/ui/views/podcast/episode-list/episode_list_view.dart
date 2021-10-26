import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/ui/views/podcast/episode/episode_view.dart';
import 'package:freecodecamp/ui/views/podcast/podcast_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';

// ui view only

class PodcastView extends StatelessWidget {
  const PodcastView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PodcastViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Podcasts'),
          backgroundColor: const Color(0xFF0a0a23),
        ),
        backgroundColor: const Color(0xFF0a0a23),
        // backgroundColor: const Color(0xFFFFFFFF),
        body: FutureBuilder<List<Episodes>>(
          future: model.fetchPodcastEpisodes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // log(podcastEpisodes);
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return PodcastEpisodeTemplate(
                    episode: snapshot.data![index], i: index);
              },
            );
          },
        ),
      ),
      viewModelBuilder: () => PodcastViewModel(),
    );
  }
}

class PodcastEpisodeTemplate extends StatelessWidget {
  const PodcastEpisodeTemplate(
      {Key? key, required this.episode, required this.i})
      : super(key: key);

  final Episodes episode;
  final int i;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        log("Clicked ${episode.title}");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EpisodeView(episode: episode)));
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 50),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
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
                  DateFormat.yMMMd().format(episode.publicationDate!),
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
