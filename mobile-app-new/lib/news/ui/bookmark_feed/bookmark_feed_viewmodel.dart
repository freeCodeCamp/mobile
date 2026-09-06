import 'package:mobile_app_new/news/models/bookmarked_post_model.dart';
import 'package:mobile_app_new/news/services/bookmark_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bookmark_feed_viewmodel.g.dart';

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
