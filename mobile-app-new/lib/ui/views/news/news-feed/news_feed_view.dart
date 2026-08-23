import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/ui/views/news/news-feed/news_feed_viewmodel.dart';
import 'package:mobile_app_new/ui/views/news/widgets/post_tile.dart';

class NewsFeedView extends ConsumerStatefulWidget {
  const NewsFeedView({super.key});

  @override
  ConsumerState<NewsFeedView> createState() => _NewsFeedViewState();
}

class _NewsFeedViewState extends ConsumerState<NewsFeedView> {
  final _scrollController = ScrollController();

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
      ref.read(newsFeedProvider.notifier).fetchNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(newsFeedProvider);

    return ColoredBox(
      color: FccColors.gray90,
      child: postsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _ErrorView(
          error: error,
          onRetry: () => ref.invalidate(newsFeedProvider),
        ),
        data: (posts) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(newsFeedProvider),
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
    final notifier = ref.read(newsFeedProvider.notifier);
    if (!notifier.hasNextPage) {
      log('No more pages to load');
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
    log('Error loading news feed: $error');
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
