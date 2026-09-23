import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/podcasts/ui/podcast_list/podcast_list_viewmodel.dart';
import 'package:mobile_app_new/podcasts/ui/widgets/podcast_grid_tile.dart';
import 'package:mobile_app_new/routing/podcasts.dart';
import 'package:mobile_app_new/widgets/error_retry.dart';

class PodcastListView extends ConsumerWidget {
  const PodcastListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final podcasts = ref.watch(podcastListProvider);

    return ColoredBox(
      color: FccColors.gray80,
      child: podcasts.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorRetry(
          message: 'Unable to load podcasts.',
          onRetry: () => ref.invalidate(podcastListProvider),
        ),
        data: (podcasts) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(podcastListProvider),
          backgroundColor: FccColors.gray90,
          color: Colors.white,
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1,
            children: [
              for (final podcast in podcasts)
                PodcastGridTile(
                  key: ValueKey(podcast.id),
                  podcast: podcast,
                  onTap: () => PodcastEpisodeListRoute(
                    podcastId: podcast.id,
                  ).push(context),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
