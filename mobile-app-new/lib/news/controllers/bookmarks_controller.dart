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
    final generation = service.resetGeneration;
    final pendingSave = ref.keepAlive();
    try {
      final saved = await service.isBookmarked(id);
      if (generation != service.resetGeneration) return;
      if (saved) {
        await service.removeBookmark(id);
      } else {
        final post = await loadPost();
        if (generation != service.resetGeneration) return;
        await service.addBookmark(post);
      }

      final bookmarks = await service.getBookmarks();
      if (ref.mounted) state = AsyncData(bookmarks);
    } finally {
      pendingSave.close();
    }
  }
}
