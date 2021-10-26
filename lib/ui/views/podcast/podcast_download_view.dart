import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:freecodecamp/models/podcasts/episodes_model.dart';
import 'package:freecodecamp/ui/views/podcast/podcast_download_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';

import 'episode/episode_view.dart';

// ui view only

class PodcastDownloadView extends StatelessWidget {
  const PodcastDownloadView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PodcastDownloadViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Downloaded Podcasts'),
          backgroundColor: const Color(0xFF0a0a23),
        ),
        backgroundColor: const Color(0xFF0a0a23),
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
      viewModelBuilder: () => PodcastDownloadViewModel(),
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
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Flexible(
                flex: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    episode.downloaded ? Icons.delete : Icons.download,
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
