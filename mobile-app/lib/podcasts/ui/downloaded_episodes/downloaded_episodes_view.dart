import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/podcasts/controllers/library_controller.dart';
import 'package:freecodecamp/podcasts/models/episode_model.dart';
import 'package:freecodecamp/podcasts/models/podcast_model.dart';
import 'package:freecodecamp/podcasts/ui/downloaded_episodes/downloaded_episodes_viewmodel.dart';
import 'package:freecodecamp/podcasts/ui/widgets/downloads_management_list.dart';
import 'package:freecodecamp/podcasts/ui/widgets/episode_play_button.dart';
import 'package:freecodecamp/podcasts/ui/widgets/podcast_artwork.dart';
import 'package:freecodecamp/podcasts/ui/widgets/podcast_format.dart';
import 'package:freecodecamp/routing/podcasts.dart';
import 'package:freecodecamp/widgets/app_bottom_navigation.dart';
import 'package:freecodecamp/widgets/error_retry.dart';
import 'package:go_router/go_router.dart';

class PodcastDownloadedEpisodesView extends ConsumerWidget {
  const PodcastDownloadedEpisodesView({super.key, required this.podcastId});

  final String podcastId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = podcastDownloadedEpisodesProvider(podcastId);
    final episodes = ref.watch(provider);
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back to Downloads',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              const PodcastDownloadsRoute().go(context);
            }
          },
        ),
        title: const Text('Downloads'),
      ),
      bottomNavigationBar: const AppNavigationFooter(
        selected: AppDestination.account,
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: episodes.when(
          skipLoadingOnReload: true,
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => ErrorRetry(
            message: 'Unable to load downloads.',
            onRetry: () => ref.read(provider.notifier).retry(),
          ),
          data: (state) {
            final podcast = state.podcast;
            return DownloadManagementList(
              header: podcast == null
                  ? null
                  : Text(
                      podcast.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                      ),
                    ),
              items: [for (final episode in state.episodes) episode.id],
              itemBuilder: (context, index, managing, selected, onSelect) =>
                  PodcastDownloadedEpisodeRow(
                    podcast: podcast!,
                    episode: state.episodes[index],
                    managing: managing,
                    selected: selected,
                    onSelect: onSelect,
                  ),
              onRemove: (ids) => ref
                  .read(podcastLibraryProvider.notifier)
                  .removeEpisodes(podcastId, ids),
              emptyState: const DownloadsEmptyState(),
            );
          },
        ),
      ),
    );
  }
}

class PodcastDownloadedEpisodeRow extends StatelessWidget {
  const PodcastDownloadedEpisodeRow({
    super.key,
    required this.podcast,
    required this.episode,
    required this.managing,
    required this.selected,
    required this.onSelect,
  });

  final Podcast podcast;
  final Episode episode;
  final bool managing;
  final bool selected;
  final VoidCallback? onSelect;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final metadata = [
      if (episode.publicationDate != null)
        podcastDate(episode.publicationDate!),
      if (episode.duration != null) podcastDuration(episode.duration),
    ].join(' · ');
    return InkWell(
      onTap: managing
          ? onSelect
          : () => PodcastEpisodeRoute(
              podcastId: podcast.id,
              episodeId: episode.id,
              $extra: (podcast, episode),
            ).push<void>(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Row(
          children: [
            PodcastArtwork(podcast: podcast, size: 60),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    episode.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                    ),
                  ),
                  if (metadata.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Text(
                      metadata,
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (managing)
              Checkbox(
                value: selected,
                onChanged: onSelect == null ? null : (_) => onSelect!(),
              )
            else
              EpisodePlayButton(podcast: podcast, episode: episode),
          ],
        ),
      ),
    );
  }
}
