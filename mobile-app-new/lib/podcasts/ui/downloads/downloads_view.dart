import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/podcasts/controllers/library_controller.dart';
import 'package:mobile_app_new/podcasts/models/episode_model.dart';
import 'package:mobile_app_new/podcasts/models/podcast_model.dart';
import 'package:mobile_app_new/podcasts/ui/widgets/episode_play_button.dart';
import 'package:mobile_app_new/podcasts/ui/widgets/podcast_artwork.dart';
import 'package:mobile_app_new/podcasts/ui/widgets/podcast_format.dart';
import 'package:mobile_app_new/routing/podcasts.dart';
import 'package:mobile_app_new/widgets/error_retry.dart';

class PodcastDownloadsView extends ConsumerStatefulWidget {
  const PodcastDownloadsView({super.key, this.offline = false, this.onRetry});
  final bool offline;
  final VoidCallback? onRetry;

  @override
  ConsumerState<PodcastDownloadsView> createState() =>
      _PodcastDownloadsViewState();
}

class _PodcastDownloadsViewState extends ConsumerState<PodcastDownloadsView> {
  bool _managing = false;
  bool _removing = false;
  final _selected = <String>{};

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final library = ref.watch(podcastLibraryProvider);
    return library.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => ErrorRetry(
        message: 'Unable to load downloads.',
        onRetry: () => ref.invalidate(podcastLibraryProvider),
      ),
      data: (library) {
        final episodes = <(Podcast, Episode)>[
          for (final podcast in library.podcasts)
            for (final episode
                in library.episodesByPodcastId[podcast.id] ?? <Episode>[])
              (podcast, episode),
        ];
        return ListView(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
          children: [
            if (widget.offline) ...[
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colors.secondaryContainer,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: colors.outlineVariant),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.wifi_off_rounded),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Can't load podcasts",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Check your connection and try again. Your downloaded episodes still play.',
                          ),
                          const SizedBox(height: 8),
                          OutlinedButton(
                            onPressed: widget.onRetry,
                            child: const Text('Try again'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'Available offline',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${episodes.length} ${episodes.length == 1 ? 'episode' : 'episodes'} on this device',
                      style: TextStyle(
                        fontSize: 14,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  if (episodes.isNotEmpty)
                    TextButton(
                      onPressed: _removing
                          ? null
                          : () => setState(() {
                              _managing = !_managing;
                              _selected.clear();
                            }),
                      child: Text(_managing ? 'Done' : 'Manage'),
                    ),
                ],
              ),
              const SizedBox(height: 14),
            ],
            if (_managing) ...[
              Row(
                children: [
                  TextButton(
                    onPressed: _removing
                        ? null
                        : () => setState(() {
                            if (_selected.length == episodes.length) {
                              _selected.clear();
                            } else {
                              _selected.addAll(
                                episodes.map((entry) => entry.$2.id),
                              );
                            }
                          }),
                    child: Text(
                      _selected.length == episodes.length
                          ? 'Deselect all'
                          : 'Select all',
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: _selected.isEmpty || _removing
                        ? null
                        : () => _remove(episodes),
                    icon: _removing
                        ? const SizedBox.square(
                            dimension: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.delete_outline_rounded, size: 18),
                    label: Text('Remove (${_selected.length})'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            if (episodes.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 48,
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.download_rounded,
                      size: 44,
                      color: colors.primary,
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'No downloaded episodes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Download an episode to listen wherever you are.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colors.onSurfaceVariant),
                    ),
                  ],
                ),
              )
            else
              Material(
                color: colors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: colors.outlineVariant),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    for (var i = 0; i < episodes.length; i++) ...[
                      if (i > 0)
                        Divider(height: 1, color: colors.outlineVariant),
                      _DownloadRow(
                        podcast: episodes[i].$1,
                        episode: episodes[i].$2,
                        managing: _managing,
                        selected: _selected.contains(episodes[i].$2.id),
                        onSelect: _removing
                            ? null
                            : () => setState(() {
                                final id = episodes[i].$2.id;
                                if (!_selected.add(id)) _selected.remove(id);
                              }),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _remove(List<(Podcast, Episode)> episodes) async {
    setState(() => _removing = true);
    try {
      for (final (_, episode) in episodes.where(
        (entry) => _selected.contains(entry.$2.id),
      )) {
        await ref
            .read(podcastLibraryProvider.notifier)
            .remove(episode.podcastId, episode.id);
        if (!mounted) return;
      }
      if (mounted) {
        setState(() {
          _selected.clear();
          _managing = false;
        });
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to remove some downloads. Please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _removing = false);
    }
  }
}

class _DownloadRow extends StatelessWidget {
  const _DownloadRow({
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
                    podcast.title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    episode.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '✓ Downloaded${episode.duration == null ? '' : ' · ${podcastDuration(episode.duration)}'}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: FccDesignColors.of(context).success,
                    ),
                  ),
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
