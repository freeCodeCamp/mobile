import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_post_model.freezed.dart';
part 'search_post_model.g.dart';

@freezed
abstract class SearchAuthor with _$SearchAuthor {
  const factory SearchAuthor({required String name, String? profileImage}) =
      _SearchAuthor;

  factory SearchAuthor.fromJson(Map<String, Object?> json) =>
      _$SearchAuthorFromJson(json);
}

// Algolia search result post model
@freezed
abstract class SearchPost with _$SearchPost {
  const SearchPost._();

  const factory SearchPost({
    required String objectID,
    required String title,
    required String url,
    required SearchAuthor author,
    String? featureImage,
    String? publishedAt,
  }) = _SearchPost;

  factory SearchPost.fromJson(Map<String, Object?> json) =>
      _$SearchPostFromJson(json);

  // NOTE: Algolia search results do not include the slug, so we derive it from the URL.
  String get slug {
    final segments = Uri.parse(url).pathSegments.where((s) => s.isNotEmpty);
    return segments.isEmpty ? '' : segments.last;
  }
}
