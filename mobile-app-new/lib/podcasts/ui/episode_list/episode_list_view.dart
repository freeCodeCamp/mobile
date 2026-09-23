import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/podcasts/controllers/library_controller.dart';
import 'package:mobile_app_new/podcasts/models/podcast_model.dart';
import 'package:mobile_app_new/podcasts/ui/episode_list/episode_list_viewmodel.dart';
import 'package:mobile_app_new/podcasts/ui/widgets/episode_tile.dart';
import 'package:mobile_app_new/widgets/error_retry.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool _showFullDescription = false;

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
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 1000) {
      ref.read(_provider.notifier).fetchNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final episodes = ref.watch(_provider);

    return Scaffold(
      backgroundColor: FccColors.gray90,
      appBar: AppBar(title: Text(episodes.value?.podcast.title ?? '')),
      body: episodes.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorRetry(
          message: 'Unable to load episodes.',
          onRetry: () => ref.invalidate(_provider),
        ),
        data: (state) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(_provider),
          backgroundColor: FccColors.gray90,
          color: Colors.white,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _Header(podcast: state.podcast, source: widget.source),
                    _Description(
                      description: state.podcast.description,
                      isExpanded: _showFullDescription,
                      onToggle: () => setState(
                        () => _showFullDescription = !_showFullDescription,
                      ),
                    ),
                  ],
                ),
              ),
              if (state.episodes.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text('No episodes')),
                )
              else
                _buildList(state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(PodcastEpisodesState state) {
    final footer = _buildFooter(state);

    return SliverList.separated(
      itemCount: state.episodes.length + (footer == null ? 0 : 1),
      separatorBuilder: (_, _) =>
          const Divider(color: FccColors.gray80, thickness: 1, height: 1),
      itemBuilder: (context, index) => index == state.episodes.length
          ? footer
          : PodcastEpisodeTile(
              key: ValueKey(state.episodes[index].id),
              podcast: state.podcast,
              episode: state.episodes[index],
            ),
    );
  }

  Widget? _buildFooter(PodcastEpisodesState state) {
    if (state.loadMoreError != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: ErrorRetry(
          message: 'Unable to load more episodes.',
          onRetry: () =>
              ref.read(_provider.notifier).fetchNextPage(isRetry: true),
        ),
      );
    }

    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return null;
  }
}

class _Header extends ConsumerWidget {
  const _Header({required this.podcast, required this.source});

  final Podcast podcast;
  final PodcastEpisodeSource source;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          child: AspectRatio(aspectRatio: 1, child: _artwork(ref)),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.75),
                  spreadRadius: 1.5,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Text(
              podcast.title,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                height: 1.2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _artwork(WidgetRef ref) {
    if (source is DownloadedEpisodes) {
      final artwork = ref.watch(
        podcastLibraryProvider.select(
          (state) => state.value?.artworkByPodcastId[podcast.id],
        ),
      );

      if (artwork != null) return Image.file(artwork, fit: BoxFit.cover);
    }

    if (podcast.imageLink.isEmpty) {
      return const ColoredBox(color: FccColors.gray80);
    }

    return CachedNetworkImage(imageUrl: podcast.imageLink, fit: BoxFit.cover);
  }
}

class _Description extends StatelessWidget {
  const _Description({
    required this.description,
    required this.isExpanded,
    required this.onToggle,
  });

  final String description;
  final bool isExpanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    if (description.isEmpty) return const SizedBox.shrink();

    return ColoredBox(
      color: FccColors.gray90,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            Html(
              data: description,
              onLinkTap: (url, _, _) {
                if (url != null) launchUrl(Uri.parse(url));
              },
              style: {
                '#': Style(
                  fontSize: FontSize(16),
                  color: Colors.white.withValues(alpha: 0.87),
                  margin: Margins.zero,
                  maxLines: isExpanded ? null : 3,
                ),
              },
            ),
            TextButton(
              onPressed: onToggle,
              style: TextButton.styleFrom(
                shape: const RoundedRectangleBorder(),
              ),
              child: Text(
                isExpanded ? 'Show less' : 'Show more',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
