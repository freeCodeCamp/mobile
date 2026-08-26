import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/ui/views/news/widgets/post-feed-list/post_feed_list_state.dart';
import 'package:mobile_app_new/ui/views/news/widgets/post_tile.dart';

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

  bool get _hasNextPage => ref.read(_provider.notifier).hasNextPage;

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
    final postsAsync = ref.watch(_provider);

    return ColoredBox(
      color: FccColors.gray90,
      child: postsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            _ErrorView(onRetry: () => ref.invalidate(_provider)),
        data: (posts) => RefreshIndicator(
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
              SliverList.separated(
                itemCount: posts.length + (_hasNextPage ? 1 : 0),
                separatorBuilder: (_, _) => const Divider(
                  color: FccColors.gray80,
                  thickness: 1,
                  height: 1,
                ),
                itemBuilder: (context, index) => index == posts.length
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : PostTile(
                        key: ValueKey(posts[index].id),
                        post: posts[index],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Unable to load tutorials.', textAlign: TextAlign.center),
          const SizedBox(height: 12),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
