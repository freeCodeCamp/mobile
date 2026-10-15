import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_app_new/news/controllers/feed_controller.dart';
import 'package:mobile_app_new/news/ui/widgets/post_tile.dart';
import 'package:mobile_app_new/news/ui/widgets/author_post_tile.dart';
import 'package:mobile_app_new/news/ui/widgets/news_load_error.dart';
import 'package:mobile_app_new/widgets/error_retry.dart';

class PostFeedList extends ConsumerStatefulWidget {
  const PostFeedList({
    super.key,
    required this.source,
    this.header,
    this.featured = false,
    this.compact = false,
    this.footer,
  });

  final NewsFeedSource source;
  final bool featured;
  final bool compact;
  final Widget? footer;

  // NOTE: The header is optional and can be used to display a widget above the
  // list of posts, such as author details or tag information.
  final Widget? header;

  @override
  ConsumerState<PostFeedList> createState() => _PostFeedListState();
}

class _PostFeedListState extends ConsumerState<PostFeedList> {
  final _scrollController = ScrollController();

  NewsFeedNotifierProvider get _provider => newsFeedProvider(widget.source);

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
    final feedAsync = ref.watch(_provider);

    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: feedAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            NewsLoadError(onRetry: () => ref.invalidate(_provider)),
        data: (feed) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(_provider);
            await ref
                .read(_provider.future)
                .then<void>((_) {}, onError: (_) {});
          },
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              if (widget.header case final header?)
                SliverToBoxAdapter(child: header),
              if (feed.posts.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text('No tutorials here yet.')),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  sliver: widget.compact
                      ? DecoratedSliver(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.outlineVariant,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          sliver: _buildList(feed),
                        )
                      : _buildList(feed),
                ),
              if (widget.footer case final footer?)
                SliverToBoxAdapter(child: footer),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(NewsFeedState feed) {
    final footer = _buildFooter(feed);

    return SliverList.separated(
      itemCount: feed.posts.length + (footer == null ? 0 : 1),
      separatorBuilder: (_, _) => Divider(
        color: Theme.of(context).colorScheme.outlineVariant,
        thickness: 1,
        height: 1,
      ),
      itemBuilder: (context, index) => index == feed.posts.length
          ? footer
          : widget.compact
          ? AuthorPostTile(
              key: ValueKey(feed.posts[index].id),
              post: feed.posts[index],
            )
          : PostTile(
              key: ValueKey(feed.posts[index].id),
              post: feed.posts[index],
              featured: widget.featured && index == 0,
            ),
    );
  }

  // Null when there is nothing to append: idle, or every page is loaded.
  Widget? _buildFooter(NewsFeedState feed) {
    if (feed.loadMoreError != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: ErrorRetry(
          message: 'Unable to load more tutorials.',
          onRetry: () =>
              ref.read(_provider.notifier).fetchNextPage(isRetry: true),
        ),
      );
    }

    if (feed.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return null;
  }
}
