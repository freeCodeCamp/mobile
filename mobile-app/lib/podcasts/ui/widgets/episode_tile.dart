import 'package:flutter/material.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/podcasts/models/episode_model.dart';
import 'package:freecodecamp/podcasts/models/podcast_model.dart';
import 'package:freecodecamp/podcasts/ui/widgets/download_button.dart';
import 'package:freecodecamp/podcasts/ui/widgets/episode_play_button.dart';
import 'package:freecodecamp/podcasts/ui/widgets/podcast_artwork.dart';
import 'package:freecodecamp/podcasts/ui/widgets/podcast_format.dart';
import 'package:freecodecamp/routing/podcasts.dart';

class PodcastEpisodeTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final numberMatch = RegExp(
      r'^(?:#(\d+)\b|(\d+)\s*[-:.])\s*',
    ).firstMatch(episode.title);
    final number = numberMatch?.group(1) ?? numberMatch?.group(2);
    final title = numberMatch == null
        ? episode.title
        : episode.title.substring(numberMatch.end);
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
                  color: colors.surfaceContainer,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '#$number',
                      maxLines: 1,
                      softWrap: false,
                      semanticsLabel: 'Episode $number',
                      style: TextStyle(
                        color: FccDesignColors.of(context).accentText,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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
