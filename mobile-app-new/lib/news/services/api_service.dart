import 'package:mobile_app_new/news/models/author_model.dart';
import 'package:mobile_app_new/news/models/post_model.dart';
import 'package:mobile_app_new/news/models/post_summary_model.dart';
import 'package:mobile_app_new/news/repositories/api_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_service.g.dart';

typedef PostsPage = ({
  String endCursor,
  bool hasNextPage,
  List<PostSummary> posts,
});

@riverpod
NewsApiService newsApiService(Ref ref) {
  final repo = ref.watch(newsApiRepositoryProvider);
  return NewsApiService(repo);
}

class NewsApiService {
  final NewsApiRepository _repo;

  NewsApiService(this._repo);

  // The posts of a connection arrive wrapped in edge nodes.
  PostsPage _toPostsPage(RawPaginatedResponse raw) => (
    posts: raw.items
        .map(
          (edge) => PostSummary.fromJson(edge['node'] as Map<String, dynamic>),
        )
        .toList(),
    endCursor: raw.endCursor,
    hasNextPage: raw.hasNextPage,
  );

  Future<PostsPage> getAllPosts({String afterCursor = ''}) async =>
      _toPostsPage(await _repo.getAllPosts(afterCursor: afterCursor));

  Future<Post> getPostBySlug(String slug) async =>
      Post.fromJson(await _repo.getPostBySlug(slug));

  Future<Author> getAuthor(String authorSlug) async =>
      Author.fromJson(await _repo.getAuthor(authorSlug));

  Future<PostsPage> getPostsByAuthor(
    String authorId, {
    String afterCursor = '',
  }) async => _toPostsPage(
    await _repo.getPostsByAuthor(authorId, afterCursor: afterCursor),
  );

  Future<PostsPage> getPostsByTag(
    String tagSlug, {
    String afterCursor = '',
  }) async => _toPostsPage(
    await _repo.getPostsByTag(tagSlug, afterCursor: afterCursor),
  );
}
