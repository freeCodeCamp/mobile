import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/podcasts/controllers/player_controller.dart';
import 'package:freecodecamp/podcasts/models/episode_model.dart';
import 'package:freecodecamp/podcasts/models/podcast_model.dart';
import 'package:freecodecamp/podcasts/ui/widgets/podcast_format.dart';

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
    final foreground = busy
        ? colors.outline
        : prominent
        ? colors.onSecondary
        : playing
        ? colors.onSurface
        : FccDesignColors.of(context).accentText;
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
        child: OutlinedButton.icon(
          style: FccTheme.compactOutlineStyle(context).copyWith(
            backgroundColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.disabled)
                  ? colors.surfaceContainer
                  : playing || states.contains(WidgetState.pressed)
                  ? colors.primaryContainer
                  : Colors.transparent,
            ),
            foregroundColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.disabled)
                  ? colors.outline
                  : foreground,
            ),
            minimumSize: const WidgetStatePropertyAll(Size(44, 36)),
            fixedSize: const WidgetStatePropertyAll(Size.fromHeight(36)),
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 10),
            ),
            visualDensity: const VisualDensity(vertical: -1),
            tapTargetSize: MaterialTapTargetSize.padded,
            shape: FccTheme.focusShape(context, radius: 999),
            textStyle: const WidgetStatePropertyAll(
              TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ),
          onPressed: action,
          icon: icon,
          label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      );
    }

    return IconButton.filled(
      tooltip: playing ? 'Pause episode' : 'Play episode',
      onPressed: action,
      style:
          IconButton.styleFrom(
            backgroundColor: prominent
                ? colors.secondary
                : colors.secondaryContainer,
            foregroundColor: prominent ? colors.onSecondary : colors.onSurface,
            disabledBackgroundColor: colors.surfaceContainer,
            disabledForegroundColor: colors.outline,
            fixedSize: Size.square(prominent ? 80 : 48),
          ).copyWith(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled))
                return colors.surfaceContainer;
              if (states.contains(WidgetState.pressed)) {
                return prominent
                    ? FccDesignColors.of(context).primaryPressed
                    : colors.surfaceContainer;
              }
              return prominent ? colors.secondary : colors.secondaryContainer;
            }),
            shape: FccTheme.focusShape(context, radius: 999),
          ),
      icon: icon,
    );
  }
}
