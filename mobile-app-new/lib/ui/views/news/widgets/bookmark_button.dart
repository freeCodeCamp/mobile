import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app_new/models/news/bookmarked_post_model.dart';
import 'package:mobile_app_new/models/news/post_model.dart';
import 'package:mobile_app_new/ui/views/news/news-bookmark-feed/news_bookmark_feed_viewmodel.dart';
import 'package:mobile_app_new/ui/views/news/widgets/news_bottom_button.dart';

class BookmarkButton extends ConsumerWidget {
  const BookmarkButton({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarked = ref.watch(
      newsBookmarksProvider.select(
        (bookmarks) =>
            bookmarks.value?.any((b) => b.id == post.id) ?? false,
      ),
    );

    return NewsBottomButton(
      label: bookmarked ? 'Bookmarked' : 'Bookmark',
      icon: bookmarked ? Icons.bookmark_added : Icons.bookmark_add_outlined,
      onPressed: () => ref
          .read(newsBookmarksProvider.notifier)
          .toggle(BookmarkedPost.fromPost(post)),
      rightSided: false,
    );
  }
}
