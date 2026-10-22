import 'package:freecodecamp/news/models/post_summary_model.dart';
import 'package:freecodecamp/news/services/api_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_controller.freezed.dart';
part 'feed_controller.g.dart';

// Which posts a feed shows. Exactly one mode, checked by the compiler.
@freezed
sealed class NewsFeedSource with _$NewsFeedSource {
  const factory NewsFeedSource.all() = AllPosts;
  const factory NewsFeedSource.tag(String slug) = TagPosts;
  const factory NewsFeedSource.author(String id) = AuthorPosts;
}

@freezed
abstract class NewsFeedState with _$NewsFeedState {
  const factory NewsFeedState({
    @Default([]) List<PostSummary> posts,
    @Default('') String cursor,
    @Default(true) bool hasNextPage,
    @Default(false) bool isLoadingMore,
    // NOTE: Set when appending a page failed; the posts already loaded stay valid.
    Object? loadMoreError,
  }) = _NewsFeedState;
}

@riverpod
class NewsFeedNotifier extends _$NewsFeedNotifier {
  // NOTE: A refresh keeps this notifier mounted, so a page fetched before it is told apart by this.
  int _generation = 0;

  @override
  FutureOr<NewsFeedState> build(NewsFeedSource source) async {
    _generation++;
    final page = await _fetch(ref.watch(newsApiServiceProvider), '');

    return NewsFeedState(
      posts: page.posts,
      cursor: page.endCursor,
      hasNextPage: page.hasNextPage,
    );
  }

  Future<PostsPage> _fetch(
    NewsApiService service,
    String cursor,
  ) => switch (source) {
    AllPosts() => service.getAllPosts(afterCursor: cursor),
    TagPosts(:final slug) => service.getPostsByTag(slug, afterCursor: cursor),
    AuthorPosts(:final id) => service.getPostsByAuthor(id, afterCursor: cursor),
  };

  Future<void> fetchNextPage({bool isRetry = false}) async {
    final current = state.value;
    if (current == null || !current.hasNextPage || current.isLoadingMore) {
      return;
    }

    // A failed append waits for an explicit retry instead of refiring on scroll.
    if (current.loadMoreError != null && !isRetry) return;

    final generation = _generation;
    state = AsyncData(
      current.copyWith(isLoadingMore: true, loadMoreError: null),
    );

    try {
      final page = await _fetch(
        ref.read(newsApiServiceProvider),
        current.cursor,
      );
      if (!ref.mounted || generation != _generation) return;

      state = AsyncData(
        current.copyWith(
          posts: [...current.posts, ...page.posts],
          cursor: page.endCursor,
          hasNextPage: page.hasNextPage,
          isLoadingMore: false,
        ),
      );
    } catch (error) {
      if (!ref.mounted || generation != _generation) return;
      // Keep the loaded posts; only the append failed.
      state = AsyncData(
        current.copyWith(isLoadingMore: false, loadMoreError: error),
      );
    }
  }
}
