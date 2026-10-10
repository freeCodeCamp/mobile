import 'package:mobile_app_new/news/models/bookmarked_post_model.dart';
import 'package:mobile_app_new/news/services/bookmark_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bookmarks_controller.g.dart';

@riverpod
class NewsBookmarksNotifier extends _$NewsBookmarksNotifier {
  @override
  Future<List<BookmarkedPost>> build() {
    return ref.watch(newsBookmarkServiceProvider).getBookmarks();
  }

  Future<void> toggle(BookmarkedPost post) =>
      toggleById(post.id, () async => post);

  /// Retain the service while loading a summary's HTML so scrolling its tile
  /// offscreen cannot cancel an in-flight save.
  Future<void> toggleById(
    String id,
    Future<BookmarkedPost> Function() loadPost,
  ) async {
    final service = ref.read(newsBookmarkServiceProvider);
    final pendingSave = ref.keepAlive();
    try {
      if (await service.isBookmarked(id)) {
        await service.removeBookmark(id);
      } else {
        await service.addBookmark(await loadPost());
      }

      final bookmarks = await service.getBookmarks();
      if (ref.mounted) state = AsyncData(bookmarks);
    } finally {
      pendingSave.close();
    }
  }
}
