import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freecodecamp/podcasts/models/episode_model.dart';
import 'package:freecodecamp/podcasts/models/podcast_model.dart';
import 'package:freecodecamp/podcasts/ui/episode_list/episode_list_viewmodel.dart';
import 'package:freecodecamp/podcasts/ui/widgets/episode_play_button.dart';
import 'package:freecodecamp/podcasts/ui/widgets/episode_tile.dart';
import 'package:freecodecamp/podcasts/ui/widgets/podcast_artwork.dart';
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

  PodcastEpisodesNotifierProvider get _provider =>
      podcastEpisodesProvider(widget.source);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 1000) {
      ref.read(_provider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final episodes = ref.watch(_provider);

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
          onRetry: () => ref.read(_provider.notifier).refresh(),
        ),
        data: (state) {
          final ordered = state.orderedEpisodes;
          return RefreshIndicator(
            onRefresh: () => ref.read(_provider.notifier).refresh(),
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _Header(
                    podcast: state.podcast,
                    latest: state.latestEpisode,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            widget.source is DownloadedEpisodes
                                ? 'Downloaded episodes'
                                : 'Episodes',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Divider(height: 1, color: colors.outlineVariant),
                      ],
                    ),
                  ),
                ),
                if (ordered.isEmpty)
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
                if (state.loadMoreError != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: ErrorRetry(
                        message: 'Unable to load more episodes.',
                        onRetry: () =>
                            ref.read(_provider.notifier).retryLoadMore(),
                      ),
                    ),
                  ),
                if (state.isLoadingMore)
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
          PodcastArtwork(podcast: podcast, size: 168, radius: 20),
          const SizedBox(height: 18),
          Text(
            podcast.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  minimumSize: const Size(48, 48),
                  textStyle: const TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
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
                label: const Text('Play latest'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
