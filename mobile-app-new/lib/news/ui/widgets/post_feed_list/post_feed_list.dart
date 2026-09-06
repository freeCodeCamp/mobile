import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/news/ui/widgets/post_feed_list/post_feed_list_state.dart';
import 'package:mobile_app_new/news/ui/widgets/post_tile.dart';
import 'package:mobile_app_new/widgets/error_retry.dart';

class PostFeedList extends ConsumerStatefulWidget {
  const PostFeedList({
    super.key,
    this.tagSlug = '',
    this.authorId = '',
    this.header,
  });

  final String tagSlug;
  final String authorId;

  // NOTE: The header is optional and can be used to display a widget above the
  // list of posts, such as author details or tag information.
  final Widget? header;

  @override
  ConsumerState<PostFeedList> createState() => _PostFeedListState();
}

class _PostFeedListState extends ConsumerState<PostFeedList> {
  final _scrollController = ScrollController();

  NewsFeedNotifierProvider get _provider =>
      newsFeedProvider(tagSlug: widget.tagSlug, authorId: widget.authorId);

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
      color: FccColors.gray90,
      child: feedAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorRetry(
          message: 'Unable to load tutorials.',
          onRetry: () => ref.invalidate(_provider),
        ),
        data: (feed) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(_provider),
          backgroundColor: FccColors.gray90,
          color: Colors.white,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              if (widget.header case final header?)
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      header,
                      const Divider(
                        color: FccColors.gray80,
                        thickness: 1,
                        height: 1,
                      ),
                    ],
                  ),
                ),
              _buildList(feed),
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
      separatorBuilder: (_, _) =>
          const Divider(color: FccColors.gray80, thickness: 1, height: 1),
      itemBuilder: (context, index) => index == feed.posts.length
          ? footer
          : PostTile(
              key: ValueKey(feed.posts[index].id),
              post: feed.posts[index],
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
