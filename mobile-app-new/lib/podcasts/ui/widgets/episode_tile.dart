import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/podcasts/controllers/player_controller.dart';
import 'package:mobile_app_new/podcasts/models/episode_model.dart';
import 'package:mobile_app_new/podcasts/models/podcast_model.dart';
import 'package:mobile_app_new/podcasts/ui/widgets/download_button.dart';
import 'package:mobile_app_new/podcasts/ui/widgets/episode_play_button.dart';
import 'package:mobile_app_new/podcasts/ui/widgets/podcast_artwork.dart';
import 'package:mobile_app_new/podcasts/ui/widgets/podcast_format.dart';
import 'package:mobile_app_new/routing/podcasts.dart';

class PodcastEpisodeTile extends ConsumerWidget {
  const PodcastEpisodeTile({
    super.key,
    required this.podcast,
    required this.episode,
  });

  final Podcast podcast;
  final Episode episode;

  void _open(BuildContext context) => PodcastEpisodeRoute(
    podcastId: podcast.id,
    episodeId: episode.id,
    $extra: (podcast, episode),
  ).push<void>(context);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final numberMatch = RegExp(
      r'^(?:#(\d+)\b|(\d+)\s*[-:.])\s*',
    ).firstMatch(episode.title);
    final number = numberMatch?.group(1) ?? numberMatch?.group(2);
    final title = numberMatch == null
        ? episode.title
        : episode.title.substring(numberMatch.end);
    final current = ref.watch(
      podcastPlayerProvider.select((state) => state.isCurrent(episode.id)),
    );
    return InkWell(
      onTap: () => _open(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (number == null)
              PodcastArtwork(podcast: podcast, size: 52)
            else
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Text(
                  '#$number',
                  style: TextStyle(
                    color: colors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (episode.publicationDate != null) ...[
                    Text(
                      podcastDate(episode.publicationDate!),
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: EpisodePlayButton(
                            podcast: podcast,
                            episode: episode,
                            compact: true,
                          ),
                        ),
                      ),
                      if (current &&
                          MediaQuery.sizeOf(context).width >= 400) ...[
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 32,
                          child: _EpisodeProgress(episode: episode),
                        ),
                      ],
                      PodcastDownloadButton(
                        podcast: podcast,
                        episode: episode,
                        size: 19,
                      ),
                      PopupMenuButton<String>(
                        tooltip: 'Episode options',
                        icon: Icon(
                          Icons.more_horiz_rounded,
                          size: 20,
                          color: colors.onSurfaceVariant,
                        ),
                        padding: EdgeInsets.zero,
                        onSelected: (value) {
                          if (value == 'details') _open(context);
                          if (value == 'share') {
                            sharePodcast(
                              context,
                              episode.title,
                              episode.audioUrl,
                            );
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                            value: 'details',
                            child: Text('Episode details'),
                          ),
                          PopupMenuItem(
                            value: 'share',
                            child: Text('Share episode'),
                          ),
                        ],
                      ),
                    ],
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

class _EpisodeProgress extends ConsumerWidget {
  const _EpisodeProgress({required this.episode});
  final Episode episode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final position =
        ref.watch(podcastPlaybackPositionProvider).value ?? Duration.zero;
    final duration =
        ref.watch(podcastPlayerProvider.select((state) => state.duration)) ??
        episode.duration;
    final value = duration == null || duration.inMilliseconds == 0
        ? 0.0
        : (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
    return LinearProgressIndicator(
      value: value,
      minHeight: 3,
      borderRadius: BorderRadius.circular(3),
    );
  }
}
