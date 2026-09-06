import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile_app_new/news/models/post_model.dart';
import 'package:mobile_app_new/news/services/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_feed_list_state.freezed.dart';
part 'post_feed_list_state.g.dart';

@freezed
abstract class NewsFeedState with _$NewsFeedState {
  const factory NewsFeedState({
    @Default([]) List<Post> posts,
    @Default('') String cursor,
    @Default(true) bool hasNextPage,
    @Default(false) bool isLoadingMore,
    // NOTE: Set when appending a page failed; the posts already loaded stay valid.
    Object? loadMoreError,
  }) = _NewsFeedState;
}

@riverpod
class NewsFeedNotifier extends _$NewsFeedNotifier {
  @override
  FutureOr<NewsFeedState> build({
    String tagSlug = '',
    String authorId = '',
  }) async {
    final page = await _fetch('');

    return NewsFeedState(
      posts: page.posts,
      cursor: page.endCursor,
      hasNextPage: page.hasNextPage,
    );
  }

  Future<PostsPage> _fetch(String cursor) {
    final service = ref.read(newsApiServiceProvider);

    if (authorId.isNotEmpty) {
      return service.getPostsByAuthor(authorId, afterCursor: cursor);
    }
    if (tagSlug.isNotEmpty) {
      return service.getPostsByTag(tagSlug, afterCursor: cursor);
    }
    return service.getAllPosts(afterCursor: cursor);
  }

  Future<void> fetchNextPage({bool isRetry = false}) async {
    final current = state.value;
    if (current == null || !current.hasNextPage || current.isLoadingMore) return;

    // A failed append waits for an explicit retry instead of refiring on scroll.
    if (current.loadMoreError != null && !isRetry) return;

    state = AsyncData(
      current.copyWith(isLoadingMore: true, loadMoreError: null),
    );

    try {
      final page = await _fetch(current.cursor);

      state = AsyncData(
        current.copyWith(
          posts: [...current.posts, ...page.posts],
          cursor: page.endCursor,
          hasNextPage: page.hasNextPage,
          isLoadingMore: false,
        ),
      );
    } catch (error) {
      // Keep the loaded posts; only the append failed.
      state = AsyncData(
        current.copyWith(isLoadingMore: false, loadMoreError: error),
      );
    }
  }
}
