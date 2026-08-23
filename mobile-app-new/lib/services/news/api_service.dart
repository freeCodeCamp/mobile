import 'package:mobile_app_new/models/news/author_model.dart';
import 'package:mobile_app_new/models/news/post_model.dart';
import 'package:mobile_app_new/repositories/news_api_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_service.g.dart';

typedef PostsPage = ({
  String endCursor,
  bool hasNextPage,
  List<Post> posts,
});

@riverpod
NewsApiService newsApiService(Ref ref) {
  final repo = ref.watch(newsApiRepositoryProvider);
  return NewsApiService(repo);
}

class NewsApiService {
  final NewsApiRepository _repo;

  NewsApiService(this._repo);

  Future<PostsPage> getAllPosts({String afterCursor = ''}) async {
    final raw = await _repo.getAllPosts(afterCursor: afterCursor);
    final posts = raw.items
        .map((edge) => Post.fromJson(edge['node'] as Map<String, dynamic>))
        .toList();
    return (posts: posts, endCursor: raw.endCursor, hasNextPage: raw.hasNextPage);
  }

  Future<Post> getPostBySlug(String slug) async {
    final raw = await _repo.getPostBySlug(slug);
    return Post.fromJson(raw);
  }

  Future<Author> getAuthor(String authorSlug) async {
    final raw = await _repo.getAuthor(authorSlug);
    return Author.fromJson(raw);
  }

  Future<PostsPage> getPostsByAuthor(
    String authorId, {
    String afterCursor = '',
  }) async {
    final raw = await _repo.getPostsByAuthor(authorId, afterCursor: afterCursor);
    final posts = raw.items
        .map((edge) => Post.fromJson(edge['node'] as Map<String, dynamic>))
        .toList();
    return (posts: posts, endCursor: raw.endCursor, hasNextPage: raw.hasNextPage);
  }

  Future<PostsPage> getPostsByTag(
    String tagSlug, {
    String afterCursor = '',
  }) async {
    final raw = await _repo.getPostsByTag(tagSlug, afterCursor: afterCursor);
    final posts = raw.items
        .map((edge) => Post.fromJson(edge['node'] as Map<String, dynamic>))
        .toList();
    return (posts: posts, endCursor: raw.endCursor, hasNextPage: raw.hasNextPage);
  }
}
