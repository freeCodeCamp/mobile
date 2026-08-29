import 'package:mobile_app_new/models/news/bookmarked_post_model.dart';
import 'package:mobile_app_new/services/news/bookmark_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'news_bookmark_feed_viewmodel.g.dart';

// Single source of truth for bookmarks. The feed watches it directly and
// BookmarkButton selects its own id out of it, so a toggle anywhere is
// reflected everywhere without a manual resync.
@riverpod
class NewsBookmarksNotifier extends _$NewsBookmarksNotifier {
  @override
  Future<List<BookmarkedPost>> build() {
    return ref.watch(newsBookmarkServiceProvider).getBookmarks();
  }

  Future<void> toggle(BookmarkedPost post) async {
    final service = ref.read(newsBookmarkServiceProvider);

    if (await service.isBookmarked(post.id)) {
      await service.removeBookmark(post.id);
    } else {
      await service.addBookmark(post);
    }

    state = AsyncData(await service.getBookmarks());
  }
}
