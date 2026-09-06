import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/fcc_theme.dart';
import 'package:mobile_app_new/models/news/bookmarked_post_model.dart';
import 'package:mobile_app_new/routing/news.dart';
import 'package:mobile_app_new/ui/views/news/bookmark-feed/bookmark_feed_viewmodel.dart';
import 'package:mobile_app_new/ui/core/widgets/error_retry.dart';

class NewsBookmarkFeedView extends ConsumerWidget {
  const NewsBookmarkFeedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(newsBookmarksProvider);

    return RefreshIndicator(
      backgroundColor: FccColors.gray90,
      color: Colors.white,
      onRefresh: () => ref.refresh(newsBookmarksProvider.future),
      child: bookmarks.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorRetry(
          message: 'Unable to load bookmarks.',
          onRetry: () => ref.invalidate(newsBookmarksProvider),
        ),
        data: (posts) =>
            posts.isEmpty ? const _EmptyState() : _BookmarkList(posts: posts),
      ),
    );
  }
}

// Scrollable so RefreshIndicator still works with nothing in the list.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 96),
          child: Text(
            'Bookmark tutorials to view them here',
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _BookmarkList extends StatelessWidget {
  const _BookmarkList({required this.posts});

  final List<BookmarkedPost> posts;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: posts.length,
      separatorBuilder: (context, i) => const Divider(color: Colors.white),
      itemBuilder: (context, index) {
        final post = posts[index];

        return ListTile(
          title: Text(post.title),
          trailing: const Icon(Icons.arrow_forward_ios_sharp),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text('Written by: ${post.authorName}'),
          ),
          contentPadding: const EdgeInsets.all(16),
          minVerticalPadding: 8,
          onTap: () =>
              NewsBookmarkPostRoute(id: post.id, $extra: post).push(context),
        );
      },
    );
  }
}
