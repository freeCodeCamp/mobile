import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:jiffy/jiffy.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/podcasts/controllers/player_controller.dart';
import 'package:mobile_app_new/podcasts/models/episode_model.dart';
import 'package:mobile_app_new/podcasts/models/podcast_model.dart';
import 'package:mobile_app_new/podcasts/ui/widgets/download_button.dart';
import 'package:mobile_app_new/routing/podcasts.dart';

class PodcastEpisodeTile extends StatelessWidget {
  const PodcastEpisodeTile({
    super.key,
    required this.podcast,
    required this.episode,
  });

  final Podcast podcast;
  final Episode episode;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: FccColors.gray90,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => PodcastEpisodeRoute(
            podcastId: podcast.id,
            episodeId: episode.id,
            $extra: (podcast, episode),
          ).push<void>(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PublishedAt(date: episode.publicationDate),
                const SizedBox(height: 6),
                Text(
                  episode.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: FccColors.gray00,
                  ),
                ),
                _Summary(description: episode.description),
                Row(
                  children: [
                    _PodcastPlayButton(podcast: podcast, episode: episode),
                    const SizedBox(width: 12),
                    PodcastDownloadButton(podcast: podcast, episode: episode),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PodcastPlayButton extends ConsumerWidget {
  const _PodcastPlayButton({required this.podcast, required this.episode});

  final Podcast podcast;
  final Episode episode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(
      podcastPlayerProvider.select(
        (state) => (
          isPlaying: state.isPlayingEpisode(episode.id),
          isBusy: state.isBusyWith(episode.id),
        ),
      ),
    );

    return IconButton(
      onPressed: () =>
          ref.read(podcastPlayerProvider.notifier).toggle(podcast, episode),
      iconSize: 33,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          status.isPlaying ? FccColors.purple90 : FccColors.gray80,
        ),
        shape: WidgetStateProperty.all(const CircleBorder()),
      ),
      icon: status.isBusy
          ? const SizedBox.square(
              dimension: 33,
              child: Padding(
                padding: EdgeInsets.all(2),
                child: CircularProgressIndicator(
                  color: FccColors.gray00,
                  strokeWidth: 1.8,
                ),
              ),
            )
          : Icon(
              status.isPlaying ? Icons.pause : Icons.play_arrow,
              color: FccColors.gray00,
              size: 33,
              semanticLabel: status.isPlaying
                  ? 'Pause episode'
                  : 'Play episode',
            ),
    );
  }
}

class _PublishedAt extends StatelessWidget {
  const _PublishedAt({required this.date});

  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    if (date == null) return const SizedBox.shrink();

    return Text(
      Jiffy.parseFromDateTime(date!).fromNow().toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        color: FccColors.gray10,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.1,
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.description});

  final String description;

  static String _firstSentence(String html) {
    if (html.isEmpty) return '';

    final text = html_parser.parse(html).body?.text.trim() ?? '';
    final match = RegExp(r'([^.?!]*[.?!])').firstMatch(text);
    final sentence = match?.group(0)?.trim() ?? text;

    return sentence.length > 120
        ? '${sentence.substring(0, 120).trimRight()}...'
        : sentence;
  }

  @override
  Widget build(BuildContext context) {
    final sentence = _firstSentence(description);
    if (sentence.isEmpty) return const SizedBox(height: 14);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        Text(
          sentence,
          style: const TextStyle(color: FccColors.gray10, fontSize: 16),
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}
