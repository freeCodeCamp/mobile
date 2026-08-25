import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/ui/views/news/news-feed/post_feed_list_viewmodel.dart';
import 'package:mobile_app_new/ui/views/news/widgets/post_tile.dart';

class PostFeedList extends ConsumerStatefulWidget {
  const PostFeedList({super.key, this.tagSlug = ''});

  final String tagSlug;

  @override
  ConsumerState<PostFeedList> createState() => _PostFeedListState();
}

class _PostFeedListState extends ConsumerState<PostFeedList> {
  final _scrollController = ScrollController();

  NewsFeedNotifierProvider get _provider =>
      newsFeedProvider(tagSlug: widget.tagSlug);

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
            _ErrorView(error: error, onRetry: () => ref.invalidate(_provider)),
        data: (posts) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(_provider),
          backgroundColor: FccColors.gray90,
          color: Colors.white,
          child: ListView.separated(
            controller: _scrollController,
            itemCount: posts.length + 1,
            separatorBuilder: (_, _) =>
                const Divider(color: FccColors.gray80, thickness: 1, height: 1),
            itemBuilder: (context, index) {
              if (index == posts.length) {
                return _buildLoadingIndicator();
              }
              return PostTile(
                key: ValueKey(posts[index].id),
                post: posts[index],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    if (!ref.read(_provider.notifier).hasNextPage) {
      return const SizedBox.shrink();
    }

    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});

  final Object error;
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
