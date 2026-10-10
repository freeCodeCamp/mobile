import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/podcasts/controllers/player_controller.dart';
import 'package:mobile_app_new/podcasts/models/episode_model.dart';
import 'package:mobile_app_new/podcasts/models/podcast_model.dart';
import 'package:mobile_app_new/podcasts/ui/widgets/podcast_format.dart';

Future<void> togglePodcastEpisode(
  BuildContext context,
  WidgetRef ref,
  Podcast podcast,
  Episode episode,
) async {
  try {
    await ref.read(podcastPlayerProvider.notifier).toggle(podcast, episode);
    if (!context.mounted) return;
    if (!ref.read(podcastPlayerProvider).isCurrent(episode.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to play this episode. Please try again.'),
        ),
      );
    }
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to play this episode. Please try again.'),
        ),
      );
    }
  }
}

class EpisodePlayButton extends ConsumerWidget {
  const EpisodePlayButton({
    super.key,
    required this.podcast,
    required this.episode,
    this.compact = false,
    this.prominent = false,
  });

  final Podcast podcast;
  final Episode episode;
  final bool compact;
  final bool prominent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final player = ref.watch(podcastPlayerProvider);
    final playing = player.isPlayingEpisode(episode.id);
    final busy = player.isBusyWith(episode.id);
    final current = player.isCurrent(episode.id);
    final foreground = prominent
        ? colors.onSecondary
        : playing
        ? colors.onPrimary
        : colors.primary;
    final background = prominent
        ? colors.secondary
        : playing
        ? colors.primary
        : colors.surfaceContainerLow;
    final icon = busy
        ? SizedBox.square(
            dimension: compact ? 13 : 24,
            child: CircularProgressIndicator(strokeWidth: 2, color: foreground),
          )
        : Icon(
            playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
            size: compact
                ? 16
                : prominent
                ? 42
                : 26,
          );
    final VoidCallback? action = busy
        ? null
        : () => togglePodcastEpisode(context, ref, podcast, episode);

    if (compact) {
      final position = current
          ? ref.watch(podcastPlaybackPositionProvider).value ?? Duration.zero
          : Duration.zero;
      final duration = current
          ? player.duration ?? episode.duration
          : episode.duration;
      final remaining = duration == null ? null : duration - position;
      final label = current && position > Duration.zero && remaining != null
          ? '${podcastDuration(remaining.isNegative ? Duration.zero : remaining)} left'
          : podcastDuration(duration);
      return Tooltip(
        message: playing ? 'Pause episode' : 'Play episode',
        child: FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: background,
            foregroundColor: foreground,
            disabledBackgroundColor: background,
            minimumSize: const Size(0, 34),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            tapTargetSize: MaterialTapTargetSize.padded,
          ),
          onPressed: action,
          icon: icon,
          label: Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    return IconButton.filled(
      tooltip: playing ? 'Pause episode' : 'Play episode',
      onPressed: action,
      style: IconButton.styleFrom(
        backgroundColor: prominent
            ? colors.secondary
            : colors.secondaryContainer,
        foregroundColor: prominent ? colors.onSecondary : colors.onSurface,
        disabledBackgroundColor: prominent
            ? colors.secondary
            : colors.secondaryContainer,
        fixedSize: Size.square(prominent ? 80 : 48),
      ),
      icon: icon,
    );
  }
}
