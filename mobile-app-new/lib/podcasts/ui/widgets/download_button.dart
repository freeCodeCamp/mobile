import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/podcasts/controllers/downloads_controller.dart';
import 'package:mobile_app_new/podcasts/controllers/library_controller.dart';
import 'package:mobile_app_new/podcasts/models/episode_model.dart';
import 'package:mobile_app_new/podcasts/models/podcast_model.dart';

class PodcastDownloadButton extends ConsumerWidget {
  const PodcastDownloadButton({
    super.key,
    required this.podcast,
    required this.episode,
    this.size = 22,
    this.outlined = false,
  });

  final Podcast podcast;
  final Episode episode;
  final double size;
  final bool outlined;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final downloadState = ref.watch(
      podcastDownloadsProvider.select((state) => state[episode.id]),
    );
    final isDownloaded = ref.watch(
      podcastLibraryProvider.select(
        (state) =>
            state.value?.episodesByPodcastId[episode.podcastId]?.any(
              (downloaded) => downloaded.id == episode.id,
            ) ??
            false,
      ),
    );
    final label = switch (downloadState) {
      DownloadRunning() => 'Cancel download',
      DownloadFailed() => 'Download failed, tap to retry',
      null when isDownloaded => 'Remove download',
      null => 'Download episode',
    };
    final Widget icon = switch (downloadState) {
      DownloadRunning(:final progress) => SizedBox.square(
        dimension: size,
        child: CircularProgressIndicator(
          color: colors.primary,
          strokeWidth: 2,
          value: progress,
          semanticsLabel: 'Downloading episode',
          semanticsValue: '${(progress * 100).round()} percent',
        ),
      ),
      DownloadFailed() => Icon(Icons.refresh_rounded, color: colors.error),
      null when isDownloaded => Icon(
        Icons.check_circle_rounded,
        color: FccDesignColors.of(context).success,
      ),
      null => Icon(Icons.download_rounded, color: colors.onSurfaceVariant),
    };

    return IconButton(
      tooltip: label,
      iconSize: size,
      style: IconButton.styleFrom(
        backgroundColor: outlined ? colors.surface : null,
        side: outlined ? BorderSide(color: colors.outline) : null,
        fixedSize: outlined ? const Size(52, 48) : null,
      ),
      icon: icon,
      onPressed: () async {
        try {
          switch (downloadState) {
            case DownloadRunning():
              ref.read(podcastDownloadsProvider.notifier).cancel(episode.id);
            case DownloadFailed():
              await ref
                  .read(podcastDownloadsProvider.notifier)
                  .start(podcast, episode);
            case null when isDownloaded:
              await ref
                  .read(podcastLibraryProvider.notifier)
                  .remove(episode.podcastId, episode.id);
            case null:
              await ref
                  .read(podcastDownloadsProvider.notifier)
                  .start(podcast, episode);
          }
        } catch (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Unable to update this download. Please try again.',
                ),
              ),
            );
          }
        }
      },
    );
  }
}
