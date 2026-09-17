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
    this.size = 33,
  });

  final Podcast podcast;
  final Episode episode;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    final isRunning = downloadState is DownloadRunning;

    return IconButton(
      onPressed: () => _onPressed(ref, downloadState, isDownloaded),
      iconSize: size,
      style: ButtonStyle(
        shape: WidgetStateProperty.all(const CircleBorder()),
        side: WidgetStateProperty.all(
          isRunning
              ? BorderSide.none
              : const BorderSide(color: FccColors.gray80, width: 1),
        ),
      ),
      icon: _icon(downloadState, isDownloaded),
    );
  }

  void _onPressed(
    WidgetRef ref,
    DownloadStatus? downloadState,
    bool isDownloaded,
  ) => switch (downloadState) {
    DownloadRunning() =>
      ref.read(podcastDownloadsProvider.notifier).cancel(episode.id),
    DownloadFailed() =>
      ref.read(podcastDownloadsProvider.notifier).start(podcast, episode),
    null when isDownloaded =>
      ref
          .read(podcastLibraryProvider.notifier)
          .remove(episode.podcastId, episode.id),
    null => ref.read(podcastDownloadsProvider.notifier).start(podcast, episode),
  };

  Widget _icon(DownloadStatus? downloadState, bool isDownloaded) =>
      switch (downloadState) {
        DownloadRunning(:final progress) => SizedBox.square(
          dimension: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 1,
                value: progress,
              ),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        DownloadFailed() => Icon(
          Icons.refresh,
          color: FccColors.red15,
          semanticLabel: 'Download failed, tap to retry',
        ),
        null when isDownloaded => Icon(
          Icons.download_done,
          color: FccColors.gray10,
          semanticLabel: 'Downloaded, tap to delete',
        ),
        null => Icon(
          Icons.download,
          color: FccColors.gray10,
          semanticLabel: 'Download episode',
        ),
      };
}
