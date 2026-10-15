import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/podcasts/controllers/library_controller.dart';
import 'package:mobile_app_new/podcasts/ui/widgets/podcast_grid_tile.dart';
import 'package:mobile_app_new/routing/podcasts.dart';
import 'package:mobile_app_new/widgets/error_retry.dart';

class PodcastDownloadsView extends ConsumerWidget {
  const PodcastDownloadsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final library = ref.watch(podcastLibraryProvider);

    return ColoredBox(
      color: FccColors.gray80,
      child: library.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorRetry(
          message: 'Unable to load downloads.',
          onRetry: () => ref.invalidate(podcastLibraryProvider),
        ),
        data: (library) => library.podcasts.isEmpty
            ? const _NoDownloads()
            : GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1,
                children: [
                  for (final podcast in library.podcasts)
                    PodcastGridTile(
                      key: ValueKey(podcast.id),
                      podcast: podcast,
                      artwork: library.artworkByPodcastId[podcast.id],
                      onTap: () => PodcastEpisodeListRoute(
                        podcastId: podcast.id,
                        downloaded: true,
                      ).push(context),
                    ),
                ],
              ),
      ),
    );
  }
}

class _NoDownloads extends StatelessWidget {
  const _NoDownloads();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.arrow_circle_down_sharp, color: Colors.white, size: 50),
          SizedBox(height: 4),
          Text(
            'No downloads',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
