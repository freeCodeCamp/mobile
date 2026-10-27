import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/fcc_theme.dart';
import 'package:freecodecamp/podcasts/models/episode_model.dart';
import 'package:freecodecamp/podcasts/models/podcast_model.dart';
import 'package:freecodecamp/podcasts/ui/episode_list/episode_list_viewmodel.dart';
import 'package:freecodecamp/podcasts/ui/widgets/episode_play_button.dart';
import 'package:freecodecamp/podcasts/ui/widgets/episode_tile.dart';
import 'package:freecodecamp/podcasts/ui/widgets/podcast_artwork.dart';
import 'package:freecodecamp/podcasts/ui/widgets/podcast_format.dart';
import 'package:freecodecamp/widgets/app_bottom_navigation.dart';
import 'package:freecodecamp/widgets/error_retry.dart';
import 'package:freecodecamp/widgets/mini_player.dart';

class PodcastEpisodeListView extends ConsumerStatefulWidget {
  const PodcastEpisodeListView({super.key, required this.source});
  final PodcastEpisodeSource source;

  @override
  ConsumerState<PodcastEpisodeListView> createState() =>
      _PodcastEpisodeListViewState();
}

class _PodcastEpisodeListViewState
    extends ConsumerState<PodcastEpisodeListView> {
  final _scrollController = ScrollController();
  bool _oldestFirst = false;
  bool _loadingOlder = false;
  int _sortGeneration = 0;

  PodcastEpisodesNotifierProvider get _provider =>
      podcastEpisodesProvider(widget.source);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _sortGeneration++;
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_oldestFirst && _scrollController.position.extentAfter < 1000) {
      ref.read(_provider.notifier).fetchNextPage();
    }
  }

  // The feed endpoint returns newest-first pages. Wait for the complete list
  // before displaying oldest-first, rather than incorrectly reversing page one.
  Future<void> _loadOlder({bool retry = false}) async {
    if (_loadingOlder || !_oldestFirst) return;
    final initial = ref.read(_provider).value;
    if (initial == null || initial.isLoadingMore || !initial.hasNextPage) {
      return;
    }
    if (initial.loadMoreError != null && !retry) return;
    _loadingOlder = true;
    final generation = _sortGeneration;
    try {
      while (mounted && _oldestFirst && generation == _sortGeneration) {
        final current = ref.read(_provider).value;
        if (current == null || !current.hasNextPage || current.isLoadingMore) {
          break;
        }
        if (current.loadMoreError != null && !retry) break;
        await ref.read(_provider.notifier).fetchNextPage(isRetry: retry);
        retry = false;
      }
    } finally {
      _loadingOlder = false;
      if (mounted && _oldestFirst && generation != _sortGeneration) {
        unawaited(_loadOlder());
      }
    }
  }

  Future<void> _sort() async {
    final oldest = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sort episodes',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 18),
              for (final value in [false, true]) ...[
                Material(
                  color: _oldestFirst == value
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      value ? 'Oldest first' : 'Newest first',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: _oldestFirst == value
                            ? FccDesignColors.of(context).accentText
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    trailing: _oldestFirst == value
                        ? Icon(
                            Icons.check_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                    onTap: () => Navigator.of(context).pop(value),
                  ),
                ),
                if (!value) const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ),
    );
    if (oldest == null || !mounted || oldest == _oldestFirst) return;
    setState(() {
      _oldestFirst = oldest;
      _sortGeneration++;
    });
    if (_scrollController.hasClients) _scrollController.jumpTo(0);
    if (oldest) unawaited(_loadOlder());
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final episodes = ref.watch(_provider);
    ref.listen(_provider, (_, next) {
      final state = next.value;
      if (_oldestFirst &&
          state != null &&
          !state.isLoadingMore &&
          state.loadMoreError == null &&
          state.hasNextPage) {
        unawaited(_loadOlder());
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Podcast'),
        backgroundColor: colors.surfaceContainerLow,
      ),
      bottomNavigationBar: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MiniPlayer(),
          AppBottomNavigation(selected: AppDestination.listen),
        ],
      ),
      body: episodes.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorRetry(
          message: 'Unable to load episodes.',
          onRetry: () => ref.invalidate(_provider),
        ),
        data: (state) {
          final ordered = [...state.episodes]
            ..sort((a, b) {
              final comparison = (a.publicationDate ?? DateTime(0)).compareTo(
                b.publicationDate ?? DateTime(0),
              );
              return _oldestFirst ? comparison : -comparison;
            });
          final newest = [...state.episodes]
            ..sort(
              (a, b) => (b.publicationDate ?? DateTime(0)).compareTo(
                a.publicationDate ?? DateTime(0),
              ),
            );
          final waitingForOldest = _oldestFirst && state.hasNextPage;
          return RefreshIndicator(
            onRefresh: () async {
              _sortGeneration++;
              await ref
                  .refresh(_provider.future)
                  .then<void>((_) {}, onError: (_) {});
              if (mounted && _oldestFirst) unawaited(_loadOlder());
            },
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _Header(
                    podcast: state.podcast,
                    latest: newest.firstOrNull,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.source is DownloadedEpisodes
                                    ? 'Downloaded episodes'
                                    : 'Episodes',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: _sort,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _oldestFirst
                                        ? 'Oldest first'
                                        : 'Newest first',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.expand_more_rounded,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(height: 1, color: colors.outlineVariant),
                      ],
                    ),
                  ),
                ),
                if (waitingForOldest)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: state.loadMoreError != null
                          ? ErrorRetry(
                              message: 'Unable to load older episodes.',
                              onRetry: () => _loadOlder(retry: true),
                            )
                          : Column(
                              children: [
                                const CircularProgressIndicator(),
                                const SizedBox(height: 16),
                                Text(
                                  'Loading older episodes…',
                                  style: TextStyle(
                                    color: colors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  )
                else if (ordered.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text('No episodes available.')),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList.separated(
                      itemCount: ordered.length,
                      separatorBuilder: (_, _) =>
                          Divider(height: 1, color: colors.outlineVariant),
                      itemBuilder: (context, index) => PodcastEpisodeTile(
                        key: ValueKey(ordered[index].id),
                        podcast: state.podcast,
                        episode: ordered[index],
                      ),
                    ),
                  ),
                if (!waitingForOldest && state.loadMoreError != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: ErrorRetry(
                        message: 'Unable to load more episodes.',
                        onRetry: () => ref
                            .read(_provider.notifier)
                            .fetchNextPage(isRetry: true),
                      ),
                    ),
                  ),
                if (!waitingForOldest && state.isLoadingMore)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header({required this.podcast, required this.latest});
  final Podcast podcast;
  final Episode? latest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(26)),
      ),
      child: Column(
        children: [
          PodcastArtwork(podcast: podcast, size: 150, radius: 20),
          const SizedBox(height: 18),
          Text(
            podcast.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: colors.secondary,
                  foregroundColor: colors.onSecondary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                ),
                onPressed: latest == null
                    ? null
                    : () =>
                          togglePodcastEpisode(context, ref, podcast, latest!),
                icon: const Icon(Icons.play_arrow_rounded, size: 19),
                label: const Text(
                  'Play latest',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              Builder(
                builder: (buttonContext) => IconButton.filled(
                  tooltip: 'Share podcast',
                  style: IconButton.styleFrom(
                    backgroundColor: colors.surface,
                    foregroundColor: colors.onSurface,
                  ),
                  onPressed: () => sharePodcast(
                    buttonContext,
                    podcast.title,
                    podcast.podcastLink.isEmpty
                        ? podcast.feedUrl
                        : podcast.podcastLink,
                  ),
                  icon: const Icon(Icons.ios_share_rounded, size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
