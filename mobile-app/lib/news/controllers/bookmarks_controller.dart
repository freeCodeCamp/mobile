import 'package:freecodecamp/news/models/bookmarked_post_model.dart';
import 'package:freecodecamp/news/models/post_model.dart';
import 'package:freecodecamp/news/services/api_service.dart';
import 'package:freecodecamp/news/services/bookmark_service.dart';
import 'package:freecodecamp/utils/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bookmarks_controller.g.dart';

@Riverpod(retry: noRetry)
class NewsBookmarksNotifier extends _$NewsBookmarksNotifier {
  @override
  Future<List<BookmarkedPost>> build() {
    return ref.watch(newsBookmarkServiceProvider).getBookmarks();
  }

  Future<void> toggle(BookmarkedPost post) =>
      _toggle((service) => service.toggle(post));

  Future<void> removeBookmarks(Set<String> ids) async {
    final service = ref.read(newsBookmarkServiceProvider);
    final pendingRemoval = ref.keepAlive();
    try {
      final bookmarks = await service.removeBookmarks(ids);
      if (ref.mounted) {
        state = AsyncData(bookmarks);
      }
    } finally {
      pendingRemoval.close();
    }
  }

  Future<void> togglePost(Post post) =>
      _toggle((service) => service.togglePost(post));

  Future<void> toggleSummary(String id, String slug) {
    final api = ref.read(newsApiServiceProvider);
    return _toggle(
      (service) => service.toggleSummary(id, slug, api.getPostBySlug),
    );
  }

  Future<void> toggleById(
    String id,
    Future<BookmarkedPost> Function() loadPost,
  ) => _toggle((service) => service.toggleById(id, loadPost));

  // Retain the service while loading a summary's HTML so scrolling its tile
  // offscreen cannot cancel an in-flight save.
  Future<void> _toggle(
    Future<List<BookmarkedPost>?> Function(NewsBookmarkService) toggle,
  ) async {
    final service = ref.read(newsBookmarkServiceProvider);
    final pendingSave = ref.keepAlive();
    try {
      final bookmarks = await toggle(service);
      if (bookmarks != null && ref.mounted) {
        state = AsyncData(bookmarks);
      }
    } finally {
      pendingSave.close();
    }
  }
}
